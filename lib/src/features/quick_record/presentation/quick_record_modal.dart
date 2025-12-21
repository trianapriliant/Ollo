import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../presentation/quick_record_controller.dart';
import '../../transactions/domain/transaction.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';
import 'package:intl/intl.dart';

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

    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85, 
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      height: (state.state == QuickRecordState.listening || state.state == QuickRecordState.error || state.state == QuickRecordState.review)
          ? MediaQuery.of(context).size.height * 0.60
          : MediaQuery.of(context).size.height * 0.35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min, // Moved here
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                  Text(
                    widget.initialMode == 'voice' 
                        ? AppLocalizations.of(context)!.listeningMessage 
                        : AppLocalizations.of(context)!.quickRecordTitle,
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

           // Footer Button (Stop & Process) - Fixed at bottom
           if (state.state == QuickRecordState.listening) ...[
               Container(
                 width: double.infinity,
                 height: 56,
                 margin: const EdgeInsets.only(bottom: 50), // Clears FAB
                 decoration: BoxDecoration(
                   gradient: const LinearGradient(
                     colors: [Color(0xFF1DE9B6), Color(0xFF00BFA5)], 
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
                   child: Text(
                     AppLocalizations.of(context)!.stopAndProcess,
                     style: const TextStyle(
                       color: Colors.white, 
                       fontSize: 16, 
                       fontWeight: FontWeight.bold
                     ),
                   ),
                 ),
               ),
           ],
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
        if (state.errorMessage != null || state.recognizedText.isNotEmpty) ...[
           const SizedBox(height: 24),
           Text(
            state.errorMessage ?? state.recognizedText,
            style: isError ? AppTextStyles.h3.copyWith(color: Colors.red) : AppTextStyles.h2,
            textAlign: TextAlign.center,
           ),
        ],
      const SizedBox(height: 24),
      // Always show tips!
      const _RotatingHelpText(), 
      const SizedBox(height: 24),
    
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
            hintText: AppLocalizations.of(context)!.textInputHint,
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
                   Text(AppLocalizations.of(context)!.draftReady, style: AppTextStyles.bodyLarge),
                 ],
               ),
               const Divider(),
                _row(AppLocalizations.of(context)!.titleLabel, txn.title),
                _row(AppLocalizations.of(context)!.amount, NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(txn.amount)),
                _row(AppLocalizations.of(context)!.date, DateFormat('dd MMM yyyy').format(txn.date)),
                _row(AppLocalizations.of(context)!.wallet, state.detectedWalletName ?? 'Default'),
                _row(AppLocalizations.of(context)!.category, state.detectedSubCategoryName != null 
                    ? '${state.detectedCategoryName} > ${state.detectedSubCategoryName}'
                    : (state.detectedCategoryName ?? AppLocalizations.of(context)!.notFound)),
                _row(AppLocalizations.of(context)!.typeLabel, txn.type.name.toUpperCase()), // Used typeLabel "Type"
                _row(AppLocalizations.of(context)!.note, txn.note ?? '-'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                            // Edit - for now just go back to input with text
                            ref.read(quickRecordControllerProvider.notifier).startChat();
                        },
                        child: Text(AppLocalizations.of(context)!.edit),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Return transaction to caller
                          context.pop(txn); 
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        child: Text(AppLocalizations.of(context)!.saveAdjust),
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

class _RotatingHelpText extends StatefulWidget {
  const _RotatingHelpText();

  @override
  State<_RotatingHelpText> createState() => _RotatingHelpTextState();
}

class _RotatingHelpTextState extends State<_RotatingHelpText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      _controller.reverse().then((_) {
        if (!mounted) return;
        setState(() {
          _index++;
        });
        _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hints = [
      AppLocalizations.of(context)!.quickRecordHelp1,
      AppLocalizations.of(context)!.quickRecordHelp2,
      AppLocalizations.of(context)!.quickRecordHelp3,
      AppLocalizations.of(context)!.quickRecordHelp4,
      AppLocalizations.of(context)!.quickRecordHelp5,
      AppLocalizations.of(context)!.quickRecordHelp6,
      AppLocalizations.of(context)!.quickRecordHelp7,
      AppLocalizations.of(context)!.quickRecordHelp8,
      AppLocalizations.of(context)!.quickRecordHelp9,
      AppLocalizations.of(context)!.quickRecordHelp10,
    ];

    return FadeTransition(
      opacity: _opacity,
      child: Column(
        children: [
            Text(
              AppLocalizations.of(context)!.quickRecordHelpTitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              hints[_index % hints.length], // Safe modulo
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary, 
                fontStyle: FontStyle.italic
              ),
              textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
