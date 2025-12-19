// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get customizeMenu => 'Customize Menu';

  @override
  String get menuOrder => 'Menu Order';

  @override
  String get resetMenu => 'Reset Menu';

  @override
  String get home => 'Home';

  @override
  String get cardAppearance => 'Card Appearance';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get themeClassic => 'Classic Blue';

  @override
  String get themeSunset => 'Sunset Orange';

  @override
  String get themeOcean => 'Ocean Teal';

  @override
  String get themeBerry => 'Berry Purple';

  @override
  String get themeForest => 'Nature Green';

  @override
  String get themeMidnight => 'Midnight Dark';

  @override
  String get themeOasis => 'Calm Oasis';

  @override
  String get themeLavender => 'Soft Lavender';

  @override
  String get themeCottonCandy => 'Pastel Dream';

  @override
  String get themeMint => 'Simply Mint';

  @override
  String get themePeach => 'Simply Peach';

  @override
  String get themeSoftBlue => 'Simply Blue';

  @override
  String get themeLilac => 'Simply Lilac';

  @override
  String get themeLemon => 'Simply Lemon';

  @override
  String get wallet => 'Wallet';

  @override
  String get profile => 'Profile';

  @override
  String get statistics => 'Statistics';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String get transfer => 'Transfer';

  @override
  String get amount => 'Amount';

  @override
  String get to => 'To';

  @override
  String get addNoteHint => 'Add a note...';

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get errorInvalidAmount => 'Please enter a valid amount';

  @override
  String get errorSelectWallet => 'Please select a wallet';

  @override
  String get errorSelectDestinationWallet =>
      'Please select a destination wallet';

  @override
  String get errorSameWallets =>
      'Source and destination wallets must be different';

  @override
  String get errorSelectCategory => 'Please select a category';

  @override
  String get transactionDetail => 'Transaction Detail';

  @override
  String get title => 'Title';

  @override
  String get category => 'Category';

  @override
  String get dateTime => 'Date Time';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get note => 'Note';

  @override
  String get deleteTransaction => 'Delete Transaction';

  @override
  String get deleteTransactionConfirm =>
      'Are you sure you want to delete this transaction?';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get markCompleted => 'Mark as Completed';

  @override
  String get markCompletedConfirm => 'Mark this transaction as completed?';

  @override
  String get confirm => 'Confirm';

  @override
  String get system => 'System';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get noTransactions => 'No transactions yet';

  @override
  String get startRecording =>
      'Start recording your expenses and income to keep your finances organized! 🚀';

  @override
  String get menu => 'Menu';

  @override
  String get budget => 'Budget';

  @override
  String get recurring => 'Recurring';

  @override
  String get savings => 'Savings';

  @override
  String get total => 'Total';

  @override
  String get bills => 'Bills';

  @override
  String get debts => 'Debts';

  @override
  String get wishlist => 'Wishlist';

  @override
  String get cards => 'Cards';

  @override
  String get notes => 'Notes';

  @override
  String get reimburse => 'Reimburse';

  @override
  String get unknown => 'Unknown';

  @override
  String welcome(String name) {
    return 'Hi, $name!';
  }

  @override
  String get welcomeSimple => 'Hi!';

  @override
  String get settings => 'Settings';

  @override
  String get developerOptions => 'Developer Options';

  @override
  String get futureFeatures => 'Future Features';

  @override
  String get backupRecovery => 'Backup & Recovery';

  @override
  String get aiAutomation => 'AI Automation';

  @override
  String get feedbackRoadmap => 'Feedback & Roadmap';

  @override
  String get dataExport => 'Data Export';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get categories => 'Categories';

  @override
  String get wallets => 'Wallets';

  @override
  String get general => 'General';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get sendFeedback => 'Send Feedback';

  @override
  String get aboutOllo => 'About Ollo';

  @override
  String get account => 'Account';

  @override
  String get deleteData => 'Delete Data';

  @override
  String get logout => 'Logout';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get comingSoonDesc =>
      'Let AI categorize your transactions and provide smart financial insights.';

  @override
  String get cantWait => 'Can\'t Wait!';

  @override
  String get deleteAllData => 'Delete All Data?';

  @override
  String deleteAllDataConfirm(String confirmationText) {
    return 'This action will permanently delete ALL your transactions, wallets, budgets, and notes. This cannot be undone.\n\nTo confirm, please type \"$confirmationText\" below:';
  }

  @override
  String get deleteDataConfirmationText => 'Delete Data';

  @override
  String get dataDeletedSuccess =>
      'All data deleted successfully. Please restart the app.';

  @override
  String dataDeleteFailed(String error) {
    return 'Failed to delete data: $error';
  }

  @override
  String get currency => 'Currency';

  @override
  String get language => 'Language';

  @override
  String get selectCurrency => 'Select Currency';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get myWallets => 'My Wallets';

  @override
  String get emptyWalletsTitle => 'No wallets yet';

  @override
  String get emptyWalletsMessage =>
      'Add a wallet or bank account to start tracking! 💳';

  @override
  String get addWallet => 'Add New Wallet';

  @override
  String get editWallet => 'Edit Wallet';

  @override
  String get newWallet => 'New Wallet';

  @override
  String get walletName => 'Wallet Name';

  @override
  String get initialBalance => 'Initial Balance';

  @override
  String get walletDetails => 'Wallet Details';

  @override
  String get appearance => 'Appearance';

  @override
  String get icon => 'Icon';

  @override
  String get color => 'Color';

  @override
  String get saveWallet => 'Save Wallet';

  @override
  String get walletTypeCash => 'Cash';

  @override
  String get walletTypeBank => 'Bank Accounts';

  @override
  String get walletTypeEWallet => 'E-Wallets';

  @override
  String get walletTypeCreditCard => 'Credit Cards';

  @override
  String get walletTypeExchange => 'Exchanges / Investments';

  @override
  String get walletTypeOther => 'Others';

  @override
  String get debitCard => 'Debit Card';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get noCategoriesFound => 'No categories found';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get newCategory => 'New Category';

  @override
  String get categoryName => 'Category Name';

  @override
  String get enterCategoryName => 'Please enter a name';

  @override
  String get deleteCategory => 'Delete Category?';

  @override
  String get deleteCategoryConfirm => 'This action cannot be undone.';

  @override
  String get save => 'Save';

  @override
  String get systemCategoryTitle => 'System Category';

  @override
  String get systemCategoryMessage =>
      'This category is managed by the system and cannot be edited or deleted manually.';

  @override
  String get sysCatTransfer => 'Transfer';

  @override
  String get sysCatTransferDesc => 'Fund transfers between wallets';

  @override
  String get sysCatRecurring => 'Recurring';

  @override
  String get sysCatRecurringDesc => 'Automated recurring transactions';

  @override
  String get sysCatWishlist => 'Wishlist';

  @override
  String get sysCatWishlistDesc =>
      'Automated transactions from Wishlist purchases';

  @override
  String get sysCatBills => 'Bills';

  @override
  String get sysCatBillsDesc => 'Automated transactions from Bill payments';

  @override
  String get dueDateLabel => 'Due Date';

  @override
  String get statusLabel => 'Status';

  @override
  String get noPaymentsYet => 'No payments yet';

  @override
  String get sysCatDebts => 'Debts';

  @override
  String get sysCatDebtsDesc => 'Automated transactions from Debt/Loan records';

  @override
  String get sysCatSavings => 'Savings';

  @override
  String get sysCatSavingsDesc =>
      'Automated transactions from Savings deposits/withdrawals';

  @override
  String get sysCatSmartNotes => 'Bundled Notes';

  @override
  String get sysCatSmartNotesDesc =>
      'Automated transactions from Smart Bundles';

  @override
  String get sysCatReimburse => 'Reimburse';

  @override
  String get sysCatReimburseDesc => 'Reimbursement tracking system';

  @override
  String get sysCatAdjustment => 'Balance Adjustment';

  @override
  String get sysCatAdjustmentDesc => 'Manual wallet balance corrections';

  @override
  String get budgetsTitle => 'Budgets';

  @override
  String get noBudgetsYet => 'No budgets yet';

  @override
  String get createBudget => 'Create Budget';

  @override
  String get yourBudgets => 'Your Budgets';

  @override
  String get newBudget => 'New Budget';

  @override
  String get editBudget => 'Edit Budget';

  @override
  String get limitAmount => 'Limit Amount';

  @override
  String get period => 'Period';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get daily => 'Daily';

  @override
  String get deleteBudget => 'Delete Budget';

  @override
  String get deleteBudgetConfirm =>
      'Are you sure you want to delete this budget?';

  @override
  String get enterAmount => 'Enter amount';

  @override
  String get recurringTitle => 'Recurring';

  @override
  String get activeSubscriptions => 'Active Subscriptions';

  @override
  String get noActiveSubscriptions => 'No active subscriptions';

  @override
  String get newRecurring => 'New Recurring';

  @override
  String get editRecurring => 'Edit Recurring';

  @override
  String get frequency => 'Frequency';

  @override
  String get startDate => 'Start Date';

  @override
  String get payWithWallet => 'Pay with Wallet';

  @override
  String get updateRecurring => 'Update Recurring';

  @override
  String get saveRecurring => 'Save Recurring';

  @override
  String get deleteRecurring => 'Delete Recurring?';

  @override
  String get deleteRecurringConfirm =>
      'This will stop future auto-payments. Past transactions will remain.';

  @override
  String get pleaseSelectWallet => 'Please select a wallet';

  @override
  String get debtsTitle => 'Debts';

  @override
  String get iOwe => 'I Owe';

  @override
  String get owedToMe => 'Owed to Me';

  @override
  String get netBalance => 'Net Balance';

  @override
  String get debtFree => 'You are debt free!';

  @override
  String get noOneOwesYou => 'No one owes you money.';

  @override
  String get paidStatus => 'Paid';

  @override
  String get overdue => 'Overdue';

  @override
  String dueOnDate(String date) {
    return 'Due $date';
  }

  @override
  String amountLeft(String amount) {
    return '$amount left';
  }

  @override
  String get deleteDebt => 'Delete Debt?';

  @override
  String get deleteDebtConfirm => 'This will remove the debt record.';

  @override
  String get sortByDate => 'Sort by Date';

  @override
  String get sortByAmount => 'Sort by Amount';

  @override
  String get editDebt => 'Edit Debt/Loan';

  @override
  String get addDebt => 'Add Debt/Loan';

  @override
  String get iBorrowed => 'I Borrowed';

  @override
  String get iLent => 'I Lent';

  @override
  String get personName => 'Person Name';

  @override
  String get whoHint => 'Who?';

  @override
  String get required => 'Required';

  @override
  String get updateDebt => 'Update Debt';

  @override
  String get saveDebt => 'Save Debt';

  @override
  String get debtSaved => 'Debt saved successfully';

  @override
  String get debtUpdated => 'Debt updated successfully';

  @override
  String get debtDeleted => 'Debt deleted';

  @override
  String get debtDetails => 'Debt Details';

  @override
  String get paymentHistory => 'Payment History';

  @override
  String youOweName(String name) {
    return 'You owe $name';
  }

  @override
  String nameOwesYou(String name) {
    return '$name owes you';
  }

  @override
  String totalAmount(String amount) {
    return 'Total: $amount';
  }

  @override
  String paidAmount(String amount) {
    return 'Paid: $amount';
  }

  @override
  String get activeStatus => 'Active';

  @override
  String get addPayment => 'Add Payment';

  @override
  String get noneRecordOnly => 'None (Just record)';

  @override
  String get confirmPayment => 'Confirm Payment';

  @override
  String get paymentRecorded => 'Payment recorded successfully!';

  @override
  String get balanceUpdateDetected => 'Balance Update Detected';

  @override
  String get recordAsTransaction => 'Record as Transaction?';

  @override
  String recordAsTransactionDesc(String amount) {
    return 'The balance has changed by $amount. Do you want to record this difference as a transaction?';
  }

  @override
  String get adjustmentTitle => 'Balance Adjustment';

  @override
  String get skip => 'No, Adjust Only';

  @override
  String get record => 'Yes, Record';

  @override
  String get deleteDebtWarning =>
      'This will remove the debt record. Wallet balances will NOT be reverted automatically.';

  @override
  String get billsTitle => 'Bills';

  @override
  String get unpaid => 'Unpaid';

  @override
  String get paidTab => 'Paid';

  @override
  String get allCaughtUp => 'All caught up!';

  @override
  String get noUnpaidBills => 'No unpaid bills at the moment.';

  @override
  String get noHistoryYet => 'No history yet';

  @override
  String paidOnDate(String date) {
    return 'Paid $date';
  }

  @override
  String get dueToday => 'Due Today';

  @override
  String dueInDays(int days) {
    return 'Due in $days days';
  }

  @override
  String get pay => 'Pay';

  @override
  String get payBill => 'Pay Bill';

  @override
  String payBillTitle(String title) {
    return 'Pay \"$title\"?';
  }

  @override
  String get payFrom => 'Pay from:';

  @override
  String get noWalletsFound => 'No wallets found';

  @override
  String get billPaidSuccess => 'Bill paid successfully!';

  @override
  String get editBill => 'Edit Bill';

  @override
  String get addBill => 'Add Bill';

  @override
  String get billDetails => 'Bill Details';

  @override
  String get billName => 'Bill Name';

  @override
  String get billType => 'Bill Type';

  @override
  String get repeatBill => 'Repeat this bill?';

  @override
  String get autoCreateBill => 'Automatically create new bills';

  @override
  String get updateBill => 'Update Bill';

  @override
  String get saveBill => 'Save Bill';

  @override
  String get billSaved => 'Bill saved successfully';

  @override
  String get billUpdated => 'Bill updated successfully';

  @override
  String get billDeleted => 'Bill deleted';

  @override
  String get payBillDescription =>
      'This will create a System transaction and deduct from your wallet.';

  @override
  String get deleteBill => 'Delete Bill?';

  @override
  String get deleteBillConfirm => 'This action cannot be undone.';

  @override
  String get errorInvalidBill => 'Please enter valid title and amount';

  @override
  String get wishlistTitle => 'Wishlist';

  @override
  String get activeTab => 'Active';

  @override
  String get achievedTab => 'Achieved';

  @override
  String get emptyActiveWishlistMessage => 'Start adding items you want to buy';

  @override
  String get emptyAchievedWishlistMessage =>
      'No achieved dreams yet. Keep going!';

  @override
  String get noAchievementsYet => 'No achievements yet';

  @override
  String get wishlistEmpty => 'Your wishlist is empty';

  @override
  String get deleteItemTitle => 'Delete Item?';

  @override
  String deleteItemConfirm(String title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get buy => 'Buy';

  @override
  String get buyItemTitle => 'Buy Item';

  @override
  String purchaseItemTitle(String title) {
    return 'Purchase \"$title\"?';
  }

  @override
  String get selectWalletLabel => 'Select Wallet:';

  @override
  String get noWalletsFoundMessage =>
      'No wallets found. Please create a wallet first.';

  @override
  String get amountLabel => 'Amount:';

  @override
  String get confirmPurchase => 'Confirm Purchase';

  @override
  String get purchaseSuccessMessage =>
      'Purchase successful! Dream achieved! 🎉';

  @override
  String errorLaunchingUrl(String error) {
    return 'Error launching URL: $error';
  }

  @override
  String get editWishlist => 'Edit Wishlist';

  @override
  String get addWishlist => 'Add Wishlist';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get itemName => 'Item Name';

  @override
  String get itemNameHint => 'e.g. New Laptop';

  @override
  String get priceLabel => 'Price';

  @override
  String get targetDateLabel => 'Target Date';

  @override
  String get selectDate => 'Select Date';

  @override
  String get productLinkLabel => 'Product Link (Optional)';

  @override
  String get productLinkHint => 'e.g. https://shopee.co.id/...';

  @override
  String get updateWishlist => 'Update Wishlist';

  @override
  String get saveWishlist => 'Save to Wishlist';

  @override
  String get errorInvalidWishlist => 'Please enter valid title and price';

  @override
  String get wishlistUpdated => 'Wishlist updated successfully';

  @override
  String get wishlistSaved => 'Item added to wishlist!';

  @override
  String get deleteWishlistTitle => 'Delete Wishlist?';

  @override
  String get deleteWishlistConfirm => 'This action cannot be undone.';

  @override
  String get wishlistDeleted => 'Wishlist deleted';

  @override
  String errorPickingImage(String error) {
    return 'Error picking image: $error';
  }

  @override
  String get smartNotesTitle => 'My Bundles';

  @override
  String get emptySmartNotesMessage => 'Create your first bundle!';

  @override
  String get historyTitle => 'History';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get addSmartNote => 'New Bundle';

  @override
  String get noItemsInBundle => 'No items in this bundle';

  @override
  String payAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String get paidAndCompleted => 'Paid & Completed';

  @override
  String get undoPay => 'Undo Pay';

  @override
  String get deleteSmartNoteTitle => 'Delete Bundle?';

  @override
  String confirmPaymentMessage(String amount) {
    return 'Create transaction for $amount?';
  }

  @override
  String get paymentSuccess => 'Paid & Completed!';

  @override
  String get undoPaymentTitle => 'Undo Payment?';

  @override
  String get undoPaymentConfirm =>
      'This will delete the transaction, refund the wallet, and reopen the bundle.';

  @override
  String get undoAndReopen => 'Undo & Reopen';

  @override
  String get purchaseReopened => 'Purchase Reopened';

  @override
  String get editSmartNote => 'Edit Bundle';

  @override
  String get newSmartNote => 'New Bundle';

  @override
  String get smartNoteName => 'Bundle Name';

  @override
  String get smartNoteNameHint => 'e.g. Monthly Groceries';

  @override
  String get itemsList => 'Items List';

  @override
  String get addItem => 'Add Item';

  @override
  String get requiredShort => 'Reqd';

  @override
  String get additionalNotes => 'Additional Notes';

  @override
  String get totalEstimate => 'Total Estimate';

  @override
  String get saveBundle => 'Save Bundle';

  @override
  String get checkedTotal => 'Checked Total:';

  @override
  String get completed => 'Completed';

  @override
  String get payAndFinish => 'Pay & Finish';

  @override
  String get payingWith => 'Paying with';

  @override
  String get noItemsChecked => 'No items checked to pay!';

  @override
  String get smartNoteTransactionRecorded =>
      'Transaction recorded & Bundle completed!';

  @override
  String get totalDreamValue => 'Total Dream Value';

  @override
  String activeWishesCount(int count) {
    return '$count Wishes';
  }

  @override
  String achievedDreamsCount(int count) {
    return '$count Dreams Achieved! 🎉';
  }

  @override
  String get billDataNotFound => 'Bill data not found';

  @override
  String get wishlistDataNotFound => 'Wishlist data not found';

  @override
  String get editReimbursementNotSupported =>
      'Edit Reimbursement not fully supported yet';

  @override
  String get transactions => 'Transactions';

  @override
  String get noTransactionsFound => 'No transactions found';

  @override
  String get noTransactionsInCategory => 'No transactions in this category';

  @override
  String get noDataForPeriod => 'No data for this period';

  @override
  String get monthlyOverview => 'Monthly Overview';

  @override
  String get unlockPremiumStats => 'Unlock Premium Stats';

  @override
  String get totalBalance => 'Total Balance';

  @override
  String get dailyBudget => 'Daily Budget';

  @override
  String get weeklyBudget => 'Weekly Budget';

  @override
  String get monthlyBudget => 'Monthly Budget';

  @override
  String get yearlyBudget => 'Yearly Budget';

  @override
  String get wishlistPurchase => 'Wishlist Purchase';

  @override
  String get billPayment => 'Bill Payment';

  @override
  String get debtTransaction => 'Debt Transaction';

  @override
  String get savingsTransaction => 'Savings Transaction';

  @override
  String get transferTransaction => 'Transfer';

  @override
  String get transferFee => 'Transfer Fee';

  @override
  String get transferFeeHint => 'Fee (Optional)';

  @override
  String get pressBackAgainToExit => 'Press back again to exit';

  @override
  String get quickRecord => 'Quick Record';

  @override
  String get chatAction => 'Chat';

  @override
  String get scanAction => 'Scan';

  @override
  String get voiceAction => 'Voice';

  @override
  String get filterDay => 'Day';

  @override
  String get filterWeek => 'Week';

  @override
  String get filterMonth => 'Month';

  @override
  String get filterYear => 'Year';

  @override
  String get filterAll => 'All';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get titleLabel => 'Title';

  @override
  String get enterDescriptionHint => 'Enter description';

  @override
  String get enterTitleHint => 'Enter title (e.g. Breakfast)';

  @override
  String get enterValidAmount => 'Please enter a valid amount';

  @override
  String get selectWalletError => 'Please select a wallet';

  @override
  String get selectDestinationWalletError =>
      'Please select a destination wallet';

  @override
  String get selectCategoryError => 'Please select a category';

  @override
  String get saveTransaction => 'Save Transaction';

  @override
  String get loading => 'Loading...';

  @override
  String error(String error) {
    return 'Error: $error';
  }

  @override
  String get expenseDetails => 'Expense Details';

  @override
  String get incomeDetails => 'Income Details';

  @override
  String get noExpensesFound => 'No expenses found';

  @override
  String get noIncomeFound => 'No income found';

  @override
  String get forThisDate => 'for this date';

  @override
  String get timeFilterToday => 'Today';

  @override
  String get timeFilterThisWeek => 'This Week';

  @override
  String get timeFilterThisMonth => 'This Month';

  @override
  String get timeFilterThisYear => 'This Year';

  @override
  String get timeFilterAllTime => 'All Time';

  @override
  String get dailyAverage => 'Daily Average';

  @override
  String get projectedTotal => 'Projected Total';

  @override
  String get spendingHabitsNote =>
      'Based on your spending habits so far this month.';

  @override
  String get monthlyComparison => 'Monthly Comparison';

  @override
  String get spendingLessNote => 'You are spending less than last month!';

  @override
  String get spendingMoreNote => 'Spending is higher than usual.';

  @override
  String get topSpenders => 'Top Spenders';

  @override
  String transactionsCount(int count) {
    return '$count transactions';
  }

  @override
  String get activityHeatmap => 'Activity Heatmap';

  @override
  String get less => 'Less';

  @override
  String get more => 'More';

  @override
  String get backupRecoveryTitle => 'Backup & Recovery';

  @override
  String get backupDescription =>
      'Secure your data by creating a local backup file (JSON). You can restore this file later or on another device.';

  @override
  String get createBackup => 'Create Backup';

  @override
  String get restoreBackup => 'Restore Backup';

  @override
  String get createBackupSubtitle => 'Export all data to a JSON file';

  @override
  String get restoreBackupSubtitle =>
      'Import data from a JSON file (Wipes current data)';

  @override
  String get creatingBackup => 'Creating backup...';

  @override
  String get restoringBackup => 'Restoring backup...';

  @override
  String backupSuccess(String path) {
    return 'Backup saved successfully to:\n$path';
  }

  @override
  String get restoreSuccess =>
      'Backup restored successfully!\nPlease restart the app if data doesn\'t appear immediately.';

  @override
  String backupError(String error) {
    return 'Failed to create backup: $error';
  }

  @override
  String restoreError(String error) {
    return 'Failed to restore backup: $error';
  }

  @override
  String get restoreWarningTitle => '⚠️ Warning: Restore Data';

  @override
  String get restoreWarningMessage =>
      'Restoring a backup will DELETE ALL current data on this device and replace it with the backup content.\n\nThis action cannot be undone. Are you sure?';

  @override
  String get yesRestore => 'Yes, Restore';

  @override
  String get exportDataTitle => 'Export Data';

  @override
  String get dateRange => 'Date Range';

  @override
  String get transactionType => 'Transaction Type';

  @override
  String get allWallets => 'All Wallets';

  @override
  String get allCategories => 'All Categories';

  @override
  String shareCsv(int count) {
    return 'Share CSV ($count items)';
  }

  @override
  String get saveToDownloads => 'Save to Downloads';

  @override
  String get calculating => 'Calculating...';

  @override
  String get noTransactionsMatch => 'No transactions match selected filters.';

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String saveFailed(String error) {
    return 'Save failed: $error';
  }

  @override
  String fileSavedTo(String path) {
    return 'File saved to: $path';
  }

  @override
  String get lastMonth => 'Last Month';

  @override
  String get sendFeedbackTitle => 'Send Feedback';

  @override
  String get weValueYourVoice => 'We Value Your Voice';

  @override
  String get feedbackDescription =>
      'Have a new feature idea? Found a bug? Or just want to say hi? We are ready to listen! Your feedback means a lot to Ollo\'s development.';

  @override
  String get chatViaWhatsApp => 'Chat via WhatsApp';

  @override
  String get repliesInHours => 'Typically replies within a few hours';

  @override
  String subCategoriesCount(int count) {
    return '$count sub-categories';
  }

  @override
  String get unnamed => 'Unnamed';

  @override
  String get ok => 'OK';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get whatsappMessage =>
      'Hello Ollo Team, I want to provide feedback...';

  @override
  String get roadmapTitle => 'Product Roadmap';

  @override
  String get roadmapInProgress => 'In Progress';

  @override
  String get roadmapPlanned => 'Planned';

  @override
  String get roadmapCompleted => 'Completed';

  @override
  String get roadmapHighPriority => 'High Priority';

  @override
  String get roadmapBeta => 'BETA';

  @override
  String get roadmapDev => 'Dev';

  @override
  String get featureCloudBackupTitle => 'Cloud Backup (Google Drive)';

  @override
  String get featureCloudBackupDesc =>
      'Sync your data securely to your personal Google Drive.';

  @override
  String get featureAiInsightsTitle => 'Advanced AI Insights';

  @override
  String get featureAiInsightsDesc =>
      'Deeper analysis of your spending habits with personalized tips.';

  @override
  String get featureDataExportTitle => 'Data Export to CSV/Excel';

  @override
  String get featureDataExportDesc =>
      'Export transaction history for external analysis in Excel or Sheets.';

  @override
  String get featureBudgetForecastingTitle => 'Budget Forecasting';

  @override
  String get featureBudgetForecastingDesc =>
      'Predict next month\'s expenses based on historical data.';

  @override
  String get featureMultiCurrencyTitle => 'Multi-Currency Support';

  @override
  String get featureMultiCurrencyDesc =>
      'Real-time conversion for international transactions.';

  @override
  String get featureReceiptScanningTitle => 'Receipt Scanning OCR';

  @override
  String get featureReceiptScanningDesc =>
      'Scan receipts to automatically input transaction details.';

  @override
  String get featureLocalBackupTitle => 'Full Local Backup';

  @override
  String get featureLocalBackupDesc =>
      'Backup all app data (transactions, wallets, notes, etc.) to a local file.';

  @override
  String get featureSmartNotesTitle => 'Smart Notes';

  @override
  String get featureSmartNotesDesc =>
      'Shopping lists with checklists and total calculation.';

  @override
  String get featureRecurringTitle => 'Recurring Transactions';

  @override
  String get featureRecurringDesc => 'Automate bills and salary inputs.';

  @override
  String get aboutTitle => 'About Ollo';

  @override
  String get aboutPhilosophyTitle => 'Your Financial Companion';

  @override
  String get aboutPhilosophyDesc =>
      'Ollo is born from the belief that managing finances shouldn\'t be complicated. We want to create a smart, friendly financial companion that helps you achieve your financial dreams, one step at a time.';

  @override
  String get connectWithUs => 'Connect with us';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get helpTitle => 'Help & Support';

  @override
  String get helpIntroTitle => 'How can we help you?';

  @override
  String get helpIntroDesc =>
      'Find answers to common questions or contact our support team directly.';

  @override
  String get faqTitle => 'Frequently Asked Questions';

  @override
  String get faqAddWalletQuestion => 'How do I add a new wallet?';

  @override
  String get faqAddWalletAnswer =>
      'Go to the \"Wallets\" menu and tap the \"+\" button in the top right corner. Select the wallet type (Cash, Bank, etc.), enter the name and initial balance, then save.';

  @override
  String get faqExportDataQuestion => 'Can I export my data?';

  @override
  String get faqExportDataAnswer =>
      'Data export is a Premium feature coming soon. It will allow you to export your transactions to CSV or Excel formats.';

  @override
  String get faqResetDataQuestion => 'How do I reset my data?';

  @override
  String get faqResetDataAnswer =>
      'Currently, you can delete individual transactions or wallets. A full factory reset option will be available in the Settings menu in a future update.';

  @override
  String get faqSecureDataQuestion => 'Is my data secure?';

  @override
  String get faqSecureDataAnswer =>
      'Yes, all your data is stored locally on your device. We do not upload your personal financial data to any external servers.';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get reimbursementTitle => 'Reimbursement';

  @override
  String get reimbursementPending => 'Pending';

  @override
  String get reimbursementCompleted => 'Completed';

  @override
  String get noPendingReimbursements => 'No pending reimbursements';

  @override
  String get noCompletedReimbursements => 'No completed reimbursements';

  @override
  String get markPaid => 'Mark Paid';

  @override
  String get totalSavings => 'Total Savings';

  @override
  String get financialBuckets => 'Financial Buckets';

  @override
  String get noSavingsYet => 'No savings yet';

  @override
  String growthThisMonth(String percent) {
    return '$percent% this month';
  }

  @override
  String get myCards => 'My Cards';

  @override
  String selectedCount(int count) {
    return '$count Selected';
  }

  @override
  String get copyNumber => 'Copy Number';

  @override
  String get copyTemplate => 'Copy Template';

  @override
  String cardsCopied(int count) {
    return '$count cards copied!';
  }

  @override
  String get cardNumberCopied => 'Card number copied!';

  @override
  String get cardTemplateCopied => 'Card template copied!';

  @override
  String get noCardsYet => 'No cards yet';

  @override
  String get addCardsMessage => 'Add your bank accounts or e-wallets';

  @override
  String get premiumTitle => 'Unlock Full Potential';

  @override
  String get premiumSubtitle =>
      'Upgrade to Premium for advanced features and unlimited access.';

  @override
  String get premiumAdvancedStats => 'Advanced Statistics';

  @override
  String get premiumAdvancedStatsDesc => 'Interactive charts & deep insights';

  @override
  String get premiumDataExport => 'Data Export';

  @override
  String get premiumDataExportDesc => 'Export to CSV/Excel for backup';

  @override
  String get premiumUnlimitedWallets => 'Unlimited Wallets';

  @override
  String get premiumUnlimitedWalletsDesc =>
      'Create as many wallets as you need';

  @override
  String get premiumSmartAlerts => 'Smart Alerts';

  @override
  String get premiumSmartAlertsDesc => 'Get notified before you overspend';

  @override
  String get upgradeButton => 'Upgrade Now - Rp 29.000 / Lifetime';

  @override
  String get restorePurchase => 'Restore Purchase';

  @override
  String get youArePremium => 'You are Premium!';

  @override
  String get premiumWelcome => 'Welcome to Premium! 🌟';

  @override
  String get contactSupportMessage =>
      'Hello Ollo Support Team, I need help regarding...';

  @override
  String get category_food => 'Food & Drink';

  @override
  String get category_transport => 'Transport';

  @override
  String get category_shopping => 'Shopping';

  @override
  String get category_housing => 'Housing';

  @override
  String get category_entertainment => 'Entertainment';

  @override
  String get category_health => 'Health';

  @override
  String get category_education => 'Education';

  @override
  String get category_personal => 'Personal';

  @override
  String get category_financial => 'Financial';

  @override
  String get category_family => 'Family';

  @override
  String get category_salary => 'Salary';

  @override
  String get category_business => 'Business';

  @override
  String get category_investments => 'Investments';

  @override
  String get category_gifts_income => 'Gifts';

  @override
  String get category_other_income => 'Other';

  @override
  String get subcategory_breakfast => 'Breakfast';

  @override
  String get subcategory_lunch => 'Lunch';

  @override
  String get subcategory_dinner => 'Dinner';

  @override
  String get subcategory_eateries => 'Eateries';

  @override
  String get subcategory_snacks => 'Snacks';

  @override
  String get subcategory_drinks => 'Drinks';

  @override
  String get subcategory_groceries => 'Groceries';

  @override
  String get subcategory_delivery => 'Delivery';

  @override
  String get subcategory_alcohol => 'Alcohol';

  @override
  String get subcategory_bus => 'Bus';

  @override
  String get subcategory_train => 'Train';

  @override
  String get subcategory_taxi => 'Taxi';

  @override
  String get subcategory_fuel => 'Fuel';

  @override
  String get subcategory_parking => 'Parking';

  @override
  String get subcategory_maintenance => 'Maintenance';

  @override
  String get subcategory_insurance_car => 'Insurance';

  @override
  String get subcategory_toll => 'Toll';

  @override
  String get subcategory_clothes => 'Clothes';

  @override
  String get subcategory_electronics => 'Electronics';

  @override
  String get subcategory_home => 'Home';

  @override
  String get subcategory_beauty => 'Beauty';

  @override
  String get subcategory_gifts => 'Gifts';

  @override
  String get subcategory_software => 'Software';

  @override
  String get subcategory_tools => 'Tools';

  @override
  String get subcategory_rent => 'Rent';

  @override
  String get subcategory_mortgage => 'Mortgage';

  @override
  String get subcategory_utilities => 'Utilities';

  @override
  String get subcategory_internet => 'Internet';

  @override
  String get subcategory_maintenance_home => 'Maintenance';

  @override
  String get subcategory_furniture => 'Furniture';

  @override
  String get subcategory_services => 'Services';

  @override
  String get subcategory_movies => 'Movies';

  @override
  String get subcategory_games => 'Games';

  @override
  String get subcategory_streaming => 'Streaming';

  @override
  String get subcategory_events => 'Events';

  @override
  String get subcategory_hobbies => 'Hobbies';

  @override
  String get subcategory_travel => 'Travel';

  @override
  String get monthlyCommitment => 'Monthly Commitment';

  @override
  String get upcomingBill => 'Upcoming Bill';

  @override
  String get noUpcomingBills => 'No upcoming bills';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String inDays(Object days) {
    return 'In $days days';
  }

  @override
  String get needTwoWallets => 'Need 2+ wallets';

  @override
  String get nettBalance => 'Nett Balance';

  @override
  String get activeDebt => 'Active Debt';

  @override
  String get last30Days => 'last 30 days';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get premiumMember => 'Premium Member';

  @override
  String get upgradeToPremium => 'Upgrade to Premium';

  @override
  String get unlimitedAccess => 'You have unlimited access!';

  @override
  String get unlockFeatures => 'Unlock all features & remove limits.';

  @override
  String get from => 'From';

  @override
  String get subcategory_music => 'Music';

  @override
  String get subcategory_doctor => 'Doctor';

  @override
  String get subcategory_pharmacy => 'Pharmacy';

  @override
  String get subcategory_gym => 'Gym';

  @override
  String get subcategory_insurance_health => 'Insurance';

  @override
  String get subcategory_mental_health => 'Mental Health';

  @override
  String get subcategory_sports => 'Sports';

  @override
  String get subcategory_tuition => 'Tuition';

  @override
  String get subcategory_books => 'Books';

  @override
  String get subcategory_courses => 'Courses';

  @override
  String get subcategory_supplies => 'Supplies';

  @override
  String get subcategory_haircut => 'Haircut';

  @override
  String get subcategory_spa => 'Spa';

  @override
  String get subcategory_cosmetics => 'Cosmetics';

  @override
  String get subcategory_taxes => 'Taxes';

  @override
  String get subcategory_fees => 'Fees';

  @override
  String get subcategory_fines => 'Fines';

  @override
  String get subcategory_insurance_life => 'Insurance';

  @override
  String get subcategory_childcare => 'Childcare';

  @override
  String get subcategory_toys => 'Toys';

  @override
  String get subcategory_school_kids => 'School';

  @override
  String get subcategory_pets => 'Pets';

  @override
  String get subcategory_monthly => 'Monthly';

  @override
  String get subcategory_weekly => 'Weekly';

  @override
  String get subcategory_bonus => 'Bonus';

  @override
  String get subcategory_overtime => 'Overtime';

  @override
  String get subcategory_sales => 'Sales';

  @override
  String get subcategory_profit => 'Profit';

  @override
  String get subcategory_dividends => 'Dividends';

  @override
  String get subcategory_interest => 'Interest';

  @override
  String get subcategory_crypto => 'Crypto';

  @override
  String get subcategory_stocks => 'Stocks';

  @override
  String get subcategory_real_estate => 'Real Estate';

  @override
  String get subcategory_birthday => 'Birthday';

  @override
  String get subcategory_holiday => 'Holiday';

  @override
  String get subcategory_allowance => 'Allowance';

  @override
  String get subcategory_refunds => 'Refunds';

  @override
  String get subcategory_grants => 'Grants';

  @override
  String get subcategory_lottery => 'Lottery';

  @override
  String get subcategory_selling => 'Selling';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get nameLabel => 'Name';

  @override
  String get emailLabel => 'Email (Optional)';

  @override
  String get uploadPhoto => 'Upload Photo';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get listeningMessage => 'Ollo AI is Listening...';

  @override
  String get quickRecordTitle => 'Quick Record';

  @override
  String get saySomethingHint => 'Say \'Lunch 50k\'...';

  @override
  String get stopAndProcess => 'Stop & Process';

  @override
  String get textInputHint => 'e.g. \"Lunch 50k\", \"Salary 10m\"';

  @override
  String get draftReady => 'Draft Ready';

  @override
  String get saveAdjust => 'Save / Adjust';

  @override
  String get notFound => 'Not Found';

  @override
  String get selectWallet => 'Select Wallet';
}
