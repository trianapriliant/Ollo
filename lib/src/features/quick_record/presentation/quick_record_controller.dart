import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../transactions/domain/transaction.dart';
import '../application/quick_record_service.dart';

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
  final SpeechToText _speechToText = SpeechToText();
  final _textRecognizer = TextRecognizer();
  final _picker = ImagePicker();

  QuickRecordController(this._service) : super(QuickRecordStateData());

  Future<void> startChat() async {
    state = state.copyWith(state: QuickRecordState.initial);
  }

  Future<void> processText(String text) async {
    if (text.isEmpty) return;
    state = state.copyWith(state: QuickRecordState.processing, recognizedText: text);
    try {
      final result = await _service.parseTransaction(text);
      state = state.copyWith(
        state: QuickRecordState.review, 
        draftTransaction: result.transaction,
        detectedCategoryName: result.categoryName,
        detectedSubCategoryName: result.subCategoryName,
        detectedWalletName: result.walletName, // Map new field
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
        // Just set error state, let UI show red button. Keep text if any.
        state = state.copyWith(state: QuickRecordState.error);
      },
      onStatus: (status) {
         if (status == 'done' && state.state == QuickRecordState.listening && state.recognizedText.isEmpty) {
             // Silence/Timeout -> Error state (Red button)
             state = state.copyWith(state: QuickRecordState.error);
         }
      },
    );

    if (available) {
      state = state.copyWith(state: QuickRecordState.listening, recognizedText: '', errorMessage: null); // Clear error
      _speechToText.listen(
        onResult: (result) {
          state = state.copyWith(recognizedText: result.recognizedWords);
          if (result.finalResult) {
            processText(result.recognizedWords);
            _speechToText.stop();
          }
        },
        localeId: 'id_ID', 
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
      // Manual stop with no text -> Error state (Red button)
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
      if (image == null) return; // User canceled

      state = state.copyWith(state: QuickRecordState.processing);
      
      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      // Simple strategy: Join all lines? Or try to find the Total?
      // For V1 Quick Record "Scan", let's just dump all text and let parser find the number.
      // A better strategy is needed for Receipts (filtering for largest number etc).
      String fullText = recognizedText.text;
      
      // Let's try to pass it to parser.
      // Let's try to pass it to parser.
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
        
        // --- SMART ROW SORTING LOGIC ---
        // 1. Collect all lines
        List<TextLine> allLines = [];
        for (TextBlock block in recognizedText.blocks) {
          allLines.addAll(block.lines);
        }

        // 2. Sort primarily by Top (Y), secondarily by Left (X)
        // Group lines into "rows" based on Y overlapping
        // Threshold: 10 pixels vertical difference considered same row
        allLines.sort((a, b) {
           double yDiff = (a.boundingBox.top - b.boundingBox.top).abs();
           if (yDiff < 20) { // Same visual row
              return a.boundingBox.left.compareTo(b.boundingBox.left);
           }
           return a.boundingBox.top.compareTo(b.boundingBox.top);
        });

        // 3. Join textual content
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
  return QuickRecordController(service);
});
