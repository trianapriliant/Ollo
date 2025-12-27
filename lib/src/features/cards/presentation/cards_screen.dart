import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../utils/icon_helper.dart';
import '../../settings/presentation/icon_pack_provider.dart';
import '../../cards/data/card_repository.dart';
import '../../cards/domain/card.dart';
import '../../../localization/generated/app_localizations.dart';

class CardsScreen extends ConsumerStatefulWidget {
  const CardsScreen({super.key});

  @override
  ConsumerState<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends ConsumerState<CardsScreen> with SingleTickerProviderStateMixin {
  final Set<int> _selectedIds = {};
  bool get _isMultiSelectMode => _selectedIds.isNotEmpty;
  TabController? _tabController;
  int _lastTabCount = 2;
  bool _sortByName = false;

  List<BankCard> _sortCards(List<BankCard> cards) {
    if (!_sortByName) return cards;
    final sorted = List<BankCard>.from(cards);
    sorted.sort((a, b) => a.name.compareTo(b.name)); // A-Z
    return sorted;
  }

  void _initTabController(int tabCount) {
    _tabController?.dispose();
    _tabController = TabController(length: tabCount, vsync: this);
    _lastTabCount = tabCount;
  }

  @override
  void initState() {
    super.initState();
    _initTabController(2); // Default to 2 tabs
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

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

  CardType _getTypeForTab(int index) {
    switch (index) {
      case 0: return CardType.bank;
      case 1: return CardType.eWallet;
      case 2: return CardType.blockchain;
      default: return CardType.bank;
    }
  }

  String _getIconNameForType(CardType type) {
    switch (type) {
      case CardType.bank: return 'bank';
      case CardType.eWallet: return 'wallet';
      case CardType.blockchain: return 'bitcoin';
      case CardType.other: return 'credit_card';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(cardListProvider);
    final l10n = AppLocalizations.of(context)!;

    return cardsAsync.when(
      data: (cards) {
        // Apply sorting
        final sortedCards = _sortCards(cards);
        final hasBlockchain = sortedCards.any((c) => c.type == CardType.blockchain);
        final tabCount = hasBlockchain ? 3 : 2;
        
        // Schedule tab controller update for next frame if needed
        if (_lastTabCount != tabCount) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _initTabController(tabCount);
              });
            }
          });
        }
        
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              _isMultiSelectMode ? l10n.selectedCount(_selectedIds.length) : l10n.myCards,
              style: AppTextStyles.h2,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: IconHelper.getIconWidget(
                _isMultiSelectMode ? 'close' : 'arrow_back', 
                pack: ref.watch(iconPackProvider),
                color: Colors.black,
              ),
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
                  icon: IconHelper.getIconWidget('copy_all', pack: ref.watch(iconPackProvider), color: AppColors.primary),
                  onPressed: () => _copySelected(sortedCards, l10n),
                ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.black),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                elevation: 8,
                offset: const Offset(0, 50),
                onSelected: (value) {
                  if (value == 'home') {
                    context.go('/home');
                  }
                  if (value == 'sort_name') {
                    setState(() => _sortByName = !_sortByName);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_sortByName ? l10n.sortByName : 'Sort cleared'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'sort_name',
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _sortByName 
                                ? AppColors.primary.withOpacity(0.2) 
                                : AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.sort_by_alpha, size: 18, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Text(l10n.sortByName, style: AppTextStyles.bodyMedium),
                        if (_sortByName) ...[
                          const Spacer(),
                          Icon(Icons.check, size: 18, color: AppColors.primary),
                        ],
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'home',
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.home_outlined, size: 18, color: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        Text(l10n.home, style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(
                  icon: IconHelper.getIconWidget('bank', pack: ref.watch(iconPackProvider), size: 20),
                  text: l10n.bank,
                ),
                Tab(
                  icon: IconHelper.getIconWidget('wallet', pack: ref.watch(iconPackProvider), size: 20),
                  text: l10n.eWallet,
                ),
                if (_lastTabCount == 3)
                  Tab(
                    icon: IconHelper.getIconWidget('bitcoin', pack: ref.watch(iconPackProvider), size: 20),
                    text: l10n.blockchain,
                  ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildCardList(sortedCards.where((c) => c.type == CardType.bank).toList(), l10n, CardType.bank),
              _buildCardList(sortedCards.where((c) => c.type == CardType.eWallet).toList(), l10n, CardType.eWallet),
              if (_lastTabCount == 3)
                _buildCardList(sortedCards.where((c) => c.type == CardType.blockchain).toList(), l10n, CardType.blockchain),
            ],
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
      },
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(l10n.myCards, style: AppTextStyles.h2),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildCardList(List<BankCard> cards, AppLocalizations l10n, CardType type) {
    if (cards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconHelper.getIconWidget(_getIconNameForType(type), pack: ref.watch(iconPackProvider), size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(l10n.noCardsYet, style: AppTextStyles.h3.copyWith(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(l10n.addCardsMessage, style: AppTextStyles.bodySmall.copyWith(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cards.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final card = cards[index];
        return _buildCardItem(context, card, l10n);
      },
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
                        IconHelper.getIconWidget(
                          _getIconNameForType(card.type),
                          pack: ref.watch(iconPackProvider),
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
                      IconHelper.getIconWidget('push_pin', pack: ref.watch(iconPackProvider), color: Colors.white, size: 16),
                  ],
                ),
                if (!_isMultiSelectMode) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          context,
                          iconName: 'copy',
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
                          iconName: 'copy_all',
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
                child: IconHelper.getIconWidget('check', pack: ref.watch(iconPackProvider), color: AppColors.primary, size: 20),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required String iconName, required String label, required VoidCallback onTap}) {
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
              IconHelper.getIconWidget(iconName, pack: ref.watch(iconPackProvider), size: 16, color: Colors.white),
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


