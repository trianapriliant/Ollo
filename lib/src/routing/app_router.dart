import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../common_widgets/scaffold_with_nav_bar.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/statistics/presentation/statistics_screen.dart';
import '../features/transactions/presentation/add_transaction_screen.dart';
import '../features/wallets/presentation/add_wallet_screen.dart';
import '../features/wallets/presentation/wallet_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/categories/presentation/category_management_screen.dart';
import '../features/categories/presentation/add_edit_category_screen.dart';
import '../features/transactions/presentation/transaction_detail_screen.dart';
import '../features/transactions/domain/transaction.dart';
import '../features/wallets/presentation/wallet_detail_screen.dart';
import '../features/wallets/domain/wallet.dart';
import '../features/recurring/presentation/recurring_screen.dart';
import '../features/recurring/presentation/add_edit_recurring_screen.dart';
import '../features/recurring/domain/recurring_transaction.dart';
import '../features/cards/presentation/cards_screen.dart';
import '../features/cards/presentation/add_edit_card_screen.dart';
import '../features/cards/domain/card.dart';
import '../features/budget/presentation/budget_screen.dart';
import '../features/savings/presentation/savings_screen.dart';
import '../features/savings/presentation/saving_detail_screen.dart';
import '../features/savings/presentation/add_edit_saving_screen.dart';
import '../features/savings/domain/saving_goal.dart';
import '../features/subscription/presentation/paywall_screen.dart';
import '../features/bills/presentation/bills_screen.dart';
import '../features/bills/presentation/add_bill_screen.dart';
import '../features/bills/domain/bill.dart';
import '../features/wishlist/presentation/wishlist_screen.dart';
import '../features/wishlist/domain/wishlist.dart';
import '../features/wishlist/presentation/add_wishlist_screen.dart';
import '../features/debts/presentation/debts_screen.dart';
import '../features/debts/presentation/add_debt_screen.dart';
import '../features/debts/presentation/debt_detail_screen.dart';
import '../features/debts/domain/debt.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final shellNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/statistics',
                builder: (context, state) => const StatisticsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wallet',
                builder: (context, state) => const WalletScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/add-transaction',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra;
          TransactionType type = TransactionType.expense;
          Transaction? transactionToEdit;

          if (extra is bool) {
            type = extra ? TransactionType.expense : TransactionType.income;
          } else if (extra is TransactionType) {
            type = extra;
          } else if (extra is Transaction) {
            transactionToEdit = extra;
            type = transactionToEdit.type;
          }

          return AddTransactionScreen(
            type: type,
            transactionToEdit: transactionToEdit,
          );
        },
      ),
      GoRoute(
        path: '/add-wallet',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AddWalletScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/categories',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CategoryManagementScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddEditCategoryScreen(),
          ),
          GoRoute(
            path: 'edit/:id',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return AddEditCategoryScreen(categoryId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/transaction-detail',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final transaction = state.extra as Transaction;
          return TransactionDetailScreen(transaction: transaction);
        },
      ),
      GoRoute(
        path: '/wallet-detail',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final wallet = state.extra as Wallet;
          return WalletDetailScreen(wallet: wallet);
        },
      ),
      GoRoute(
        path: '/recurring',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const RecurringScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddEditRecurringScreen(),
          ),
          GoRoute(
            path: 'edit',
            builder: (context, state) {
              final tx = state.extra as RecurringTransaction;
              return AddEditRecurringScreen(transaction: tx);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/cards',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CardsScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddEditCardScreen(),
          ),
          GoRoute(
            path: 'edit',
            builder: (context, state) {
              final card = state.extra as BankCard;
              return AddEditCardScreen(card: card);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/budget',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const BudgetScreen(),
      ),
      GoRoute(
        path: '/savings',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SavingsScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddEditSavingScreen(),
          ),
          GoRoute(
            path: 'edit',
            builder: (context, state) {
              final goal = state.extra as SavingGoal;
              return AddEditSavingScreen(goal: goal);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/saving-detail',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final goal = state.extra as SavingGoal;
          return SavingDetailScreen(goal: goal);
        },
      ),
      GoRoute(
        path: '/paywall',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: '/bills',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const BillsScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddBillScreen(),
          ),
          GoRoute(
            path: 'edit',
            builder: (context, state) {
              final bill = state.extra as Bill;
              return AddBillScreen(billToEdit: bill);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/wishlist',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const WishlistScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddWishlistScreen(),
          ),
          GoRoute(
            path: 'edit',
            builder: (context, state) {
              final wishlist = state.extra as Wishlist;
              return AddWishlistScreen(wishlistToEdit: wishlist);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/debts',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const DebtsScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddDebtScreen(),
          ),
          GoRoute(
            path: 'edit',
            builder: (context, state) {
              final debt = state.extra as Debt;
              return AddDebtScreen(debtToEdit: debt);
            },
          ),
          GoRoute(
            path: 'detail',
            builder: (context, state) {
              final debt = state.extra as Debt;
              return DebtDetailScreen(debt: debt);
            },
          ),
        ],
      ),
    ],
  );
});
