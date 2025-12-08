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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(quickRecordControllerProvider.notifier);
      if (widget.initialMode == 'voice') {
        controller.startVoice();
      } else if (widget.initialMode == 'scan') {
        // Open In-App Camera directly
        // We probably need to close this modal or keep it open?
        // User flow: Modal opens -> immediately pushes Camera Screen -> captures -> returns path -> process.
        
        // Wait for push to return
        // Note: We need to handle this carefully.
        if (mounted) {
             final result = await context.push<String>('/scan-receipt');
             if (result != null && mounted) {
                 controller.processImage(result);
             }
        }
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
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85, // Max 85% screen height
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Fixed height for Voice (stability), Auto height for Chat/Review (wrap content up to max)
      height: (state.state == QuickRecordState.listening || state.state == QuickRecordState.error)
          ? MediaQuery.of(context).size.height * 0.45
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min, // Moved here
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.initialMode == 'voice' ? 'Ollo AI is Listening...' : 'Quick Record',
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
          if (state.state == QuickRecordState.listening || state.state == QuickRecordState.error)
            Expanded(
              child: SingleChildScrollView(
                child: _buildListeningView(state),
              ),
            )
          else if (state.state == QuickRecordState.review)
             Flexible( // Allow scrolling within constraints
               fit: FlexFit.loose,
               child: _buildReviewView(state, context)
             )
          else
             Flexible(
               fit: FlexFit.loose, 
               child: _buildInputView(state, context)
             ),

           // Add some bottom padding if not full height
           const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildListeningView(QuickRecordStateData state) {
    bool isError = state.state == QuickRecordState.error;
    
    return Column(
      children: [
        GestureDetector(
          onTap: () {
             final controller = ref.read(quickRecordControllerProvider.notifier);
             if (state.state == QuickRecordState.listening) {
               controller.stopVoice();
             } else {
               controller.startVoice(); // Retry
             }
          },
          child: Stack(
             alignment: Alignment.center,
             children: [
               if (state.state == QuickRecordState.listening)
                 const PulseAnimation(),
               Container(
                 padding: const EdgeInsets.all(20),
                 decoration: BoxDecoration(
                   color: isError ? Colors.red.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                   shape: BoxShape.circle,
                 ),
                 child: Icon(
                   isError ? Icons.refresh : Icons.mic, 
                   size: 50, 
                   color: isError ? Colors.red : AppColors.primary
                 ),
               ),
             ],
          ),
        ),
        const SizedBox(height: 24),
         Text(
          state.errorMessage ?? (state.recognizedText.isEmpty ? "Say 'Makan 50k'..." : state.recognizedText),
          style: isError ? AppTextStyles.h3.copyWith(color: Colors.red) : AppTextStyles.h2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        if (!isError) ...[
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1DE9B6), Color(0xFF00BFA5)], // Aquamarine / Teal Accent gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1DE9B6).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                ref.read(quickRecordControllerProvider.notifier).stopVoice();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text(
                'Stop & Process',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 16, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 60), 
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
    return SingleChildScrollView( // Scrollable to prevent bottom overflow
      child: Card(
        color: AppColors.cardBackground,
        child: padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
             mainAxisSize: MainAxisSize.min, // Wrap content
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
        crossAxisAlignment: CrossAxisAlignment.start, // Align to top for multi-line
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(width: 8), // Spacing
          Flexible( // Allow text to wrap
            child: Text(
              value, 
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right, // Right align values
            ),
          ),
        ],
      ),
    );
  }
}

class PulseAnimation extends StatefulWidget {
  const PulseAnimation({super.key});

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildCircle(0.0),
          _buildCircle(0.5),
          _buildCircle(0.75),
        ],
      ),
    );
  }

  Widget _buildCircle(double delay) {
    return ScaleTransition(
      scale: Tween(begin: 0.5, end: 1.5).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(delay, 1.0, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: Tween(begin: 0.5, end: 0.0).animate(
           CurvedAnimation(
            parent: _controller,
            curve: Interval(delay, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
