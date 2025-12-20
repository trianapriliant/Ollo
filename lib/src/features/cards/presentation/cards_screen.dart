import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../cards/data/card_repository.dart';
import '../../cards/domain/card.dart';
import '../../../localization/generated/app_localizations.dart';

class CardsScreen extends ConsumerStatefulWidget {
  const CardsScreen({super.key});

  @override
  ConsumerState<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends ConsumerState<CardsScreen> {
  final Set<int> _selectedIds = {};
  bool get _isMultiSelectMode => _selectedIds.isNotEmpty;

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _copySelected(List<BankCard> allCards, AppLocalizations l10n) {
    final selectedCards = allCards.where((c) => _selectedIds.contains(c.id)).toList();
    if (selectedCards.isEmpty) return;

    final buffer = StringBuffer();
    for (var card in selectedCards) {
      buffer.writeln('${card.holderName} | ${card.name}: ${card.number}');
    }

    Clipboard.setData(ClipboardData(text: buffer.toString().trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.cardsCopied(selectedCards.length))),
    );
    setState(() {
      _selectedIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(cardListProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _isMultiSelectMode ? l10n.selectedCount(_selectedIds.length) : l10n.myCards,
          style: AppTextStyles.h2,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(_isMultiSelectMode ? Icons.close : Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (_isMultiSelectMode) {
              setState(() => _selectedIds.clear());
            } else {
              context.pop();
            }
          },
        ),
        actions: [
          if (_isMultiSelectMode)
            IconButton(
              icon: const Icon(Icons.copy_all, color: AppColors.primary),
              onPressed: () => cardsAsync.whenData((cards) => _copySelected(cards, l10n)),
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'home') {
                context.go('/home');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'home',
                  child: Row(
                    children: [
                      const Icon(Icons.home, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(l10n.home),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: cardsAsync.when(
        data: (cards) {
          if (cards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.credit_card, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(l10n.noCardsYet, style: AppTextStyles.h3.copyWith(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(l10n.addCardsMessage, style: AppTextStyles.bodySmall.copyWith(color: Colors.grey)),
                ],
              ),
            );
          }

          // Sort: Pinned first
          // Note: Repository already sorts by pinned desc, but we ensure it here if needed or just trust repo.
          // Repo does: sortByIsPinnedDesc().thenByName()
          
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cards.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final card = cards[index];
              return _buildCardItem(context, card, l10n);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: _isMultiSelectMode 
          ? null 
          : FloatingActionButton(
              heroTag: 'cards_fab',
              onPressed: () => context.push('/cards/add'),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }

  Widget _buildCardItem(BuildContext context, BankCard card, AppLocalizations l10n) {
    final isSelected = _selectedIds.contains(card.id);
    final isPinned = card.isPinned;

    return InkWell(
      onTap: () {
        if (_isMultiSelectMode) {
          _toggleSelection(card.id);
        } else {
          context.push('/cards/edit', extra: card);
        }
      },
      onLongPress: () {
        _toggleSelection(card.id);
      },
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(card.color),
              borderRadius: BorderRadius.circular(20),
              border: isSelected ? Border.all(color: AppColors.primary, width: 3) : null,
              boxShadow: [
                BoxShadow(
                  color: Color(card.color).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.name,
                            style: AppTextStyles.h3.copyWith(color: Colors.white),
                          ),
                          if (card.label != null)
                            Text(
                              card.label!,
                              style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.8)),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          card.type == CardType.bank ? Icons.account_balance : Icons.account_balance_wallet,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            card.accountType.name.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  card.number,
                  style: AppTextStyles.h2.copyWith(color: Colors.white, letterSpacing: 1.5),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      card.holderName.toUpperCase(),
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.8)),
                    ),
                    if (isPinned)
                      const Icon(Icons.push_pin, color: Colors.white, size: 16),
                  ],
                ),
                if (!_isMultiSelectMode) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          context,
                          icon: Icons.copy,
                          label: l10n.copyNumber,
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: card.number));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.cardNumberCopied)),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          context,
                          icon: Icons.copy_all,
                          label: l10n.copyTemplate,
                          onTap: () {
                            // Format: "Trian | BCA: 123456"
                            final text = '${card.holderName} | ${card.name}: ${card.number}';
                            Clipboard.setData(ClipboardData(text: text));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.cardTemplateCopied)),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: AppColors.primary, size: 20),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return Material(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


