import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../features/transactions/presentation/widgets/add_transaction_bottom_sheet.dart';
import '../localization/generated/app_localizations.dart';
import '../features/settings/presentation/icon_pack_provider.dart';
import '../utils/icon_helper.dart';

import 'package:flutter/services.dart';

class ScaffoldWithNavBar extends ConsumerStatefulWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends ConsumerState<ScaffoldWithNavBar> {
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    final iconPack = ref.watch(iconPackProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          // Only handle double-back-to-exit on the first tab (Home)
          final now = DateTime.now();
          if (_lastPressedAt == null ||
              now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
            _lastPressedAt = now;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.pressBackAgainToExit),
                duration: const Duration(seconds: 2),
              ),
            );
            return;
          }

          await SystemNavigator.pop();
        },
        child: Scaffold(
          body: widget.navigationShell,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            color: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 10,
            shadowColor: Colors.black.withOpacity(0.2),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Side
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _NavBarItem(
                          iconName: 'home',
                          label: AppLocalizations.of(context)!.home,
                          isSelected: widget.navigationShell.currentIndex == 0,
                          onTap: () => _onTap(context, 0),
                          iconPack: iconPack,
                        ),
                      ),
                      Expanded(
                        child: _NavBarItem(
                          iconName: 'show_chart', // or bar_chart
                          label: AppLocalizations.of(context)!.statistics,
                          isSelected: widget.navigationShell.currentIndex == 1,
                          onTap: () => _onTap(context, 1),
                          iconPack: iconPack,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Spacer for FAB
                const SizedBox(width: 48), 

                // Right Side
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _NavBarItem(
                          iconName: 'wallet',
                          label: AppLocalizations.of(context)!.wallet,
                          isSelected: widget.navigationShell.currentIndex == 2,
                          onTap: () => _onTap(context, 2),
                          iconPack: iconPack,
                        ),
                      ),
                      Expanded(
                        child: _NavBarItem(
                          iconName: 'person',
                          label: AppLocalizations.of(context)!.profile,
                          isSelected: widget.navigationShell.currentIndex == 3,
                          onTap: () => _onTap(context, 3),
                          iconPack: iconPack,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Use a threshold to detect keyboard (avoid hiding for small insets like system bars)
          floatingActionButton: MediaQuery.of(context).viewInsets.bottom > 100 
            ? null 
            : Transform.translate(
                offset: const Offset(0, 18), // Lower the FAB further (Total 18)
                child: FloatingActionButton(
                heroTag: 'main_fab',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const AddTransactionBottomSheet(),
                  );
                },
                backgroundColor: AppColors.primary,
                elevation: 4,
                shape: const CircleBorder(),
                child: IconHelper.getIconWidget(
                  'add',
                  color: Colors.white,
                  size: 32,
                  pack: iconPack,
                ),
              ),
            ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String iconName;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconPack iconPack;

  const _NavBarItem({
    required this.iconName,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.iconPack,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconHelper.getIconWidget(
              iconName,
              color: isSelected ? AppColors.primary : Colors.grey,
              size: 24,
              pack: iconPack,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
