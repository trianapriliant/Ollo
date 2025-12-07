import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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

  QuickRecordStateData({
    this.state = QuickRecordState.initial,
    this.recognizedText = '',
    this.draftTransaction,
    this.errorMessage,
    this.detectedCategoryName,
    this.detectedSubCategoryName,
  });

  QuickRecordStateData copyWith({
    QuickRecordState? state,
    String? recognizedText,
    Transaction? draftTransaction,
    String? errorMessage,
    String? detectedCategoryName,
    String? detectedSubCategoryName,
  }) {
    return QuickRecordStateData(
      state: state ?? this.state,
      recognizedText: recognizedText ?? this.recognizedText,
      draftTransaction: draftTransaction ?? this.draftTransaction,
      errorMessage: errorMessage ?? this.errorMessage,
      detectedCategoryName: detectedCategoryName ?? this.detectedCategoryName,
      detectedSubCategoryName: detectedSubCategoryName ?? this.detectedSubCategoryName,
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
      );
    } catch (e) {
      state = state.copyWith(state: QuickRecordState.error, errorMessage: e.toString());
    }
  }

  Future<void> startVoice() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      state = state.copyWith(state: QuickRecordState.error, errorMessage: 'Microphone permission denied');
      return;
    }

    bool available = await _speechToText.initialize();
    if (available) {
      state = state.copyWith(state: QuickRecordState.listening, recognizedText: '');
      _speechToText.listen(
        onResult: (result) {
          state = state.copyWith(recognizedText: result.recognizedWords);
          if (result.finalResult) {
            processText(result.recognizedWords);
            _speechToText.stop();
          }
        },
        localeId: 'id_ID', // Default to Indo for now, maybe configurable later
      );
    } else {
      state = state.copyWith(state: QuickRecordState.error, errorMessage: 'Speech recognition not available');
    }
  }

  Future<void> stopVoice() async {
    await _speechToText.stop();
    if (state.recognizedText.isNotEmpty) {
      processText(state.recognizedText);
    } else {
      state = state.copyWith(state: QuickRecordState.initial); // Back to start if nothing heard
    }
  }

  Future<void> startScan() async {
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
      processText(fullText);
      
    } catch (e) {
      state = state.copyWith(state: QuickRecordState.error, errorMessage: e.toString());
    }
  }
}

final quickRecordControllerProvider = StateNotifierProvider<QuickRecordController, QuickRecordStateData>((ref) {
  final service = ref.watch(quickRecordServiceProvider);
  return QuickRecordController(service);
});
