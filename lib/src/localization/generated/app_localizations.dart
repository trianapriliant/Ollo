import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('hi'),
    Locale('id'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// No description provided for @quickRecordHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Try saying:'**
  String get quickRecordHelpTitle;

  /// No description provided for @quickRecordHelp1.
  ///
  /// In en, this message translates to:
  /// **'\"Yesterday coffee 25k using BCA\"'**
  String get quickRecordHelp1;

  /// No description provided for @quickRecordHelp2.
  ///
  /// In en, this message translates to:
  /// **'\"Receive salary 10 million to BCA\"'**
  String get quickRecordHelp2;

  /// No description provided for @quickRecordHelp3.
  ///
  /// In en, this message translates to:
  /// **'\"Lunch 25k using OVO\"'**
  String get quickRecordHelp3;

  /// No description provided for @quickRecordHelp4.
  ///
  /// In en, this message translates to:
  /// **'\"Gasoline 50k using Mandiri\"'**
  String get quickRecordHelp4;

  /// No description provided for @quickRecordHelp5.
  ///
  /// In en, this message translates to:
  /// **'\"Pay rent 1.5 million using Jago on 1st\"'**
  String get quickRecordHelp5;

  /// No description provided for @quickRecordHelp6.
  ///
  /// In en, this message translates to:
  /// **'\"Buy coffee 20k using BCA\"'**
  String get quickRecordHelp6;

  /// No description provided for @quickRecordHelp7.
  ///
  /// In en, this message translates to:
  /// **'\"Pay wifi 300k using OVO on 20th\"'**
  String get quickRecordHelp7;

  /// No description provided for @quickRecordHelp8.
  ///
  /// In en, this message translates to:
  /// **'\"Cinema 100k using Dana this Sunday\"'**
  String get quickRecordHelp8;

  /// No description provided for @quickRecordHelp9.
  ///
  /// In en, this message translates to:
  /// **'\"Pay debt Budi 50k using Cash\"'**
  String get quickRecordHelp9;

  /// No description provided for @quickRecordHelp10.
  ///
  /// In en, this message translates to:
  /// **'\"Transfer Mom 1 million using Mandiri\"'**
  String get quickRecordHelp10;

  /// No description provided for @customizeMenu.
  ///
  /// In en, this message translates to:
  /// **'Customize Menu'**
  String get customizeMenu;

  /// No description provided for @menuOrder.
  ///
  /// In en, this message translates to:
  /// **'Menu Order'**
  String get menuOrder;

  /// No description provided for @resetMenu.
  ///
  /// In en, this message translates to:
  /// **'Reset Menu'**
  String get resetMenu;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @cardAppearance.
  ///
  /// In en, this message translates to:
  /// **'Card Appearance'**
  String get cardAppearance;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @themeClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic Blue'**
  String get themeClassic;

  /// No description provided for @themeSunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset Orange'**
  String get themeSunset;

  /// No description provided for @themeOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean Teal'**
  String get themeOcean;

  /// No description provided for @themeBerry.
  ///
  /// In en, this message translates to:
  /// **'Berry Purple'**
  String get themeBerry;

  /// No description provided for @themeForest.
  ///
  /// In en, this message translates to:
  /// **'Nature Green'**
  String get themeForest;

  /// No description provided for @themeMidnight.
  ///
  /// In en, this message translates to:
  /// **'Midnight Dark'**
  String get themeMidnight;

  /// No description provided for @themeOasis.
  ///
  /// In en, this message translates to:
  /// **'Calm Oasis'**
  String get themeOasis;

  /// No description provided for @themeLavender.
  ///
  /// In en, this message translates to:
  /// **'Soft Lavender'**
  String get themeLavender;

  /// No description provided for @themeCottonCandy.
  ///
  /// In en, this message translates to:
  /// **'Pastel Dream'**
  String get themeCottonCandy;

  /// No description provided for @themeMint.
  ///
  /// In en, this message translates to:
  /// **'Simply Mint'**
  String get themeMint;

  /// No description provided for @themePeach.
  ///
  /// In en, this message translates to:
  /// **'Simply Peach'**
  String get themePeach;

  /// No description provided for @themeSoftBlue.
  ///
  /// In en, this message translates to:
  /// **'Simply Blue'**
  String get themeSoftBlue;

  /// No description provided for @themeLilac.
  ///
  /// In en, this message translates to:
  /// **'Simply Lilac'**
  String get themeLilac;

  /// No description provided for @themeLemon.
  ///
  /// In en, this message translates to:
  /// **'Simply Lemon'**
  String get themeLemon;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @addNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Add a note...'**
  String get addNoteHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @errorInvalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get errorInvalidAmount;

  /// No description provided for @errorSelectWallet.
  ///
  /// In en, this message translates to:
  /// **'Please select a wallet'**
  String get errorSelectWallet;

  /// No description provided for @errorSelectDestinationWallet.
  ///
  /// In en, this message translates to:
  /// **'Please select a destination wallet'**
  String get errorSelectDestinationWallet;

  /// No description provided for @errorSameWallets.
  ///
  /// In en, this message translates to:
  /// **'Source and destination wallets must be different'**
  String get errorSameWallets;

  /// No description provided for @errorSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get errorSelectCategory;

  /// No description provided for @transactionDetail.
  ///
  /// In en, this message translates to:
  /// **'Transaction Detail'**
  String get transactionDetail;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @dateTime.
  ///
  /// In en, this message translates to:
  /// **'Date Time'**
  String get dateTime;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @deleteTransaction.
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction'**
  String get deleteTransaction;

  /// No description provided for @deleteTransactionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction?'**
  String get deleteTransactionConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @markCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get markCompleted;

  /// No description provided for @markCompletedConfirm.
  ///
  /// In en, this message translates to:
  /// **'Mark this transaction as completed?'**
  String get markCompletedConfirm;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactions;

  /// No description provided for @startRecording.
  ///
  /// In en, this message translates to:
  /// **'Start recording your expenses and income to keep your finances organized! 🚀'**
  String get startRecording;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @recurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurring;

  /// No description provided for @savings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savings;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @bills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get bills;

  /// No description provided for @debts.
  ///
  /// In en, this message translates to:
  /// **'Debts'**
  String get debts;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @cards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cards;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @reimburse.
  ///
  /// In en, this message translates to:
  /// **'Reimburse'**
  String get reimburse;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}!'**
  String welcome(String name);

  /// No description provided for @welcomeSimple.
  ///
  /// In en, this message translates to:
  /// **'Hi!'**
  String get welcomeSimple;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @developerOptions.
  ///
  /// In en, this message translates to:
  /// **'Developer Options'**
  String get developerOptions;

  /// No description provided for @futureFeatures.
  ///
  /// In en, this message translates to:
  /// **'Future Features'**
  String get futureFeatures;

  /// No description provided for @backupRecovery.
  ///
  /// In en, this message translates to:
  /// **'Backup & Recovery'**
  String get backupRecovery;

  /// No description provided for @aiAutomation.
  ///
  /// In en, this message translates to:
  /// **'AI Automation'**
  String get aiAutomation;

  /// No description provided for @feedbackRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Feedback & Roadmap'**
  String get feedbackRoadmap;

  /// No description provided for @dataExport.
  ///
  /// In en, this message translates to:
  /// **'Data Export'**
  String get dataExport;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @wallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get wallets;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @aboutOllo.
  ///
  /// In en, this message translates to:
  /// **'About Ollo'**
  String get aboutOllo;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @deleteData.
  ///
  /// In en, this message translates to:
  /// **'Delete Data'**
  String get deleteData;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @comingSoonDesc.
  ///
  /// In en, this message translates to:
  /// **'Let AI categorize your transactions and provide smart financial insights.'**
  String get comingSoonDesc;

  /// No description provided for @cantWait.
  ///
  /// In en, this message translates to:
  /// **'Can\'t Wait!'**
  String get cantWait;

  /// No description provided for @deleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete All Data?'**
  String get deleteAllData;

  /// No description provided for @deleteAllDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'This action will permanently delete ALL your transactions, wallets, budgets, and notes. This cannot be undone.\n\nTo confirm, please type \"{confirmationText}\" below:'**
  String deleteAllDataConfirm(String confirmationText);

  /// No description provided for @deleteDataConfirmationText.
  ///
  /// In en, this message translates to:
  /// **'Delete Data'**
  String get deleteDataConfirmationText;

  /// No description provided for @dataDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'All data deleted successfully. Please restart the app.'**
  String get dataDeletedSuccess;

  /// No description provided for @dataDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete data: {error}'**
  String dataDeleteFailed(String error);

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get selectCurrency;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @myWallets.
  ///
  /// In en, this message translates to:
  /// **'My Wallets'**
  String get myWallets;

  /// No description provided for @emptyWalletsTitle.
  ///
  /// In en, this message translates to:
  /// **'No wallets yet'**
  String get emptyWalletsTitle;

  /// No description provided for @emptyWalletsMessage.
  ///
  /// In en, this message translates to:
  /// **'Add a wallet or bank account to start tracking! 💳'**
  String get emptyWalletsMessage;

  /// No description provided for @addWallet.
  ///
  /// In en, this message translates to:
  /// **'Add New Wallet'**
  String get addWallet;

  /// No description provided for @editWallet.
  ///
  /// In en, this message translates to:
  /// **'Edit Wallet'**
  String get editWallet;

  /// No description provided for @newWallet.
  ///
  /// In en, this message translates to:
  /// **'New Wallet'**
  String get newWallet;

  /// No description provided for @walletName.
  ///
  /// In en, this message translates to:
  /// **'Wallet Name'**
  String get walletName;

  /// No description provided for @initialBalance.
  ///
  /// In en, this message translates to:
  /// **'Initial Balance'**
  String get initialBalance;

  /// No description provided for @walletDetails.
  ///
  /// In en, this message translates to:
  /// **'Wallet Details'**
  String get walletDetails;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @saveWallet.
  ///
  /// In en, this message translates to:
  /// **'Save Wallet'**
  String get saveWallet;

  /// No description provided for @walletTypeCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get walletTypeCash;

  /// No description provided for @walletTypeBank.
  ///
  /// In en, this message translates to:
  /// **'Bank Accounts'**
  String get walletTypeBank;

  /// No description provided for @walletTypeEWallet.
  ///
  /// In en, this message translates to:
  /// **'E-Wallets'**
  String get walletTypeEWallet;

  /// No description provided for @walletTypeCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Cards'**
  String get walletTypeCreditCard;

  /// No description provided for @walletTypeExchange.
  ///
  /// In en, this message translates to:
  /// **'Exchanges / Investments'**
  String get walletTypeExchange;

  /// No description provided for @walletTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get walletTypeOther;

  /// No description provided for @debitCard.
  ///
  /// In en, this message translates to:
  /// **'Debit Card'**
  String get debitCard;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get noCategoriesFound;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get newCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @enterCategoryName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get enterCategoryName;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete Category?'**
  String get deleteCategory;

  /// No description provided for @deleteCategoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteCategoryConfirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @systemCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'System Category'**
  String get systemCategoryTitle;

  /// No description provided for @systemCategoryMessage.
  ///
  /// In en, this message translates to:
  /// **'This category is managed by the system and cannot be edited or deleted manually.'**
  String get systemCategoryMessage;

  /// No description provided for @sysCatTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get sysCatTransfer;

  /// No description provided for @sysCatTransferDesc.
  ///
  /// In en, this message translates to:
  /// **'Fund transfers between wallets'**
  String get sysCatTransferDesc;

  /// No description provided for @sysCatRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get sysCatRecurring;

  /// No description provided for @sysCatRecurringDesc.
  ///
  /// In en, this message translates to:
  /// **'Automated recurring transactions'**
  String get sysCatRecurringDesc;

  /// No description provided for @sysCatWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get sysCatWishlist;

  /// No description provided for @sysCatWishlistDesc.
  ///
  /// In en, this message translates to:
  /// **'Automated transactions from Wishlist purchases'**
  String get sysCatWishlistDesc;

  /// No description provided for @sysCatBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get sysCatBills;

  /// No description provided for @sysCatBillsDesc.
  ///
  /// In en, this message translates to:
  /// **'Automated transactions from Bill payments'**
  String get sysCatBillsDesc;

  /// No description provided for @dueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDateLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @noPaymentsYet.
  ///
  /// In en, this message translates to:
  /// **'No payments yet'**
  String get noPaymentsYet;

  /// No description provided for @sysCatDebts.
  ///
  /// In en, this message translates to:
  /// **'Debts'**
  String get sysCatDebts;

  /// No description provided for @sysCatDebtsDesc.
  ///
  /// In en, this message translates to:
  /// **'Automated transactions from Debt/Loan records'**
  String get sysCatDebtsDesc;

  /// No description provided for @sysCatSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get sysCatSavings;

  /// No description provided for @sysCatSavingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Automated transactions from Savings deposits/withdrawals'**
  String get sysCatSavingsDesc;

  /// No description provided for @sysCatSmartNotes.
  ///
  /// In en, this message translates to:
  /// **'Bundled Notes'**
  String get sysCatSmartNotes;

  /// No description provided for @sysCatSmartNotesDesc.
  ///
  /// In en, this message translates to:
  /// **'Automated transactions from Smart Bundles'**
  String get sysCatSmartNotesDesc;

  /// No description provided for @sysCatReimburse.
  ///
  /// In en, this message translates to:
  /// **'Reimburse'**
  String get sysCatReimburse;

  /// No description provided for @sysCatReimburseDesc.
  ///
  /// In en, this message translates to:
  /// **'Reimbursement tracking system'**
  String get sysCatReimburseDesc;

  /// No description provided for @sysCatAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Balance Adjustment'**
  String get sysCatAdjustment;

  /// No description provided for @sysCatAdjustmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Manual wallet balance corrections'**
  String get sysCatAdjustmentDesc;

  /// No description provided for @budgetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgetsTitle;

  /// No description provided for @noBudgetsYet.
  ///
  /// In en, this message translates to:
  /// **'No budgets yet'**
  String get noBudgetsYet;

  /// No description provided for @createBudget.
  ///
  /// In en, this message translates to:
  /// **'Create Budget'**
  String get createBudget;

  /// No description provided for @yourBudgets.
  ///
  /// In en, this message translates to:
  /// **'Your Budgets'**
  String get yourBudgets;

  /// No description provided for @newBudget.
  ///
  /// In en, this message translates to:
  /// **'New Budget'**
  String get newBudget;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit Budget'**
  String get editBudget;

  /// No description provided for @limitAmount.
  ///
  /// In en, this message translates to:
  /// **'Limit Amount'**
  String get limitAmount;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @deleteBudget.
  ///
  /// In en, this message translates to:
  /// **'Delete Budget'**
  String get deleteBudget;

  /// No description provided for @deleteBudgetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this budget?'**
  String get deleteBudgetConfirm;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @recurringTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurringTitle;

  /// No description provided for @activeSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Active Subscriptions'**
  String get activeSubscriptions;

  /// No description provided for @noActiveSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'No active subscriptions'**
  String get noActiveSubscriptions;

  /// No description provided for @newRecurring.
  ///
  /// In en, this message translates to:
  /// **'New Recurring'**
  String get newRecurring;

  /// No description provided for @editRecurring.
  ///
  /// In en, this message translates to:
  /// **'Edit Recurring'**
  String get editRecurring;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @payWithWallet.
  ///
  /// In en, this message translates to:
  /// **'Pay with Wallet'**
  String get payWithWallet;

  /// No description provided for @updateRecurring.
  ///
  /// In en, this message translates to:
  /// **'Update Recurring'**
  String get updateRecurring;

  /// No description provided for @saveRecurring.
  ///
  /// In en, this message translates to:
  /// **'Save Recurring'**
  String get saveRecurring;

  /// No description provided for @deleteRecurring.
  ///
  /// In en, this message translates to:
  /// **'Delete Recurring?'**
  String get deleteRecurring;

  /// No description provided for @deleteRecurringConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will stop future auto-payments. Past transactions will remain.'**
  String get deleteRecurringConfirm;

  /// No description provided for @pleaseSelectWallet.
  ///
  /// In en, this message translates to:
  /// **'Please select a wallet'**
  String get pleaseSelectWallet;

  /// No description provided for @debtsTitle.
  ///
  /// In en, this message translates to:
  /// **'Debts'**
  String get debtsTitle;

  /// No description provided for @iOwe.
  ///
  /// In en, this message translates to:
  /// **'I Owe'**
  String get iOwe;

  /// No description provided for @owedToMe.
  ///
  /// In en, this message translates to:
  /// **'Owed to Me'**
  String get owedToMe;

  /// No description provided for @netBalance.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get netBalance;

  /// No description provided for @debtFree.
  ///
  /// In en, this message translates to:
  /// **'You are debt free!'**
  String get debtFree;

  /// No description provided for @noOneOwesYou.
  ///
  /// In en, this message translates to:
  /// **'No one owes you money.'**
  String get noOneOwesYou;

  /// No description provided for @paidStatus.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paidStatus;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @dueOnDate.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String dueOnDate(String date);

  /// No description provided for @amountLeft.
  ///
  /// In en, this message translates to:
  /// **'{amount} left'**
  String amountLeft(String amount);

  /// No description provided for @deleteDebt.
  ///
  /// In en, this message translates to:
  /// **'Delete Debt?'**
  String get deleteDebt;

  /// No description provided for @deleteDebtConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will remove the debt record.'**
  String get deleteDebtConfirm;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'Sort by Date'**
  String get sortByDate;

  /// No description provided for @sortByAmount.
  ///
  /// In en, this message translates to:
  /// **'Sort by Amount'**
  String get sortByAmount;

  /// No description provided for @editDebt.
  ///
  /// In en, this message translates to:
  /// **'Edit Debt/Loan'**
  String get editDebt;

  /// No description provided for @addDebt.
  ///
  /// In en, this message translates to:
  /// **'Add Debt/Loan'**
  String get addDebt;

  /// No description provided for @iBorrowed.
  ///
  /// In en, this message translates to:
  /// **'I Borrowed'**
  String get iBorrowed;

  /// No description provided for @iLent.
  ///
  /// In en, this message translates to:
  /// **'I Lent'**
  String get iLent;

  /// No description provided for @personName.
  ///
  /// In en, this message translates to:
  /// **'Person Name'**
  String get personName;

  /// No description provided for @whoHint.
  ///
  /// In en, this message translates to:
  /// **'Who?'**
  String get whoHint;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @updateDebt.
  ///
  /// In en, this message translates to:
  /// **'Update Debt'**
  String get updateDebt;

  /// No description provided for @saveDebt.
  ///
  /// In en, this message translates to:
  /// **'Save Debt'**
  String get saveDebt;

  /// No description provided for @debtSaved.
  ///
  /// In en, this message translates to:
  /// **'Debt saved successfully'**
  String get debtSaved;

  /// No description provided for @debtUpdated.
  ///
  /// In en, this message translates to:
  /// **'Debt updated successfully'**
  String get debtUpdated;

  /// No description provided for @debtDeleted.
  ///
  /// In en, this message translates to:
  /// **'Debt deleted'**
  String get debtDeleted;

  /// No description provided for @debtDetails.
  ///
  /// In en, this message translates to:
  /// **'Debt Details'**
  String get debtDetails;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistory;

  /// No description provided for @youOweName.
  ///
  /// In en, this message translates to:
  /// **'You owe {name}'**
  String youOweName(String name);

  /// No description provided for @nameOwesYou.
  ///
  /// In en, this message translates to:
  /// **'{name} owes you'**
  String nameOwesYou(String name);

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount}'**
  String totalAmount(String amount);

  /// No description provided for @paidAmount.
  ///
  /// In en, this message translates to:
  /// **'Paid: {amount}'**
  String paidAmount(String amount);

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @addPayment.
  ///
  /// In en, this message translates to:
  /// **'Add Payment'**
  String get addPayment;

  /// No description provided for @noneRecordOnly.
  ///
  /// In en, this message translates to:
  /// **'None (Just record)'**
  String get noneRecordOnly;

  /// No description provided for @confirmPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get confirmPayment;

  /// No description provided for @paymentRecorded.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded successfully!'**
  String get paymentRecorded;

  /// No description provided for @balanceUpdateDetected.
  ///
  /// In en, this message translates to:
  /// **'Balance Update Detected'**
  String get balanceUpdateDetected;

  /// No description provided for @recordAsTransaction.
  ///
  /// In en, this message translates to:
  /// **'Record as Transaction?'**
  String get recordAsTransaction;

  /// No description provided for @recordAsTransactionDesc.
  ///
  /// In en, this message translates to:
  /// **'The balance has changed by {amount}. Do you want to record this difference as a transaction?'**
  String recordAsTransactionDesc(String amount);

  /// No description provided for @adjustmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Balance Adjustment'**
  String get adjustmentTitle;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'No, Adjust Only'**
  String get skip;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Yes, Record'**
  String get record;

  /// No description provided for @updateBalance.
  ///
  /// In en, this message translates to:
  /// **'Update Balance'**
  String get updateBalance;

  /// No description provided for @newBalance.
  ///
  /// In en, this message translates to:
  /// **'New Balance'**
  String get newBalance;

  /// No description provided for @deleteWalletTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Wallet?'**
  String get deleteWalletTitle;

  /// No description provided for @deleteWalletConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This action cannot be undone.'**
  String deleteWalletConfirm(String name);

  /// No description provided for @deleteDebtWarning.
  ///
  /// In en, this message translates to:
  /// **'This will remove the debt record. Wallet balances will NOT be reverted automatically.'**
  String get deleteDebtWarning;

  /// No description provided for @billsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get billsTitle;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @paidTab.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paidTab;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get allCaughtUp;

  /// No description provided for @noUnpaidBills.
  ///
  /// In en, this message translates to:
  /// **'No unpaid bills at the moment.'**
  String get noUnpaidBills;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noHistoryYet;

  /// No description provided for @paidOnDate.
  ///
  /// In en, this message translates to:
  /// **'Paid {date}'**
  String paidOnDate(String date);

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due Today'**
  String get dueToday;

  /// No description provided for @dueInDays.
  ///
  /// In en, this message translates to:
  /// **'Due in {days} days'**
  String dueInDays(int days);

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @payBill.
  ///
  /// In en, this message translates to:
  /// **'Pay Bill'**
  String get payBill;

  /// No description provided for @payBillTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay \"{title}\"?'**
  String payBillTitle(String title);

  /// No description provided for @payFrom.
  ///
  /// In en, this message translates to:
  /// **'Pay from:'**
  String get payFrom;

  /// No description provided for @noWalletsFound.
  ///
  /// In en, this message translates to:
  /// **'No wallets found'**
  String get noWalletsFound;

  /// No description provided for @billPaidSuccess.
  ///
  /// In en, this message translates to:
  /// **'Bill paid successfully!'**
  String get billPaidSuccess;

  /// No description provided for @editBill.
  ///
  /// In en, this message translates to:
  /// **'Edit Bill'**
  String get editBill;

  /// No description provided for @addBill.
  ///
  /// In en, this message translates to:
  /// **'Add Bill'**
  String get addBill;

  /// No description provided for @billDetails.
  ///
  /// In en, this message translates to:
  /// **'Bill Details'**
  String get billDetails;

  /// No description provided for @billName.
  ///
  /// In en, this message translates to:
  /// **'Bill Name'**
  String get billName;

  /// No description provided for @billType.
  ///
  /// In en, this message translates to:
  /// **'Bill Type'**
  String get billType;

  /// No description provided for @repeatBill.
  ///
  /// In en, this message translates to:
  /// **'Repeat this bill?'**
  String get repeatBill;

  /// No description provided for @autoCreateBill.
  ///
  /// In en, this message translates to:
  /// **'Automatically create new bills'**
  String get autoCreateBill;

  /// No description provided for @updateBill.
  ///
  /// In en, this message translates to:
  /// **'Update Bill'**
  String get updateBill;

  /// No description provided for @saveBill.
  ///
  /// In en, this message translates to:
  /// **'Save Bill'**
  String get saveBill;

  /// No description provided for @billSaved.
  ///
  /// In en, this message translates to:
  /// **'Bill saved successfully'**
  String get billSaved;

  /// No description provided for @billUpdated.
  ///
  /// In en, this message translates to:
  /// **'Bill updated successfully'**
  String get billUpdated;

  /// No description provided for @billDeleted.
  ///
  /// In en, this message translates to:
  /// **'Bill deleted'**
  String get billDeleted;

  /// No description provided for @payBillDescription.
  ///
  /// In en, this message translates to:
  /// **'This will create a System transaction and deduct from your wallet.'**
  String get payBillDescription;

  /// No description provided for @deleteBill.
  ///
  /// In en, this message translates to:
  /// **'Delete Bill?'**
  String get deleteBill;

  /// No description provided for @deleteBillConfirm.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteBillConfirm;

  /// No description provided for @errorInvalidBill.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid title and amount'**
  String get errorInvalidBill;

  /// No description provided for @wishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlistTitle;

  /// No description provided for @activeTab.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeTab;

  /// No description provided for @achievedTab.
  ///
  /// In en, this message translates to:
  /// **'Achieved'**
  String get achievedTab;

  /// No description provided for @emptyActiveWishlistMessage.
  ///
  /// In en, this message translates to:
  /// **'Start adding items you want to buy'**
  String get emptyActiveWishlistMessage;

  /// No description provided for @emptyAchievedWishlistMessage.
  ///
  /// In en, this message translates to:
  /// **'No achieved dreams yet. Keep going!'**
  String get emptyAchievedWishlistMessage;

  /// No description provided for @noAchievementsYet.
  ///
  /// In en, this message translates to:
  /// **'No achievements yet'**
  String get noAchievementsYet;

  /// No description provided for @wishlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty'**
  String get wishlistEmpty;

  /// No description provided for @deleteItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Item?'**
  String get deleteItemTitle;

  /// No description provided for @deleteItemConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String deleteItemConfirm(String title);

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @buyItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy Item'**
  String get buyItemTitle;

  /// No description provided for @purchaseItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase \"{title}\"?'**
  String purchaseItemTitle(String title);

  /// No description provided for @selectWalletLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Wallet:'**
  String get selectWalletLabel;

  /// No description provided for @noWalletsFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'No wallets found. Please create a wallet first.'**
  String get noWalletsFoundMessage;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount:'**
  String get amountLabel;

  /// No description provided for @confirmPurchase.
  ///
  /// In en, this message translates to:
  /// **'Confirm Purchase'**
  String get confirmPurchase;

  /// No description provided for @purchaseSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Purchase successful! Dream achieved! 🎉'**
  String get purchaseSuccessMessage;

  /// No description provided for @errorLaunchingUrl.
  ///
  /// In en, this message translates to:
  /// **'Error launching URL: {error}'**
  String errorLaunchingUrl(String error);

  /// No description provided for @editWishlist.
  ///
  /// In en, this message translates to:
  /// **'Edit Wishlist'**
  String get editWishlist;

  /// No description provided for @addWishlist.
  ///
  /// In en, this message translates to:
  /// **'Add Wishlist'**
  String get addWishlist;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @itemNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. New Laptop'**
  String get itemNameHint;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @targetDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Target Date'**
  String get targetDateLabel;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @productLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Product Link (Optional)'**
  String get productLinkLabel;

  /// No description provided for @productLinkHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. https://shopee.co.id/...'**
  String get productLinkHint;

  /// No description provided for @updateWishlist.
  ///
  /// In en, this message translates to:
  /// **'Update Wishlist'**
  String get updateWishlist;

  /// No description provided for @saveWishlist.
  ///
  /// In en, this message translates to:
  /// **'Save to Wishlist'**
  String get saveWishlist;

  /// No description provided for @errorInvalidWishlist.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid title and price'**
  String get errorInvalidWishlist;

  /// No description provided for @wishlistUpdated.
  ///
  /// In en, this message translates to:
  /// **'Wishlist updated successfully'**
  String get wishlistUpdated;

  /// No description provided for @wishlistSaved.
  ///
  /// In en, this message translates to:
  /// **'Item added to wishlist!'**
  String get wishlistSaved;

  /// No description provided for @deleteWishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Wishlist?'**
  String get deleteWishlistTitle;

  /// No description provided for @deleteWishlistConfirm.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteWishlistConfirm;

  /// No description provided for @wishlistDeleted.
  ///
  /// In en, this message translates to:
  /// **'Wishlist deleted'**
  String get wishlistDeleted;

  /// No description provided for @errorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking image: {error}'**
  String errorPickingImage(String error);

  /// No description provided for @smartNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Bundles'**
  String get smartNotesTitle;

  /// No description provided for @emptySmartNotesMessage.
  ///
  /// In en, this message translates to:
  /// **'Create your first bundle!'**
  String get emptySmartNotesMessage;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorMessage(String error);

  /// No description provided for @addSmartNote.
  ///
  /// In en, this message translates to:
  /// **'New Bundle'**
  String get addSmartNote;

  /// No description provided for @noItemsInBundle.
  ///
  /// In en, this message translates to:
  /// **'No items in this bundle'**
  String get noItemsInBundle;

  /// No description provided for @payAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String payAmount(String amount);

  /// No description provided for @paidAndCompleted.
  ///
  /// In en, this message translates to:
  /// **'Paid & Completed'**
  String get paidAndCompleted;

  /// No description provided for @undoPay.
  ///
  /// In en, this message translates to:
  /// **'Undo Pay'**
  String get undoPay;

  /// No description provided for @deleteSmartNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Bundle?'**
  String get deleteSmartNoteTitle;

  /// No description provided for @confirmPaymentMessage.
  ///
  /// In en, this message translates to:
  /// **'Create transaction for {amount}?'**
  String confirmPaymentMessage(String amount);

  /// No description provided for @paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Paid & Completed!'**
  String get paymentSuccess;

  /// No description provided for @undoPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Undo Payment?'**
  String get undoPaymentTitle;

  /// No description provided for @undoPaymentConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will delete the transaction, refund the wallet, and reopen the bundle.'**
  String get undoPaymentConfirm;

  /// No description provided for @undoAndReopen.
  ///
  /// In en, this message translates to:
  /// **'Undo & Reopen'**
  String get undoAndReopen;

  /// No description provided for @purchaseReopened.
  ///
  /// In en, this message translates to:
  /// **'Purchase Reopened'**
  String get purchaseReopened;

  /// No description provided for @editSmartNote.
  ///
  /// In en, this message translates to:
  /// **'Edit Bundle'**
  String get editSmartNote;

  /// No description provided for @newSmartNote.
  ///
  /// In en, this message translates to:
  /// **'New Bundle'**
  String get newSmartNote;

  /// No description provided for @smartNoteName.
  ///
  /// In en, this message translates to:
  /// **'Bundle Name'**
  String get smartNoteName;

  /// No description provided for @smartNoteNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Monthly Groceries'**
  String get smartNoteNameHint;

  /// No description provided for @itemsList.
  ///
  /// In en, this message translates to:
  /// **'Items List'**
  String get itemsList;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @requiredShort.
  ///
  /// In en, this message translates to:
  /// **'Reqd'**
  String get requiredShort;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotes;

  /// No description provided for @totalEstimate.
  ///
  /// In en, this message translates to:
  /// **'Total Estimate'**
  String get totalEstimate;

  /// No description provided for @saveBundle.
  ///
  /// In en, this message translates to:
  /// **'Save Bundle'**
  String get saveBundle;

  /// No description provided for @checkedTotal.
  ///
  /// In en, this message translates to:
  /// **'Checked Total:'**
  String get checkedTotal;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @payAndFinish.
  ///
  /// In en, this message translates to:
  /// **'Pay & Finish'**
  String get payAndFinish;

  /// No description provided for @payingWith.
  ///
  /// In en, this message translates to:
  /// **'Paying with'**
  String get payingWith;

  /// No description provided for @noItemsChecked.
  ///
  /// In en, this message translates to:
  /// **'No items checked to pay!'**
  String get noItemsChecked;

  /// No description provided for @smartNoteTransactionRecorded.
  ///
  /// In en, this message translates to:
  /// **'Transaction recorded & Bundle completed!'**
  String get smartNoteTransactionRecorded;

  /// No description provided for @totalDreamValue.
  ///
  /// In en, this message translates to:
  /// **'Total Dream Value'**
  String get totalDreamValue;

  /// No description provided for @activeWishesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Wishes'**
  String activeWishesCount(int count);

  /// No description provided for @achievedDreamsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Dreams Achieved! 🎉'**
  String achievedDreamsCount(int count);

  /// No description provided for @billDataNotFound.
  ///
  /// In en, this message translates to:
  /// **'Bill data not found'**
  String get billDataNotFound;

  /// No description provided for @wishlistDataNotFound.
  ///
  /// In en, this message translates to:
  /// **'Wishlist data not found'**
  String get wishlistDataNotFound;

  /// No description provided for @editReimbursementNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Edit Reimbursement not fully supported yet'**
  String get editReimbursementNotSupported;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @noTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get noTransactionsFound;

  /// No description provided for @noTransactionsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No transactions in this category'**
  String get noTransactionsInCategory;

  /// No description provided for @noDataForPeriod.
  ///
  /// In en, this message translates to:
  /// **'No data for this period'**
  String get noDataForPeriod;

  /// No description provided for @monthlyOverview.
  ///
  /// In en, this message translates to:
  /// **'Monthly Overview'**
  String get monthlyOverview;

  /// No description provided for @unlockPremiumStats.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium Stats'**
  String get unlockPremiumStats;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @dailyBudget.
  ///
  /// In en, this message translates to:
  /// **'Daily Budget'**
  String get dailyBudget;

  /// No description provided for @weeklyBudget.
  ///
  /// In en, this message translates to:
  /// **'Weekly Budget'**
  String get weeklyBudget;

  /// No description provided for @monthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget'**
  String get monthlyBudget;

  /// No description provided for @yearlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Yearly Budget'**
  String get yearlyBudget;

  /// No description provided for @wishlistPurchase.
  ///
  /// In en, this message translates to:
  /// **'Wishlist Purchase'**
  String get wishlistPurchase;

  /// No description provided for @billPayment.
  ///
  /// In en, this message translates to:
  /// **'Bill Payment'**
  String get billPayment;

  /// No description provided for @debtTransaction.
  ///
  /// In en, this message translates to:
  /// **'Debt Transaction'**
  String get debtTransaction;

  /// No description provided for @savingsTransaction.
  ///
  /// In en, this message translates to:
  /// **'Savings Transaction'**
  String get savingsTransaction;

  /// No description provided for @transferTransaction.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transferTransaction;

  /// No description provided for @transferFee.
  ///
  /// In en, this message translates to:
  /// **'Transfer Fee'**
  String get transferFee;

  /// No description provided for @transferFeeHint.
  ///
  /// In en, this message translates to:
  /// **'Fee (Optional)'**
  String get transferFeeHint;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @importDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Transactions'**
  String get importDataTitle;

  /// No description provided for @downloadTemplate.
  ///
  /// In en, this message translates to:
  /// **'Download Template'**
  String get downloadTemplate;

  /// No description provided for @uploadCsv.
  ///
  /// In en, this message translates to:
  /// **'Upload CSV'**
  String get uploadCsv;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully imported {count} transactions!'**
  String importSuccess(Object count);

  /// No description provided for @importPartialSuccess.
  ///
  /// In en, this message translates to:
  /// **'Imported {success} transactions. Failed: {failed}.'**
  String importPartialSuccess(Object success, Object failed);

  /// No description provided for @templateSaved.
  ///
  /// In en, this message translates to:
  /// **'Template saved to downloads folder'**
  String get templateSaved;

  /// No description provided for @importInfoText.
  ///
  /// In en, this message translates to:
  /// **'Use the template to import your data correctly. Ensure column names match exactly.'**
  String get importInfoText;

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get pressBackAgainToExit;

  /// No description provided for @quickRecord.
  ///
  /// In en, this message translates to:
  /// **'Quick Record'**
  String get quickRecord;

  /// No description provided for @chatAction.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatAction;

  /// No description provided for @scanAction.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanAction;

  /// No description provided for @voiceAction.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voiceAction;

  /// No description provided for @filterDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get filterDay;

  /// No description provided for @filterWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get filterWeek;

  /// No description provided for @filterMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get filterMonth;

  /// No description provided for @filterYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get filterYear;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransaction;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @enterDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get enterDescriptionHint;

  /// No description provided for @enterTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter title (e.g. Breakfast)'**
  String get enterTitleHint;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get enterValidAmount;

  /// No description provided for @selectWalletError.
  ///
  /// In en, this message translates to:
  /// **'Please select a wallet'**
  String get selectWalletError;

  /// No description provided for @selectDestinationWalletError.
  ///
  /// In en, this message translates to:
  /// **'Please select a destination wallet'**
  String get selectDestinationWalletError;

  /// No description provided for @selectCategoryError.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get selectCategoryError;

  /// No description provided for @saveTransaction.
  ///
  /// In en, this message translates to:
  /// **'Save Transaction'**
  String get saveTransaction;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error(String error);

  /// No description provided for @expenseDetails.
  ///
  /// In en, this message translates to:
  /// **'Expense Details'**
  String get expenseDetails;

  /// No description provided for @incomeDetails.
  ///
  /// In en, this message translates to:
  /// **'Income Details'**
  String get incomeDetails;

  /// No description provided for @noExpensesFound.
  ///
  /// In en, this message translates to:
  /// **'No expenses found'**
  String get noExpensesFound;

  /// No description provided for @noIncomeFound.
  ///
  /// In en, this message translates to:
  /// **'No income found'**
  String get noIncomeFound;

  /// No description provided for @forThisDate.
  ///
  /// In en, this message translates to:
  /// **'for this date'**
  String get forThisDate;

  /// No description provided for @timeFilterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get timeFilterToday;

  /// No description provided for @timeFilterThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get timeFilterThisWeek;

  /// No description provided for @timeFilterThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get timeFilterThisMonth;

  /// No description provided for @timeFilterThisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get timeFilterThisYear;

  /// No description provided for @timeFilterAllTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get timeFilterAllTime;

  /// No description provided for @dailyOverview.
  ///
  /// In en, this message translates to:
  /// **'Daily Overview'**
  String get dailyOverview;

  /// No description provided for @dailyAverage.
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get dailyAverage;

  /// No description provided for @projectedTotal.
  ///
  /// In en, this message translates to:
  /// **'Projected Total'**
  String get projectedTotal;

  /// No description provided for @spendingHabitsNote.
  ///
  /// In en, this message translates to:
  /// **'Based on your spending habits so far this month.'**
  String get spendingHabitsNote;

  /// No description provided for @monthlyComparison.
  ///
  /// In en, this message translates to:
  /// **'Monthly Comparison'**
  String get monthlyComparison;

  /// No description provided for @spendingLessNote.
  ///
  /// In en, this message translates to:
  /// **'You are spending less than last month!'**
  String get spendingLessNote;

  /// No description provided for @spendingMoreNote.
  ///
  /// In en, this message translates to:
  /// **'Spending is higher than usual.'**
  String get spendingMoreNote;

  /// No description provided for @topSpenders.
  ///
  /// In en, this message translates to:
  /// **'Top Spenders'**
  String get topSpenders;

  /// No description provided for @transactionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions'**
  String transactionsCount(int count);

  /// No description provided for @activityHeatmap.
  ///
  /// In en, this message translates to:
  /// **'Activity Heatmap'**
  String get activityHeatmap;

  /// No description provided for @less.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get less;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @backupRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & Recovery'**
  String get backupRecoveryTitle;

  /// No description provided for @backupDescription.
  ///
  /// In en, this message translates to:
  /// **'Secure your data by creating a local backup file (JSON). You can restore this file later or on another device.'**
  String get backupDescription;

  /// No description provided for @popularBanks.
  ///
  /// In en, this message translates to:
  /// **'Popular Banks'**
  String get popularBanks;

  /// No description provided for @eWallets.
  ///
  /// In en, this message translates to:
  /// **'E-Wallets'**
  String get eWallets;

  /// No description provided for @bankEWalletLogos.
  ///
  /// In en, this message translates to:
  /// **'Bank & E-Wallet Logos'**
  String get bankEWalletLogos;

  /// No description provided for @genericIcons.
  ///
  /// In en, this message translates to:
  /// **'Generic Icons'**
  String get genericIcons;

  /// No description provided for @changeIcon.
  ///
  /// In en, this message translates to:
  /// **'Change Icon'**
  String get changeIcon;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @createBackup.
  ///
  /// In en, this message translates to:
  /// **'Create Backup'**
  String get createBackup;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get restoreBackup;

  /// No description provided for @createBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export all data to a JSON file'**
  String get createBackupSubtitle;

  /// No description provided for @restoreBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Import data from a JSON file (Wipes current data)'**
  String get restoreBackupSubtitle;

  /// No description provided for @creatingBackup.
  ///
  /// In en, this message translates to:
  /// **'Creating backup...'**
  String get creatingBackup;

  /// No description provided for @restoringBackup.
  ///
  /// In en, this message translates to:
  /// **'Restoring backup...'**
  String get restoringBackup;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @weeklyActivityHeatmap.
  ///
  /// In en, this message translates to:
  /// **'Weekly Activity'**
  String get weeklyActivityHeatmap;

  /// No description provided for @backupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup saved successfully to:\n{path}'**
  String backupSuccess(String path);

  /// No description provided for @restoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup restored successfully!\nPlease restart the app if data doesn\'t appear immediately.'**
  String get restoreSuccess;

  /// No description provided for @backupError.
  ///
  /// In en, this message translates to:
  /// **'Failed to create backup: {error}'**
  String backupError(String error);

  /// No description provided for @restoreError.
  ///
  /// In en, this message translates to:
  /// **'Failed to restore backup: {error}'**
  String restoreError(String error);

  /// No description provided for @restoreWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Warning: Restore Data'**
  String get restoreWarningTitle;

  /// No description provided for @restoreWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'Restoring a backup will DELETE ALL current data on this device and replace it with the backup content.\n\nThis action cannot be undone. Are you sure?'**
  String get restoreWarningMessage;

  /// No description provided for @yesRestore.
  ///
  /// In en, this message translates to:
  /// **'Yes, Restore'**
  String get yesRestore;

  /// No description provided for @exportDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportDataTitle;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionType;

  /// No description provided for @allWallets.
  ///
  /// In en, this message translates to:
  /// **'All Wallets'**
  String get allWallets;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @shareCsv.
  ///
  /// In en, this message translates to:
  /// **'Share CSV ({count} items)'**
  String shareCsv(int count);

  /// No description provided for @saveToDownloads.
  ///
  /// In en, this message translates to:
  /// **'Save to Downloads'**
  String get saveToDownloads;

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get calculating;

  /// No description provided for @noTransactionsMatch.
  ///
  /// In en, this message translates to:
  /// **'No transactions match selected filters.'**
  String get noTransactionsMatch;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String saveFailed(String error);

  /// No description provided for @fileSavedTo.
  ///
  /// In en, this message translates to:
  /// **'File saved to: {path}'**
  String fileSavedTo(String path);

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// No description provided for @sendFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedbackTitle;

  /// No description provided for @weValueYourVoice.
  ///
  /// In en, this message translates to:
  /// **'We Value Your Voice'**
  String get weValueYourVoice;

  /// No description provided for @feedbackDescription.
  ///
  /// In en, this message translates to:
  /// **'Have a new feature idea? Found a bug? Or just want to say hi? We are ready to listen! Your feedback means a lot to Ollo\'s development.'**
  String get feedbackDescription;

  /// No description provided for @chatViaWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Chat via WhatsApp'**
  String get chatViaWhatsApp;

  /// No description provided for @repliesInHours.
  ///
  /// In en, this message translates to:
  /// **'Typically replies within a few hours'**
  String get repliesInHours;

  /// No description provided for @subCategoriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sub-categories'**
  String subCategoriesCount(int count);

  /// No description provided for @unnamed.
  ///
  /// In en, this message translates to:
  /// **'Unnamed'**
  String get unnamed;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorPrefix(String error);

  /// No description provided for @whatsappMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello Ollo Team, I want to provide feedback...'**
  String get whatsappMessage;

  /// No description provided for @roadmapTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Roadmap'**
  String get roadmapTitle;

  /// No description provided for @roadmapInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get roadmapInProgress;

  /// No description provided for @roadmapPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get roadmapPlanned;

  /// No description provided for @roadmapCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get roadmapCompleted;

  /// No description provided for @roadmapHighPriority.
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get roadmapHighPriority;

  /// No description provided for @roadmapBeta.
  ///
  /// In en, this message translates to:
  /// **'BETA'**
  String get roadmapBeta;

  /// No description provided for @roadmapDev.
  ///
  /// In en, this message translates to:
  /// **'Dev'**
  String get roadmapDev;

  /// No description provided for @featureCloudBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud Backup (Google Drive)'**
  String get featureCloudBackupTitle;

  /// No description provided for @featureCloudBackupDesc.
  ///
  /// In en, this message translates to:
  /// **'Sync your data securely to your personal Google Drive.'**
  String get featureCloudBackupDesc;

  /// No description provided for @featureAiInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced AI Insights'**
  String get featureAiInsightsTitle;

  /// No description provided for @featureAiInsightsDesc.
  ///
  /// In en, this message translates to:
  /// **'Deeper analysis of your spending habits with personalized tips.'**
  String get featureAiInsightsDesc;

  /// No description provided for @featureDataExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Export to CSV/Excel'**
  String get featureDataExportTitle;

  /// No description provided for @featureDataExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Export transaction history for external analysis in Excel or Sheets.'**
  String get featureDataExportDesc;

  /// No description provided for @featureBudgetForecastingTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget Forecasting'**
  String get featureBudgetForecastingTitle;

  /// No description provided for @featureBudgetForecastingDesc.
  ///
  /// In en, this message translates to:
  /// **'Predict next month\'s expenses based on historical data.'**
  String get featureBudgetForecastingDesc;

  /// No description provided for @featureMultiCurrencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Multi-Currency Support'**
  String get featureMultiCurrencyTitle;

  /// No description provided for @featureMultiCurrencyDesc.
  ///
  /// In en, this message translates to:
  /// **'Real-time conversion for international transactions.'**
  String get featureMultiCurrencyDesc;

  /// No description provided for @featureReceiptScanningTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipt Scanning OCR'**
  String get featureReceiptScanningTitle;

  /// No description provided for @featureReceiptScanningDesc.
  ///
  /// In en, this message translates to:
  /// **'Scan receipts to automatically input transaction details.'**
  String get featureReceiptScanningDesc;

  /// No description provided for @featureLocalBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Full Local Backup'**
  String get featureLocalBackupTitle;

  /// No description provided for @featureLocalBackupDesc.
  ///
  /// In en, this message translates to:
  /// **'Backup all app data (transactions, wallets, notes, etc.) to a local file.'**
  String get featureLocalBackupDesc;

  /// No description provided for @featureSmartNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Notes'**
  String get featureSmartNotesTitle;

  /// No description provided for @featureSmartNotesDesc.
  ///
  /// In en, this message translates to:
  /// **'Shopping lists with checklists and total calculation.'**
  String get featureSmartNotesDesc;

  /// No description provided for @featureRecurringTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring Transactions'**
  String get featureRecurringTitle;

  /// No description provided for @featureRecurringDesc.
  ///
  /// In en, this message translates to:
  /// **'Automate bills and salary inputs.'**
  String get featureRecurringDesc;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Ollo'**
  String get aboutTitle;

  /// No description provided for @aboutPhilosophyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Financial Companion'**
  String get aboutPhilosophyTitle;

  /// No description provided for @aboutPhilosophyDesc.
  ///
  /// In en, this message translates to:
  /// **'Ollo is born from the belief that managing finances shouldn\'t be complicated. We want to create a smart, friendly financial companion that helps you achieve your financial dreams, one step at a time.'**
  String get aboutPhilosophyDesc;

  /// No description provided for @connectWithUs.
  ///
  /// In en, this message translates to:
  /// **'Connect with us'**
  String get connectWithUs;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpTitle;

  /// No description provided for @helpIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get helpIntroTitle;

  /// No description provided for @helpIntroDesc.
  ///
  /// In en, this message translates to:
  /// **'Find answers to common questions or contact our support team directly.'**
  String get helpIntroDesc;

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faqTitle;

  /// No description provided for @faqAddWalletQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I add a new wallet?'**
  String get faqAddWalletQuestion;

  /// No description provided for @faqAddWalletAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to the \"Wallets\" menu and tap the \"+\" button in the top right corner. Select the wallet type (Cash, Bank, etc.), enter the name and initial balance, then save.'**
  String get faqAddWalletAnswer;

  /// No description provided for @faqExportDataQuestion.
  ///
  /// In en, this message translates to:
  /// **'Can I export my data?'**
  String get faqExportDataQuestion;

  /// No description provided for @faqExportDataAnswer.
  ///
  /// In en, this message translates to:
  /// **'Data export is a Premium feature coming soon. It will allow you to export your transactions to CSV or Excel formats.'**
  String get faqExportDataAnswer;

  /// No description provided for @faqResetDataQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I reset my data?'**
  String get faqResetDataQuestion;

  /// No description provided for @faqResetDataAnswer.
  ///
  /// In en, this message translates to:
  /// **'Currently, you can delete individual transactions or wallets. A full factory reset option will be available in the Settings menu in a future update.'**
  String get faqResetDataAnswer;

  /// No description provided for @faqSecureDataQuestion.
  ///
  /// In en, this message translates to:
  /// **'Is my data secure?'**
  String get faqSecureDataQuestion;

  /// No description provided for @faqSecureDataAnswer.
  ///
  /// In en, this message translates to:
  /// **'Yes, all your data is stored locally on your device. We do not upload your personal financial data to any external servers.'**
  String get faqSecureDataAnswer;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @reimbursementTitle.
  ///
  /// In en, this message translates to:
  /// **'Reimbursement'**
  String get reimbursementTitle;

  /// No description provided for @reimbursementPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get reimbursementPending;

  /// No description provided for @reimbursementCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get reimbursementCompleted;

  /// No description provided for @noPendingReimbursements.
  ///
  /// In en, this message translates to:
  /// **'No pending reimbursements'**
  String get noPendingReimbursements;

  /// No description provided for @noCompletedReimbursements.
  ///
  /// In en, this message translates to:
  /// **'No completed reimbursements'**
  String get noCompletedReimbursements;

  /// No description provided for @markPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark Paid'**
  String get markPaid;

  /// No description provided for @totalSavings.
  ///
  /// In en, this message translates to:
  /// **'Total Savings'**
  String get totalSavings;

  /// No description provided for @financialBuckets.
  ///
  /// In en, this message translates to:
  /// **'Financial Buckets'**
  String get financialBuckets;

  /// No description provided for @noSavingsYet.
  ///
  /// In en, this message translates to:
  /// **'No savings yet'**
  String get noSavingsYet;

  /// No description provided for @growthThisMonth.
  ///
  /// In en, this message translates to:
  /// **'{percent}% this month'**
  String growthThisMonth(String percent);

  /// No description provided for @myCards.
  ///
  /// In en, this message translates to:
  /// **'My Cards'**
  String get myCards;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Selected'**
  String selectedCount(int count);

  /// No description provided for @copyNumber.
  ///
  /// In en, this message translates to:
  /// **'Copy Number'**
  String get copyNumber;

  /// No description provided for @copyTemplate.
  ///
  /// In en, this message translates to:
  /// **'Copy Template'**
  String get copyTemplate;

  /// No description provided for @cardsCopied.
  ///
  /// In en, this message translates to:
  /// **'{count} cards copied!'**
  String cardsCopied(int count);

  /// No description provided for @cardNumberCopied.
  ///
  /// In en, this message translates to:
  /// **'Card number copied!'**
  String get cardNumberCopied;

  /// No description provided for @cardTemplateCopied.
  ///
  /// In en, this message translates to:
  /// **'Card template copied!'**
  String get cardTemplateCopied;

  /// No description provided for @noCardsYet.
  ///
  /// In en, this message translates to:
  /// **'No cards yet'**
  String get noCardsYet;

  /// No description provided for @addCardsMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your bank accounts or e-wallets'**
  String get addCardsMessage;

  /// No description provided for @premiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Full Potential'**
  String get premiumTitle;

  /// No description provided for @premiumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium for advanced features and unlimited access.'**
  String get premiumSubtitle;

  /// No description provided for @premiumAdvancedStats.
  ///
  /// In en, this message translates to:
  /// **'Advanced Statistics'**
  String get premiumAdvancedStats;

  /// No description provided for @premiumAdvancedStatsDesc.
  ///
  /// In en, this message translates to:
  /// **'Interactive charts & deep insights'**
  String get premiumAdvancedStatsDesc;

  /// No description provided for @premiumDataExport.
  ///
  /// In en, this message translates to:
  /// **'Data Export'**
  String get premiumDataExport;

  /// No description provided for @premiumDataExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Export to CSV/Excel for backup'**
  String get premiumDataExportDesc;

  /// No description provided for @premiumUnlimitedWallets.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Wallets'**
  String get premiumUnlimitedWallets;

  /// No description provided for @premiumUnlimitedWalletsDesc.
  ///
  /// In en, this message translates to:
  /// **'Create as many wallets as you need'**
  String get premiumUnlimitedWalletsDesc;

  /// No description provided for @premiumSmartAlerts.
  ///
  /// In en, this message translates to:
  /// **'Smart Alerts'**
  String get premiumSmartAlerts;

  /// No description provided for @premiumSmartAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified before you overspend'**
  String get premiumSmartAlertsDesc;

  /// No description provided for @upgradeButton.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now - Rp 29.000 / Lifetime'**
  String get upgradeButton;

  /// No description provided for @restorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchase'**
  String get restorePurchase;

  /// No description provided for @youArePremium.
  ///
  /// In en, this message translates to:
  /// **'You are Premium!'**
  String get youArePremium;

  /// No description provided for @premiumWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Premium! 🌟'**
  String get premiumWelcome;

  /// No description provided for @contactSupportMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello Ollo Support Team, I need help regarding...'**
  String get contactSupportMessage;

  /// No description provided for @category_food.
  ///
  /// In en, this message translates to:
  /// **'Food & Drink'**
  String get category_food;

  /// No description provided for @category_transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get category_transport;

  /// No description provided for @category_shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get category_shopping;

  /// No description provided for @category_housing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get category_housing;

  /// No description provided for @category_entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get category_entertainment;

  /// No description provided for @category_health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get category_health;

  /// No description provided for @category_education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get category_education;

  /// No description provided for @category_personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get category_personal;

  /// No description provided for @category_financial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get category_financial;

  /// No description provided for @category_family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get category_family;

  /// No description provided for @category_salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get category_salary;

  /// No description provided for @category_business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get category_business;

  /// No description provided for @category_investments.
  ///
  /// In en, this message translates to:
  /// **'Investments'**
  String get category_investments;

  /// No description provided for @category_gifts_income.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get category_gifts_income;

  /// No description provided for @category_other_income.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get category_other_income;

  /// No description provided for @subcategory_breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get subcategory_breakfast;

  /// No description provided for @subcategory_lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get subcategory_lunch;

  /// No description provided for @subcategory_dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get subcategory_dinner;

  /// No description provided for @subcategory_eateries.
  ///
  /// In en, this message translates to:
  /// **'Eateries'**
  String get subcategory_eateries;

  /// No description provided for @subcategory_snacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get subcategory_snacks;

  /// No description provided for @subcategory_drinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get subcategory_drinks;

  /// No description provided for @subcategory_groceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get subcategory_groceries;

  /// No description provided for @subcategory_delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get subcategory_delivery;

  /// No description provided for @subcategory_alcohol.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get subcategory_alcohol;

  /// No description provided for @subcategory_bus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get subcategory_bus;

  /// No description provided for @subcategory_train.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get subcategory_train;

  /// No description provided for @subcategory_taxi.
  ///
  /// In en, this message translates to:
  /// **'Taxi'**
  String get subcategory_taxi;

  /// No description provided for @subcategory_fuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get subcategory_fuel;

  /// No description provided for @subcategory_parking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get subcategory_parking;

  /// No description provided for @subcategory_maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get subcategory_maintenance;

  /// No description provided for @subcategory_insurance_car.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get subcategory_insurance_car;

  /// No description provided for @subcategory_toll.
  ///
  /// In en, this message translates to:
  /// **'Toll'**
  String get subcategory_toll;

  /// No description provided for @subcategory_clothes.
  ///
  /// In en, this message translates to:
  /// **'Clothes'**
  String get subcategory_clothes;

  /// No description provided for @subcategory_electronics.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get subcategory_electronics;

  /// No description provided for @subcategory_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get subcategory_home;

  /// No description provided for @subcategory_beauty.
  ///
  /// In en, this message translates to:
  /// **'Beauty'**
  String get subcategory_beauty;

  /// No description provided for @subcategory_gifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get subcategory_gifts;

  /// No description provided for @subcategory_software.
  ///
  /// In en, this message translates to:
  /// **'Software'**
  String get subcategory_software;

  /// No description provided for @subcategory_tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get subcategory_tools;

  /// No description provided for @subcategory_rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get subcategory_rent;

  /// No description provided for @subcategory_mortgage.
  ///
  /// In en, this message translates to:
  /// **'Mortgage'**
  String get subcategory_mortgage;

  /// No description provided for @subcategory_utilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get subcategory_utilities;

  /// No description provided for @subcategory_internet.
  ///
  /// In en, this message translates to:
  /// **'Internet'**
  String get subcategory_internet;

  /// No description provided for @subcategory_maintenance_home.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get subcategory_maintenance_home;

  /// No description provided for @subcategory_furniture.
  ///
  /// In en, this message translates to:
  /// **'Furniture'**
  String get subcategory_furniture;

  /// No description provided for @subcategory_services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get subcategory_services;

  /// No description provided for @subcategory_movies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get subcategory_movies;

  /// No description provided for @subcategory_games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get subcategory_games;

  /// No description provided for @subcategory_streaming.
  ///
  /// In en, this message translates to:
  /// **'Streaming'**
  String get subcategory_streaming;

  /// No description provided for @subcategory_events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get subcategory_events;

  /// No description provided for @subcategory_hobbies.
  ///
  /// In en, this message translates to:
  /// **'Hobbies'**
  String get subcategory_hobbies;

  /// No description provided for @subcategory_travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get subcategory_travel;

  /// No description provided for @monthlyCommitment.
  ///
  /// In en, this message translates to:
  /// **'Monthly Commitment'**
  String get monthlyCommitment;

  /// No description provided for @upcomingBill.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Bill'**
  String get upcomingBill;

  /// No description provided for @noUpcomingBills.
  ///
  /// In en, this message translates to:
  /// **'No upcoming bills'**
  String get noUpcomingBills;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @inDays.
  ///
  /// In en, this message translates to:
  /// **'In {days} days'**
  String inDays(int days);

  /// No description provided for @needTwoWallets.
  ///
  /// In en, this message translates to:
  /// **'Need 2+ wallets'**
  String get needTwoWallets;

  /// No description provided for @nettBalance.
  ///
  /// In en, this message translates to:
  /// **'Nett Balance'**
  String get nettBalance;

  /// No description provided for @activeDebt.
  ///
  /// In en, this message translates to:
  /// **'Active Debt'**
  String get activeDebt;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'last 30 days'**
  String get last30Days;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @premiumMember.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get premiumMember;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @unlimitedAccess.
  ///
  /// In en, this message translates to:
  /// **'You have unlimited access!'**
  String get unlimitedAccess;

  /// No description provided for @unlockFeatures.
  ///
  /// In en, this message translates to:
  /// **'Unlock all features & remove limits.'**
  String get unlockFeatures;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @subcategory_music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get subcategory_music;

  /// No description provided for @subcategory_doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get subcategory_doctor;

  /// No description provided for @subcategory_pharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get subcategory_pharmacy;

  /// No description provided for @subcategory_gym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get subcategory_gym;

  /// No description provided for @subcategory_insurance_health.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get subcategory_insurance_health;

  /// No description provided for @subcategory_mental_health.
  ///
  /// In en, this message translates to:
  /// **'Mental Health'**
  String get subcategory_mental_health;

  /// No description provided for @subcategory_sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get subcategory_sports;

  /// No description provided for @subcategory_tuition.
  ///
  /// In en, this message translates to:
  /// **'Tuition'**
  String get subcategory_tuition;

  /// No description provided for @subcategory_books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get subcategory_books;

  /// No description provided for @subcategory_courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get subcategory_courses;

  /// No description provided for @subcategory_supplies.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get subcategory_supplies;

  /// No description provided for @subcategory_haircut.
  ///
  /// In en, this message translates to:
  /// **'Haircut'**
  String get subcategory_haircut;

  /// No description provided for @subcategory_spa.
  ///
  /// In en, this message translates to:
  /// **'Spa'**
  String get subcategory_spa;

  /// No description provided for @subcategory_cosmetics.
  ///
  /// In en, this message translates to:
  /// **'Cosmetics'**
  String get subcategory_cosmetics;

  /// No description provided for @subcategory_taxes.
  ///
  /// In en, this message translates to:
  /// **'Taxes'**
  String get subcategory_taxes;

  /// No description provided for @subcategory_fees.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get subcategory_fees;

  /// No description provided for @subcategory_fines.
  ///
  /// In en, this message translates to:
  /// **'Fines'**
  String get subcategory_fines;

  /// No description provided for @subcategory_insurance_life.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get subcategory_insurance_life;

  /// No description provided for @subcategory_childcare.
  ///
  /// In en, this message translates to:
  /// **'Childcare'**
  String get subcategory_childcare;

  /// No description provided for @subcategory_toys.
  ///
  /// In en, this message translates to:
  /// **'Toys'**
  String get subcategory_toys;

  /// No description provided for @subcategory_school_kids.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get subcategory_school_kids;

  /// No description provided for @subcategory_pets.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get subcategory_pets;

  /// No description provided for @subcategory_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get subcategory_monthly;

  /// No description provided for @subcategory_weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get subcategory_weekly;

  /// No description provided for @subcategory_bonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get subcategory_bonus;

  /// No description provided for @subcategory_overtime.
  ///
  /// In en, this message translates to:
  /// **'Overtime'**
  String get subcategory_overtime;

  /// No description provided for @subcategory_sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get subcategory_sales;

  /// No description provided for @subcategory_profit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get subcategory_profit;

  /// No description provided for @subcategory_dividends.
  ///
  /// In en, this message translates to:
  /// **'Dividends'**
  String get subcategory_dividends;

  /// No description provided for @subcategory_interest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get subcategory_interest;

  /// No description provided for @subcategory_crypto.
  ///
  /// In en, this message translates to:
  /// **'Crypto'**
  String get subcategory_crypto;

  /// No description provided for @subcategory_stocks.
  ///
  /// In en, this message translates to:
  /// **'Stocks'**
  String get subcategory_stocks;

  /// No description provided for @subcategory_real_estate.
  ///
  /// In en, this message translates to:
  /// **'Real Estate'**
  String get subcategory_real_estate;

  /// No description provided for @subcategory_birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get subcategory_birthday;

  /// No description provided for @subcategory_holiday.
  ///
  /// In en, this message translates to:
  /// **'Holiday'**
  String get subcategory_holiday;

  /// No description provided for @subcategory_allowance.
  ///
  /// In en, this message translates to:
  /// **'Allowance'**
  String get subcategory_allowance;

  /// No description provided for @subcategory_refunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get subcategory_refunds;

  /// No description provided for @subcategory_grants.
  ///
  /// In en, this message translates to:
  /// **'Grants'**
  String get subcategory_grants;

  /// No description provided for @subcategory_lottery.
  ///
  /// In en, this message translates to:
  /// **'Lottery'**
  String get subcategory_lottery;

  /// No description provided for @subcategory_selling.
  ///
  /// In en, this message translates to:
  /// **'Selling'**
  String get subcategory_selling;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get emailLabel;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @listeningMessage.
  ///
  /// In en, this message translates to:
  /// **'Ollo AI is Listening...'**
  String get listeningMessage;

  /// No description provided for @quickRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Record'**
  String get quickRecordTitle;

  /// No description provided for @saySomethingHint.
  ///
  /// In en, this message translates to:
  /// **'Say \'Lunch 50k\'...'**
  String get saySomethingHint;

  /// No description provided for @stopAndProcess.
  ///
  /// In en, this message translates to:
  /// **'Stop & Process'**
  String get stopAndProcess;

  /// No description provided for @textInputHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. \"Lunch 50k\", \"Salary 10m\"'**
  String get textInputHint;

  /// No description provided for @draftReady.
  ///
  /// In en, this message translates to:
  /// **'Draft Ready'**
  String get draftReady;

  /// No description provided for @saveAdjust.
  ///
  /// In en, this message translates to:
  /// **'Save / Adjust'**
  String get saveAdjust;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get notFound;

  /// No description provided for @selectWallet.
  ///
  /// In en, this message translates to:
  /// **'Select Wallet'**
  String get selectWallet;

  /// No description provided for @exitAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get exitAppTitle;

  /// No description provided for @exitAppConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the app?'**
  String get exitAppConfirm;

  /// No description provided for @onboardingSavingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get onboardingSavingsTitle;

  /// No description provided for @onboardingSavingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Grow Your Wealth'**
  String get onboardingSavingsSubtitle;

  /// No description provided for @onboardingSavingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Start saving more effectively by tracking where your money goes and cutting unnecessary expenses.'**
  String get onboardingSavingsDesc;

  /// No description provided for @onboardingStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get onboardingStatsTitle;

  /// No description provided for @onboardingStatsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gain Deep Insights'**
  String get onboardingStatsSubtitle;

  /// No description provided for @onboardingStatsDesc.
  ///
  /// In en, this message translates to:
  /// **'Analyze your income and expense trends with detailed reports to make smarter financial decisions.'**
  String get onboardingStatsDesc;

  /// No description provided for @onboardingMgmtTitle.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get onboardingMgmtTitle;

  /// No description provided for @onboardingMgmtSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Total Control'**
  String get onboardingMgmtSubtitle;

  /// No description provided for @onboardingMgmtDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage all your wallets, accounts, and budgets in one simple and intuitive place.'**
  String get onboardingMgmtDesc;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language for the application interface.'**
  String get onboardingLanguageDesc;

  /// No description provided for @onboardingVoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice Command'**
  String get onboardingVoiceTitle;

  /// No description provided for @onboardingVoiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Select the language you will use for voice commands and quick recording.'**
  String get onboardingVoiceDesc;

  /// No description provided for @onboardingNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Notifications'**
  String get onboardingNotifTitle;

  /// No description provided for @onboardingNotifDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable daily reminders to keep your tracking on streak.'**
  String get onboardingNotifDesc;

  /// No description provided for @onboardingProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Profile'**
  String get onboardingProfileTitle;

  /// No description provided for @onboardingProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'Tell us a bit about yourself. This information will be displayed in your profile.'**
  String get onboardingProfileDesc;

  /// No description provided for @onboardingWalletTitle.
  ///
  /// In en, this message translates to:
  /// **'First Wallet'**
  String get onboardingWalletTitle;

  /// No description provided for @onboardingWalletDesc.
  ///
  /// In en, this message translates to:
  /// **'Let\'s setup your main cash wallet. Enter your current cash on hand.'**
  String get onboardingWalletDesc;

  /// No description provided for @onboardingDailyReminders.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminders'**
  String get onboardingDailyReminders;

  /// No description provided for @onboardingRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get valid reminders to record your expenses.'**
  String get onboardingRemindersSubtitle;

  /// No description provided for @onboardingFullname.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get onboardingFullname;

  /// No description provided for @onboardingNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. John Doe'**
  String get onboardingNameHint;

  /// No description provided for @onboardingEmail.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get onboardingEmail;

  /// No description provided for @onboardingEmailHint.
  ///
  /// In en, this message translates to:
  /// **'user@example.com'**
  String get onboardingEmailHint;

  /// No description provided for @onboardingBalanceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 500000'**
  String get onboardingBalanceHint;

  /// No description provided for @onboardingWalletGuide.
  ///
  /// In en, this message translates to:
  /// **'You can add more wallets (Bank, E-Wallet) later in the Wallet menu.'**
  String get onboardingWalletGuide;

  /// No description provided for @badgeFirstStepTitle.
  ///
  /// In en, this message translates to:
  /// **'First Step'**
  String get badgeFirstStepTitle;

  /// No description provided for @badgeFirstStepDesc.
  ///
  /// In en, this message translates to:
  /// **'Record your first transaction'**
  String get badgeFirstStepDesc;

  /// No description provided for @badgeWeekWarriorTitle.
  ///
  /// In en, this message translates to:
  /// **'7 Day Streak'**
  String get badgeWeekWarriorTitle;

  /// No description provided for @badgeWeekWarriorDesc.
  ///
  /// In en, this message translates to:
  /// **'Track expenses for 7 days in a row'**
  String get badgeWeekWarriorDesc;

  /// No description provided for @badgeConsistentSaverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discipline'**
  String get badgeConsistentSaverTitle;

  /// No description provided for @badgeConsistentSaverDesc.
  ///
  /// In en, this message translates to:
  /// **'Track for 30 total days'**
  String get badgeConsistentSaverDesc;

  /// No description provided for @badgeBigSpenderTitle.
  ///
  /// In en, this message translates to:
  /// **'Big Spender'**
  String get badgeBigSpenderTitle;

  /// No description provided for @badgeBigSpenderDesc.
  ///
  /// In en, this message translates to:
  /// **'Record 100+ transactions'**
  String get badgeBigSpenderDesc;

  /// No description provided for @badgeSaverTitle.
  ///
  /// In en, this message translates to:
  /// **'Saver'**
  String get badgeSaverTitle;

  /// No description provided for @badgeSaverDesc.
  ///
  /// In en, this message translates to:
  /// **'Have more Income than Expense'**
  String get badgeSaverDesc;

  /// No description provided for @badgeNightOwlTitle.
  ///
  /// In en, this message translates to:
  /// **'Night Owl'**
  String get badgeNightOwlTitle;

  /// No description provided for @badgeNightOwlDesc.
  ///
  /// In en, this message translates to:
  /// **'Record a transaction after 10 PM'**
  String get badgeNightOwlDesc;

  /// No description provided for @badgeEarlyBirdTitle.
  ///
  /// In en, this message translates to:
  /// **'Early Bird'**
  String get badgeEarlyBirdTitle;

  /// No description provided for @badgeEarlyBirdDesc.
  ///
  /// In en, this message translates to:
  /// **'Record a transaction between 5 AM - 8 AM'**
  String get badgeEarlyBirdDesc;

  /// No description provided for @badgeWeekendWarriorTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekend'**
  String get badgeWeekendWarriorTitle;

  /// No description provided for @badgeWeekendWarriorDesc.
  ///
  /// In en, this message translates to:
  /// **'Record a transaction on Saturday or Sunday'**
  String get badgeWeekendWarriorDesc;

  /// No description provided for @badgeWealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Wealth'**
  String get badgeWealthTitle;

  /// No description provided for @badgeWealthDesc.
  ///
  /// In en, this message translates to:
  /// **'Accumulate over 10,000,000 in volume'**
  String get badgeWealthDesc;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @totalActive.
  ///
  /// In en, this message translates to:
  /// **'Total Active'**
  String get totalActive;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @levelNovice.
  ///
  /// In en, this message translates to:
  /// **'Novice Saver'**
  String get levelNovice;

  /// No description provided for @levelConsistent.
  ///
  /// In en, this message translates to:
  /// **'Consistent Saver'**
  String get levelConsistent;

  /// No description provided for @levelEnthusiast.
  ///
  /// In en, this message translates to:
  /// **'Finance Enthusiast'**
  String get levelEnthusiast;

  /// No description provided for @badgeFirstLogTitle.
  ///
  /// In en, this message translates to:
  /// **'First Log'**
  String get badgeFirstLogTitle;

  /// No description provided for @badgeFirstLogDesc.
  ///
  /// In en, this message translates to:
  /// **'Record your very first transaction'**
  String get badgeFirstLogDesc;

  /// No description provided for @badgeStreak3Title.
  ///
  /// In en, this message translates to:
  /// **'Heating Up'**
  String get badgeStreak3Title;

  /// No description provided for @badgeStreak3Desc.
  ///
  /// In en, this message translates to:
  /// **'3 Day Daily Streak'**
  String get badgeStreak3Desc;

  /// No description provided for @badgeStreak7Title.
  ///
  /// In en, this message translates to:
  /// **'On Fire'**
  String get badgeStreak7Title;

  /// No description provided for @badgeStreak7Desc.
  ///
  /// In en, this message translates to:
  /// **'7 Day Daily Streak'**
  String get badgeStreak7Desc;

  /// No description provided for @badgeStreak14Title.
  ///
  /// In en, this message translates to:
  /// **'Unstoppable'**
  String get badgeStreak14Title;

  /// No description provided for @badgeStreak14Desc.
  ///
  /// In en, this message translates to:
  /// **'14 Day Daily Streak'**
  String get badgeStreak14Desc;

  /// No description provided for @badgeStreak30Title.
  ///
  /// In en, this message translates to:
  /// **'Discipline Master'**
  String get badgeStreak30Title;

  /// No description provided for @badgeStreak30Desc.
  ///
  /// In en, this message translates to:
  /// **'30 Day Daily Streak'**
  String get badgeStreak30Desc;

  /// No description provided for @badgeStreak100Title.
  ///
  /// In en, this message translates to:
  /// **'Legendary'**
  String get badgeStreak100Title;

  /// No description provided for @badgeStreak100Desc.
  ///
  /// In en, this message translates to:
  /// **'100 Day Daily Streak'**
  String get badgeStreak100Desc;

  /// No description provided for @badgeWeeklyLoggerTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Logger'**
  String get badgeWeeklyLoggerTitle;

  /// No description provided for @badgeWeeklyLoggerDesc.
  ///
  /// In en, this message translates to:
  /// **'Input at least one transaction every week for a month'**
  String get badgeWeeklyLoggerDesc;

  /// No description provided for @badgeFirstBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'First Budget'**
  String get badgeFirstBudgetTitle;

  /// No description provided for @badgeFirstBudgetDesc.
  ///
  /// In en, this message translates to:
  /// **'Create your first budget'**
  String get badgeFirstBudgetDesc;

  /// No description provided for @badgeUnderBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget Pro'**
  String get badgeUnderBudgetTitle;

  /// No description provided for @badgeUnderBudgetDesc.
  ///
  /// In en, this message translates to:
  /// **'Spend less than your budget for the month'**
  String get badgeUnderBudgetDesc;

  /// No description provided for @badgeBudgetMasterTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget Master'**
  String get badgeBudgetMasterTitle;

  /// No description provided for @badgeBudgetMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Stay under budget for 3 consecutive months'**
  String get badgeBudgetMasterDesc;

  /// No description provided for @badgeMultiBudgeterTitle.
  ///
  /// In en, this message translates to:
  /// **'Strategist'**
  String get badgeMultiBudgeterTitle;

  /// No description provided for @badgeMultiBudgeterDesc.
  ///
  /// In en, this message translates to:
  /// **'Create budgets for more than 3 categories'**
  String get badgeMultiBudgeterDesc;

  /// No description provided for @badgeFirstGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Dreamer'**
  String get badgeFirstGoalTitle;

  /// No description provided for @badgeFirstGoalDesc.
  ///
  /// In en, this message translates to:
  /// **'Create your first saving goal'**
  String get badgeFirstGoalDesc;

  /// No description provided for @badgeGoalCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Achiever'**
  String get badgeGoalCompletedTitle;

  /// No description provided for @badgeGoalCompletedDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete a saving goal (100%)'**
  String get badgeGoalCompletedDesc;

  /// No description provided for @badgeGoalSprintTitle.
  ///
  /// In en, this message translates to:
  /// **'Sprinter'**
  String get badgeGoalSprintTitle;

  /// No description provided for @badgeGoalSprintDesc.
  ///
  /// In en, this message translates to:
  /// **'Reach a saving goal before the deadline'**
  String get badgeGoalSprintDesc;

  /// No description provided for @badgeMidnightCheckoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Midnight Checkout'**
  String get badgeMidnightCheckoutTitle;

  /// No description provided for @badgeMidnightCheckoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Shopping after midnight (Anti-Badge)'**
  String get badgeMidnightCheckoutDesc;

  /// No description provided for @badgeImpulseKingTitle.
  ///
  /// In en, this message translates to:
  /// **'Impulse King'**
  String get badgeImpulseKingTitle;

  /// No description provided for @badgeImpulseKingDesc.
  ///
  /// In en, this message translates to:
  /// **'Making 5+ transactions in one day (Anti-Badge)'**
  String get badgeImpulseKingDesc;

  /// No description provided for @badgeExplorerTitle.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get badgeExplorerTitle;

  /// No description provided for @badgeExplorerDesc.
  ///
  /// In en, this message translates to:
  /// **'Record transactions in 5 different categories'**
  String get badgeExplorerDesc;

  /// No description provided for @badgeLunchTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Lunch Break'**
  String get badgeLunchTimeTitle;

  /// No description provided for @badgeLunchTimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Record a transaction between 11 AM - 1 PM'**
  String get badgeLunchTimeDesc;

  /// No description provided for @badgeBigSaverTitle.
  ///
  /// In en, this message translates to:
  /// **'Big Saver'**
  String get badgeBigSaverTitle;

  /// No description provided for @badgeBigSaverDesc.
  ///
  /// In en, this message translates to:
  /// **'Accumulate 5,000,000 in total Income'**
  String get badgeBigSaverDesc;

  /// No description provided for @badgeGiverTitle.
  ///
  /// In en, this message translates to:
  /// **'Generous'**
  String get badgeGiverTitle;

  /// No description provided for @badgeGiverDesc.
  ///
  /// In en, this message translates to:
  /// **'Make 5+ Transfer transactions'**
  String get badgeGiverDesc;

  /// No description provided for @badgeThriftyTitle.
  ///
  /// In en, this message translates to:
  /// **'Thrifty'**
  String get badgeThriftyTitle;

  /// No description provided for @badgeThriftyDesc.
  ///
  /// In en, this message translates to:
  /// **'Monthly Expense is less than 50% of Income'**
  String get badgeThriftyDesc;

  /// No description provided for @badgeWeekendBingeTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekend Binge'**
  String get badgeWeekendBingeTitle;

  /// No description provided for @badgeWeekendBingeDesc.
  ///
  /// In en, this message translates to:
  /// **'Make 5+ transactions on a weekend'**
  String get badgeWeekendBingeDesc;

  /// No description provided for @levelRookie.
  ///
  /// In en, this message translates to:
  /// **'Rookie Saver'**
  String get levelRookie;

  /// No description provided for @levelBudgetWarrior.
  ///
  /// In en, this message translates to:
  /// **'Budget Warrior'**
  String get levelBudgetWarrior;

  /// No description provided for @levelMoneyNinja.
  ///
  /// In en, this message translates to:
  /// **'Money Ninja'**
  String get levelMoneyNinja;

  /// No description provided for @levelFinanceSensei.
  ///
  /// In en, this message translates to:
  /// **'Financial Sensei'**
  String get levelFinanceSensei;

  /// No description provided for @levelWealthTycoon.
  ///
  /// In en, this message translates to:
  /// **'Wealth Tycoon'**
  String get levelWealthTycoon;

  /// No description provided for @badgeSectionConsistency.
  ///
  /// In en, this message translates to:
  /// **'Consistency & Streak'**
  String get badgeSectionConsistency;

  /// No description provided for @badgeSectionBudget.
  ///
  /// In en, this message translates to:
  /// **'Budgeting'**
  String get badgeSectionBudget;

  /// No description provided for @badgeSectionSaving.
  ///
  /// In en, this message translates to:
  /// **'Savings Goals'**
  String get badgeSectionSaving;

  /// No description provided for @badgeSectionMisc.
  ///
  /// In en, this message translates to:
  /// **'Fun & Misc'**
  String get badgeSectionMisc;

  /// No description provided for @gamificationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Gamification Settings'**
  String get gamificationSettingsTitle;

  /// No description provided for @settingsShowDashboardLevel.
  ///
  /// In en, this message translates to:
  /// **'Show Level on Dashboard'**
  String get settingsShowDashboardLevel;

  /// No description provided for @settingsShowDashboardLevelDesc.
  ///
  /// In en, this message translates to:
  /// **'Display your level progress on the home screen'**
  String get settingsShowDashboardLevelDesc;

  /// No description provided for @settingsSpoilerMode.
  ///
  /// In en, this message translates to:
  /// **'Spoiler Mode'**
  String get settingsSpoilerMode;

  /// No description provided for @settingsSpoilerModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Hide details of locked badges'**
  String get settingsSpoilerModeDesc;

  /// No description provided for @settingsAchievementNotifications.
  ///
  /// In en, this message translates to:
  /// **'Achievement Notifications'**
  String get settingsAchievementNotifications;

  /// No description provided for @settingsAchievementNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Show popup when a new badge is unlocked'**
  String get settingsAchievementNotificationsDesc;

  /// No description provided for @notificationNewBadgeUnlocked.
  ///
  /// In en, this message translates to:
  /// **'New Badge Unlocked!'**
  String get notificationNewBadgeUnlocked;

  /// No description provided for @notificationCongratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get notificationCongratulations;

  /// No description provided for @notificationYouEarnedXP.
  ///
  /// In en, this message translates to:
  /// **'You earned {amount} XP'**
  String notificationYouEarnedXP(int amount);

  /// No description provided for @notificationAwesome.
  ///
  /// In en, this message translates to:
  /// **'Awesome'**
  String get notificationAwesome;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'es',
    'hi',
    'id',
    'ja',
    'ko',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
