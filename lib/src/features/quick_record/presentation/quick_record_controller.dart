import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../transactions/domain/transaction.dart';
import '../application/quick_record_service.dart';
import '../../settings/presentation/voice_language_provider.dart';

enum QuickRecordState { initial, listening, processing, review, error }

class QuickRecordStateData {
  final QuickRecordState state;
  final String recognizedText;
  final Transaction? draftTransaction;
  final String? errorMessage;
  final String? detectedCategoryName;
  final String? detectedSubCategoryName;
  final String? detectedWalletName; // New field

  QuickRecordStateData({
    this.state = QuickRecordState.initial,
    this.recognizedText = '',
    this.draftTransaction,
    this.errorMessage,
    this.detectedCategoryName,
    this.detectedSubCategoryName,
    this.detectedWalletName,
  });

  QuickRecordStateData copyWith({
    QuickRecordState? state,
    String? recognizedText,
    Transaction? draftTransaction,
    String? errorMessage,
    String? detectedCategoryName,
    String? detectedSubCategoryName,
    String? detectedWalletName,
  }) {
    return QuickRecordStateData(
      state: state ?? this.state,
      recognizedText: recognizedText ?? this.recognizedText,
      draftTransaction: draftTransaction ?? this.draftTransaction,
      errorMessage: errorMessage ?? this.errorMessage,
      detectedCategoryName: detectedCategoryName ?? this.detectedCategoryName,
      detectedSubCategoryName: detectedSubCategoryName ?? this.detectedSubCategoryName,
      detectedWalletName: detectedWalletName ?? this.detectedWalletName,
    );
  }
}

class QuickRecordController extends StateNotifier<QuickRecordStateData> {
  final QuickRecordService _service;
  final String _localeCode; // Store locale code
  final SpeechToText _speechToText = SpeechToText();
  final _textRecognizer = TextRecognizer();
  final _picker = ImagePicker();

  QuickRecordController(this._service, this._localeCode) : super(QuickRecordStateData());

  Future<void> startChat() async {
    state = state.copyWith(state: QuickRecordState.initial);
  }

  Future<void> processText(String text) async {
    if (text.isEmpty) return;
    state = state.copyWith(state: QuickRecordState.processing, recognizedText: text);
    try {
      final result = await _service.parseTransaction(text, languageCode: _localeCode);
      state = state.copyWith(
        state: QuickRecordState.review, 
        draftTransaction: result.transaction,
        detectedCategoryName: result.categoryName,
        detectedSubCategoryName: result.subCategoryName,
        detectedWalletName: result.walletName, 
      );
    } catch (e) {
      state = state.copyWith(state: QuickRecordState.error, errorMessage: e.toString());
    }
  }

  Future<void> startVoice() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      state = state.copyWith(state: QuickRecordState.error, errorMessage: 'Voice input tidak tersedia di Desktop');
      return;
    }
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      state = state.copyWith(state: QuickRecordState.error, errorMessage: 'Microphone permission denied');
      return;
    }

    bool available = await _speechToText.initialize(
      onError: (error) {
        state = state.copyWith(state: QuickRecordState.error);
      },
      onStatus: (status) {
         if (status == 'done' && state.state == QuickRecordState.listening && state.recognizedText.isEmpty) {
             state = state.copyWith(state: QuickRecordState.error);
         }
      },
    );

    if (available) {
      state = state.copyWith(state: QuickRecordState.listening, recognizedText: '', errorMessage: null);
      _speechToText.listen(
        onResult: (result) {
          state = state.copyWith(recognizedText: result.recognizedWords);
          if (result.finalResult) {
            processText(result.recognizedWords);
            _speechToText.stop();
          }
        },
        localeId: _localeCode, 
        cancelOnError: true,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5), 
      );
    } else {
      state = state.copyWith(state: QuickRecordState.error, errorMessage: 'Speech recognition unavailable');
    }
  }

  Future<void> stopVoice() async {
    await _speechToText.stop();
    if (state.recognizedText.isNotEmpty) {
      processText(state.recognizedText);
    } else {
      state = state.copyWith(state: QuickRecordState.error);
    }
  }

  Future<void> startScan() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      state = state.copyWith(state: QuickRecordState.error, errorMessage: 'OCR fitur ini hanya tersedia di Android/iOS');
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return; 

      state = state.copyWith(state: QuickRecordState.processing);
      
      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      String fullText = recognizedText.text;
      processText(fullText);
      
    } catch (e) {
      state = state.copyWith(state: QuickRecordState.error, errorMessage: e.toString());
    }
  }

  // Process image from camera/gallery
  Future<void> processImage(String path) async {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        state = state.copyWith(state: QuickRecordState.error, errorMessage: 'OCR fitur ini hanya tersedia di Android/iOS');
        return;
      }
      try {
        state = state.copyWith(state: QuickRecordState.processing);

        final inputImage = InputImage.fromFilePath(path);
        final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
        final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
        
        List<TextLine> allLines = [];
        for (TextBlock block in recognizedText.blocks) {
          allLines.addAll(block.lines);
        }

        allLines.sort((a, b) {
           double yDiff = (a.boundingBox.top - b.boundingBox.top).abs();
           if (yDiff < 20) { 
              return a.boundingBox.left.compareTo(b.boundingBox.left);
           }
           return a.boundingBox.top.compareTo(b.boundingBox.top);
        });

        String fullText = allLines.map((e) => e.text).join('\n');
        
        await textRecognizer.close();

        if (fullText.isNotEmpty) {
           processText(fullText);
        } else {
           state = state.copyWith(state: QuickRecordState.error, errorMessage: 'No text found in image');
        }

      } catch (e) {
         state = state.copyWith(state: QuickRecordState.error, errorMessage: 'Failed to process image');
      }
  }
}

final quickRecordControllerProvider = StateNotifierProvider<QuickRecordController, QuickRecordStateData>((ref) {
  final service = ref.watch(quickRecordServiceProvider);
  final voiceLanguage = ref.watch(voiceLanguageProvider); // Watch setting
  return QuickRecordController(service, voiceLanguage.code); // Pass code
});
