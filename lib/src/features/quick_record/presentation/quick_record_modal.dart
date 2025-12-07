import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../presentation/quick_record_controller.dart';
import '../../transactions/domain/transaction.dart';

// RE-VERIFYING PATHS:
// File: lib/src/features/quick_record/presentation/quick_record_modal.dart
// constants: lib/src/constants
// Path: ../ (quick_record) ../ (features) ../ (src) / constants
// So it is ../../../constants. 
// BUT, in the previous error, I saw:
// "lib/src/features/quick_record/presentation/quick_record_modal.dart:4:8: Error: Error when reading 'lib/constants/app_colors.dart'"
// when using ../../../../.
// Because ../../../../ goes to lib/constants.
// So I MUST use ../../../constants.

class QuickRecordModal extends ConsumerStatefulWidget {
  final String initialMode; // 'chat', 'voice', 'scan'

  const QuickRecordModal({super.key, required this.initialMode});

  @override
  ConsumerState<QuickRecordModal> createState() => _QuickRecordModalState();
}

class _QuickRecordModalState extends ConsumerState<QuickRecordModal> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize based on mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(quickRecordControllerProvider.notifier);
      if (widget.initialMode == 'voice') {
        controller.startVoice();
      } else if (widget.initialMode == 'scan') {
        controller.startScan();
      } else {
        controller.startChat();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quickRecordControllerProvider);

    // Sync text controller with state text if in listening mode
    if (state.state == QuickRecordState.listening && _textController.text != state.recognizedText) {
      _textController.text = state.recognizedText;
    }

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Removed mainAxisSize from Container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min, // Moved here
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.initialMode == 'voice' ? 'Listening...' : 'Quick Record',
                style: AppTextStyles.h3,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Content
          if (state.state == QuickRecordState.review)
            _buildReviewView(state, context)
          else if (state.state == QuickRecordState.listening)
             _buildListeningView(state)
          else
            _buildInputView(state, context),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildListeningView(QuickRecordStateData state) {
    return Column(
      children: [
        const Icon(Icons.mic, size: 60, color: AppColors.primary),
        const SizedBox(height: 16),
         Text(
          state.recognizedText.isEmpty ? "Say 'Makan 50k'..." : state.recognizedText,
          style: AppTextStyles.h2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            ref.read(quickRecordControllerProvider.notifier).stopVoice();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Stop & Process'),
        ),
      ],
    );
  }

  Widget _buildInputView(QuickRecordStateData state, BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _textController,
          decoration: InputDecoration(
            hintText: 'e.g. "Lunch 50k", "Gaji 10jt"',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send, color: AppColors.primary),
              onPressed: () {
                ref.read(quickRecordControllerProvider.notifier).processText(_textController.text);
              },
            ),
          ),
          autofocus: widget.initialMode == 'chat',
          onSubmitted: (val) {
             ref.read(quickRecordControllerProvider.notifier).processText(val);
          },
        ),
        if (state.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(state.errorMessage!, style: const TextStyle(color: Colors.red)),
          ),
      ],
    );
  }

  Widget _buildReviewView(QuickRecordStateData state, BuildContext context) {
    final txn = state.draftTransaction!;
    return Card(
      color: AppColors.cardBackground,
      child: padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             Row(
               children: [
                 const Icon(Icons.check_circle, color: Colors.green),
                 const SizedBox(width: 8),
                 Text('Draft Ready', style: AppTextStyles.bodyLarge),
               ],
             ),
             const Divider(),
             _row('Title', txn.title),
             _row('Amount', 'Rp ${txn.amount.toStringAsFixed(0)}'), // TODO: Format currency
             _row('Category', state.detectedSubCategoryName != null 
                 ? '${state.detectedCategoryName} > ${state.detectedSubCategoryName}'
                 : (state.detectedCategoryName ?? 'Not Found')),
             _row('Type', txn.type.name.toUpperCase()),
             _row('Note', txn.note ?? '-'),
             const SizedBox(height: 16),
             Row(
               children: [
                 Expanded(
                   child: OutlinedButton(
                     onPressed: () {
                         // Edit - for now just go back to input with text
                         ref.read(quickRecordControllerProvider.notifier).startChat();
                     },
                     child: const Text('Edit'),
                   ),
                 ),
                 const SizedBox(width: 12),
                 Expanded(
                   child: ElevatedButton(
                     onPressed: () {
                       // Open AddTransactionScreen with pre-filled data
                       context.pop(); // Close modal
                       // Navigate to Add Transaction with 'extra'
                       // NOTE: You need to ensure your Router handles 'extra' transaction object
                       context.push('/add-transaction', extra: txn);
                     },
                     style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                     child: const Text('Save / Adjust'),
                   ),
                 ),
               ],
             )
          ],
        ),
      ),
    );
  }
  
  Widget padding({required EdgeInsets padding, required Widget child}) {
      return Padding(padding: padding, child: child);
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
