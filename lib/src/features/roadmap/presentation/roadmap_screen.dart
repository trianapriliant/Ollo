import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ollo/src/constants/app_colors.dart';
import 'package:ollo/src/constants/app_text_styles.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.roadmapTitle, style: AppTextStyles.h2),
          centerTitle: true,
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: l10n.roadmapInProgress),
              Tab(text: l10n.roadmapPlanned),
              Tab(text: l10n.roadmapCompleted),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFeatureList([
              _FeatureItem(
                title: l10n.featureAiInsightsTitle,
                description: l10n.featureAiInsightsDesc,
                tag: l10n.roadmapBeta,
              ),
              _FeatureItem(
                title: l10n.featureBudgetForecastingTitle,
                description: l10n.featureBudgetForecastingDesc,
              ),
            ]),
            _buildFeatureList([
               _FeatureItem(
                title: l10n.featureMultiCurrencyTitle,
                description: l10n.featureMultiCurrencyDesc,
              ),
               _FeatureItem(
                title: l10n.featureCloudBackupTitle, // Real Google Drive sync
                description: l10n.featureCloudBackupDesc,
              ),
            ]),
            _buildFeatureList([
              _FeatureItem(
                 title: "Home Widgets",
                 description: "Budget Widget, Daily Graph, Quick Record Shortcut",
                 isDone: true,
              ),
              _FeatureItem(
                 title: "Quick Record",
                 description: "Voice & Text Input for super fast tracking",
                 isDone: true,
              ),
              _FeatureItem(
                title: l10n.featureDataExportTitle,
                description: l10n.featureDataExportDesc,
                isDone: true,
              ),
              _FeatureItem(
                title: l10n.featureReceiptScanningTitle,
                description: l10n.featureReceiptScanningDesc,
                isDone: true,
              ),
              _FeatureItem(
                title: l10n.featureLocalBackupTitle,
                description: l10n.featureLocalBackupDesc,
                isDone: true,
              ),
              _FeatureItem(
                title: l10n.featureSmartNotesTitle,
                description: l10n.featureSmartNotesDesc,
                isDone: true,
              ),
              _FeatureItem(
                title: l10n.featureRecurringTitle,
                description: l10n.featureRecurringDesc,
                isDone: true,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList(List<_FeatureItem> features) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: feature.isDone 
                ? Border.all(color: Colors.green.withOpacity(0.3))
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      feature.title,
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (feature.isDone)
                    const Icon(Icons.check_circle, color: Colors.green, size: 20)
                  else if (feature.tag != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        feature.tag!,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                feature.description,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FeatureItem {
  final String title;
  final String description;
  final String? tag;
  final bool isDone;

  _FeatureItem({
    required this.title,
    required this.description,
    this.tag,
    this.isDone = false,
  });
}
