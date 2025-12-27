import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../common_widgets/scaffold_with_nav_bar.dart';
import '../constants/app_colors.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/statistics/presentation/statistics_screen.dart';
import '../features/dashboard/presentation/filtered_transactions_screen.dart';
import '../features/statistics/presentation/category_transactions_screen.dart';
import '../features/statistics/presentation/statistics_provider.dart'; // For TimeRange enum
import '../features/statistics/presentation/transaction_table_screen.dart';
import '../features/transactions/presentation/add_transaction_screen.dart';
import '../features/quick_record/presentation/widgets/scan_receipt_screen.dart';
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
import '../features/smart_notes/presentation/smart_notes_screen.dart';
import '../features/smart_notes/presentation/add_edit_smart_note_screen.dart';
import '../features/smart_notes/presentation/smart_note_detail_screen.dart';
import '../features/smart_notes/domain/smart_note.dart';
import '../features/profile/presentation/about_ollo_screen.dart';
import '../features/profile/presentation/send_feedback_screen.dart';
import '../features/profile/presentation/help_support_screen.dart';
import '../features/profile/presentation/help_support_screen.dart';
import '../features/onboarding/data/onboarding_repository.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/onboarding/presentation/onboarding_preferences_screen.dart';
import '../features/reimbursement/presentation/reimburse_screen.dart';
import '../features/reimbursement/presentation/add_reimburse_screen.dart';
import '../features/profile/presentation/data_export_screen.dart';
import '../features/profile/presentation/data_import_screen.dart';
import '../features/profile/presentation/update_log_screen.dart';
import '../features/backup/presentation/backup_screen.dart';
import '../features/roadmap/presentation/roadmap_screen.dart';
import '../features/gamification/presentation/gamification_screen.dart';
import '../features/gamification/presentation/gamification_listener.dart';
import '../features/quick_record/presentation/quick_record_modal.dart';
import '../features/subscription/presentation/premium_screen.dart';
import '../features/wallets/presentation/import_wallet_templates_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final shellNavigatorKey = GlobalKey<NavigatorState>();
  final onboardingRepo = ref.watch(onboardingRepositoryProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: onboardingRepo.isOnboardingComplete() ? '/home' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
        routes: [
          GoRoute(
            path: 'preferences',
            builder: (context, state) => const OnboardingPreferencesScreen(),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return GamificationListener(
            child: ScaffoldWithNavBar(navigationShell: navigationShell),
          );
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
                routes: [
                  GoRoute(
                    path: 'category-details',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      return CategoryTransactionsScreen(
                        categoryId: extra['categoryId'],
                        categoryName: extra['categoryName'],
                        filterDate: extra['filterDate'],
                        filterTimeRange: extra['filterTimeRange'],
                        isExpense: extra['isExpense'],
                      );
                    },
                  ),
                ],
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
        path: '/filtered-transactions',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return FilteredTransactionsScreen(
            isExpense: extra['isExpense'] as bool,
            specificDate: extra['specificDate'] as DateTime?,
            startDate: extra['startDate'] as DateTime?,
            endDate: extra['endDate'] as DateTime?,
          );
        },
      ),
      GoRoute(
        path: '/transaction-table',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const TransactionTableScreen(),
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
          } else if (extra is Map && extra['isTransfer'] == true) {
            // Transfer from Quick Record - extract transaction and set type
            final txn = extra['transaction'] as Transaction;
            final transferFee = extra['transferFee'] as double? ?? 0;
            transactionToEdit = Transaction.create(
              title: txn.title,
              amount: txn.amount,
              date: txn.date,
              type: TransactionType.transfer,
              walletId: (extra['sourceWallet'] as dynamic)?.externalId ?? (extra['sourceWallet'] as dynamic)?.id.toString(),
              destinationWalletId: (extra['destinationWallet'] as dynamic)?.externalId ?? (extra['destinationWallet'] as dynamic)?.id.toString(),
              note: txn.note,
            );
            type = TransactionType.transfer;
            
            return AddTransactionScreen(
              type: type,
              transactionToEdit: transactionToEdit,
              initialTransferFee: transferFee,
            );
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
        path: '/premium',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PremiumScreen(),
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
            name: 'edit_category',
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
        redirect: (context, state) => '/premium',
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
        path: '/smart-notes',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SmartNotesScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddEditSmartNoteScreen(),
          ),
          GoRoute(
            path: 'edit',
            builder: (context, state) {
              final note = state.extra as SmartNote;
              return AddEditSmartNoteScreen(note: note);
            },
          ),
          GoRoute(
            path: 'detail',
            builder: (context, state) {
              final note = state.extra as SmartNote;
              return SmartNoteDetailScreen(note: note);
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
      GoRoute(
        path: '/help-support',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: '/send-feedback',
        builder: (context, state) => const SendFeedbackScreen(),
      ),
      GoRoute(
        path: '/about-ollo',
        builder: (context, state) => const AboutOlloScreen(),
      ),
      GoRoute(
        path: '/data-export',
        builder: (context, state) => const DataExportScreen(),
      ),
      GoRoute(
        path: '/data-import',
        builder: (context, state) => const DataImportScreen(),
      ),
      GoRoute(
        path: '/update-log',
        builder: (context, state) => const UpdateLogScreen(),
      ),
      GoRoute(
        path: '/backup',
        builder: (context, state) => const BackupScreen(),
      ),
      GoRoute(
        path: '/import-wallet-templates',
        builder: (context, state) => const ImportWalletTemplatesScreen(),
      ),
      GoRoute(
        path: '/reimburse',
        builder: (context, state) => const ReimburseScreen(),
        routes: [
           GoRoute(
            path: 'add',
            builder: (context, state) => const AddReimburseScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/scan-receipt',
        builder: (context, state) => const ScanReceiptScreen(),
      ),
      GoRoute(
        path: '/roadmap',
        builder: (context, state) => const RoadmapScreen(),
      ),
      GoRoute(
        path: '/gamification',
        builder: (context, state) => const GamificationScreen(),
      ),
      GoRoute(
        path: '/quick-record',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          // Use a transparent page that opens the modal immediately
          return CustomTransitionPage(
            key: state.pageKey,
            child: const _QuickRecordDeepLinkWrapper(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            opaque: false,
          );
        },
      ),
    ],
  );
});

class _QuickRecordDeepLinkWrapper extends StatefulWidget {
  const _QuickRecordDeepLinkWrapper();

  @override
  State<_QuickRecordDeepLinkWrapper> createState() => _QuickRecordDeepLinkWrapperState();
}

class _QuickRecordDeepLinkWrapperState extends State<_QuickRecordDeepLinkWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showModal();
    });
  }

  Future<void> _showModal() async {
    // Show the modal and wait for result
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickRecordModal(initialMode: 'voice'),
    );
    
    if (!mounted) return;

    if (result is Transaction) {
        // Option 1: Go Home, then Push AddTransaction (Cleanest history)
        context.go('/home');
        context.push('/add-transaction', extra: result);
    } else {
        // User cancelled
        if (context.canPop()) {
           context.pop();
        } else {
           context.go('/home');
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use app background color to avoid black screen
    return Scaffold(backgroundColor: AppColors.background);
  }
}
