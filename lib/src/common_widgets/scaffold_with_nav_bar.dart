import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../features/transactions/presentation/widgets/add_transaction_bottom_sheet.dart';
import '../localization/generated/app_localizations.dart';

import 'package:flutter/services.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: navigationShell,
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
                        icon: Icons.home_outlined,
                        selectedIcon: Icons.home,
                        label: AppLocalizations.of(context)!.home,
                        isSelected: navigationShell.currentIndex == 0,
                        onTap: () => _onTap(context, 0),
                      ),
                    ),
                    Expanded(
                      child: _NavBarItem(
                        icon: Icons.bar_chart_outlined,
                        selectedIcon: Icons.bar_chart,
                        label: AppLocalizations.of(context)!.statistics,
                        isSelected: navigationShell.currentIndex == 1,
                        onTap: () => _onTap(context, 1),
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
                        icon: Icons.wallet_outlined,
                        selectedIcon: Icons.wallet,
                        label: AppLocalizations.of(context)!.wallet,
                        isSelected: navigationShell.currentIndex == 2,
                        onTap: () => _onTap(context, 2),
                      ),
                    ),
                    Expanded(
                      child: _NavBarItem(
                        icon: Icons.person_outline,
                        selectedIcon: Icons.person,
                        label: AppLocalizations.of(context)!.profile,
                        isSelected: navigationShell.currentIndex == 3,
                        onTap: () => _onTap(context, 3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
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
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
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
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? AppColors.primary : Colors.grey,
              size: 24,
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
