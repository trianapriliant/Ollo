import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../domain/update_log.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class UpdateLogScreen extends StatelessWidget {
  const UpdateLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = UpdateLog.logs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.updateLog ?? 'Update Log', style: AppTextStyles.h2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                 BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: log.isBeta ? Colors.orangeAccent.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        log.version,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: log.isBeta ? Colors.orange[800] : Colors.green[800],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('dd MMM yyyy').format(log.date),
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...log.changes.map((change) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Icon(Icons.circle, size: 6, color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          change,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}
