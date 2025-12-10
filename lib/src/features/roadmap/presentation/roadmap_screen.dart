import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ollo/src/constants/app_colors.dart';
import 'package:ollo/src/constants/app_text_styles.dart';

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          title: Text('Product Roadmap', style: AppTextStyles.h2),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'In Progress'),
              Tab(text: 'Planned'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFeatureList([
              _FeatureItem(
                title: 'Cloud Backup (Google Drive)',
                description: 'Sync your data securely to your personal Google Drive.',
                tag: 'High Priority',
              ),
              _FeatureItem(
                title: 'Advanced AI Insights',
                description: 'Deeper analysis of your spending habits with personalized tips.',
                tag: 'BETA',
              ),
               _FeatureItem(
                title: 'Data Export to CSV/Excel',
                description: 'Export transaction history for external analysis in Excel or Sheets.',
                tag: 'Dev',
              ),
            ]),
            _buildFeatureList([
              _FeatureItem(
                title: 'Budget Forecasing',
                description: 'Predict next month\'s expenses based on historical data.',
              ),
              _FeatureItem(
                title: 'Multi-Currency Support',
                description: 'Real-time conversion for international transactions.',
              ),
               _FeatureItem(
                title: 'Receipt Scanning OCR',
                description: 'Scan receipts to automatically input transaction details.',
              ),
            ]),
            _buildFeatureList([
              _FeatureItem(
                title: 'Full Local Backup',
                description: 'Backup all app data (transactions, wallets, notes, etc.) to a local file.',
                isDone: true,
              ),
              _FeatureItem(
                title: 'Smart Notes',
                description: 'Shopping lists with checklists and total calculation.',
                isDone: true,
              ),
               _FeatureItem(
                title: 'Recurring Transactions',
                description: 'Automate bills and salary inputs.',
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
