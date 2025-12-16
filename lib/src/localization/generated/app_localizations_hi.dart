// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get customizeMenu => 'Customize Menu';

  @override
  String get menuOrder => 'Menu Order';

  @override
  String get resetMenu => 'Reset Menu';

  @override
  String get home => 'होम';

  @override
  String get wallet => 'वॉलेट';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get statistics => 'आंकड़े';

  @override
  String get expense => 'खर्च';

  @override
  String get income => 'आय';

  @override
  String get transfer => 'ट्रांसफर';

  @override
  String get amount => 'राशि';

  @override
  String get to => 'को';

  @override
  String get addNoteHint => 'नोट जोड़ें...';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get done => 'हो गया';

  @override
  String get errorInvalidAmount => 'कृपया मान्य राशि दर्ज करें';

  @override
  String get errorSelectWallet => 'कृपया वॉलेट चुनें';

  @override
  String get errorSelectDestinationWallet => 'कृपया गंतव्य वॉलेट चुनें';

  @override
  String get errorSameWallets => 'स्रोत और गंतव्य वॉलेट अलग होने चाहिए';

  @override
  String get errorSelectCategory => 'कृपया श्रेणी चुनें';

  @override
  String get transactionDetail => 'लेनदेन विवरण';

  @override
  String get title => 'शीर्षक';

  @override
  String get category => 'श्रेणी';

  @override
  String get dateTime => 'दिनांक समय';

  @override
  String get date => 'दिनांक';

  @override
  String get time => 'समय';

  @override
  String get note => 'नोट';

  @override
  String get deleteTransaction => 'लेनदेन हटाएं';

  @override
  String get deleteTransactionConfirm =>
      'क्या आप वाकई इस लेनदेन को हटाना चाहते हैं? वॉलेट शेष बहाल कर दिया जाएगा।';

  @override
  String get delete => 'हटाएं';

  @override
  String get edit => 'संपादित करें';

  @override
  String get markCompleted => 'पूर्ण के रूप में चिह्नित करें';

  @override
  String get markCompletedConfirm =>
      'क्या इस प्रतिपूर्ति को भुगतान/पूर्ण के रूप में चिह्नित करें?';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get system => 'सिस्टम';

  @override
  String get recentTransactions => 'हालिया लेनदेन';

  @override
  String get noTransactions => 'अभी तक कोई लेनदेन नहीं';

  @override
  String get startRecording =>
      'अपने खर्चों और आय को रिकॉर्ड करना शुरू करें! 🚀';

  @override
  String get menu => 'मेनू';

  @override
  String get budget => 'बजट';

  @override
  String get recurring => 'आवर्ती';

  @override
  String get savings => 'बचत';

  @override
  String get total => 'कुल';

  @override
  String get bills => 'बिल';

  @override
  String get debts => 'उधारी';

  @override
  String get wishlist => 'विशलिस्ट';

  @override
  String get cards => 'कार्ड';

  @override
  String get notes => 'नोट्स';

  @override
  String get reimburse => 'प्रतिपूर्ति';

  @override
  String get unknown => 'अज्ञात';

  @override
  String welcome(String name) {
    return 'नमस्ते, $name!';
  }

  @override
  String get welcomeSimple => 'नमस्ते!';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get developerOptions => 'डेवलपर विकल्प';

  @override
  String get futureFeatures => 'भविष्य की विशेषताएं';

  @override
  String get backupRecovery => 'बैकअप और रिकवरी';

  @override
  String get aiAutomation => 'एआई ऑटोमेशन';

  @override
  String get feedbackRoadmap => 'फीडबैक और रोडमैप';

  @override
  String get dataExport => 'डाटा निर्यात';

  @override
  String get dataManagement => 'डाटा प्रबंधन';

  @override
  String get categories => 'श्रेणियाँ';

  @override
  String get wallets => 'वॉलेट';

  @override
  String get general => 'सामान्य';

  @override
  String get helpSupport => 'सहायता और समर्थन';

  @override
  String get sendFeedback => 'फीडबैक भेजें';

  @override
  String get aboutOllo => 'Ollo के बारे में';

  @override
  String get account => 'खाता';

  @override
  String get deleteData => 'डाटा हटाएं';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get comingSoon => 'जल्द आ रहा है';

  @override
  String get comingSoonDesc =>
      'एआई आपके लेनदेन को वर्गीकृत करेगा और स्मार्ट वित्तीय अंतर्दृष्टि प्रदान करेगा।';

  @override
  String get cantWait => 'इंतजार नहीं कर सकता!';

  @override
  String get deleteAllData => 'सभी डेटा हटाएं?';

  @override
  String deleteAllDataConfirm(String confirmationText) {
    return 'यह कार्रवाई आपके सभी लेनदेन, वॉलेट और नोट्स को स्थायी रूप से हटा देगी। इसे पूर्ववत नहीं किया जा सकता।\n\nपुष्टि करने के लिए, नीचे \"$confirmationText\" टाइप करें:';
  }

  @override
  String get deleteDataConfirmationText => 'डाटा हटाएं';

  @override
  String get dataDeletedSuccess =>
      'डेटा सफलतापूर्वक हटा दिया गया। कृपया ऐप को पुनः आरंभ करें।';

  @override
  String dataDeleteFailed(String error) {
    return 'डेटा हटाने में विफल: $error';
  }

  @override
  String get currency => 'मुद्रा';

  @override
  String get language => 'भाषा';

  @override
  String get selectCurrency => 'मुद्रा चुनें';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get selectCategory => 'श्रेणी चुनें';

  @override
  String get myWallets => 'मेरे वॉलेट';

  @override
  String get emptyWalletsTitle => 'अभी तक कोई वॉलेट नहीं';

  @override
  String get emptyWalletsMessage =>
      'ट्रैकिंग शुरू करने के लिए वॉलेट या बैंक खाता जोड़ें! 💳';

  @override
  String get addWallet => 'नया वॉलेट जोड़ें';

  @override
  String get editWallet => 'वॉलेट संपादित करें';

  @override
  String get newWallet => 'नया वॉलेट';

  @override
  String get walletName => 'वॉलेट का नाम';

  @override
  String get initialBalance => 'प्रारंभिक शेष';

  @override
  String get walletDetails => 'वॉलेट विवरण';

  @override
  String get appearance => 'उपस्थिति';

  @override
  String get icon => 'आइकन';

  @override
  String get color => 'रंग';

  @override
  String get saveWallet => 'वॉलेट सहेजें';

  @override
  String get walletTypeCash => 'नकद';

  @override
  String get walletTypeBank => 'बैंक खाते';

  @override
  String get walletTypeEWallet => 'ई-वॉलेट';

  @override
  String get walletTypeCreditCard => 'क्रेडिट कार्ड';

  @override
  String get walletTypeExchange => 'निवेश';

  @override
  String get walletTypeOther => 'अन्य';

  @override
  String get debitCard => 'डेबिट कार्ड';

  @override
  String get categoriesTitle => 'श्रेणियाँ';

  @override
  String get noCategoriesFound => 'कोई श्रेणी नहीं मिली';

  @override
  String get editCategory => 'श्रेणी संपादित करें';

  @override
  String get newCategory => 'नई श्रेणी';

  @override
  String get categoryName => 'श्रेणी का नाम';

  @override
  String get enterCategoryName => 'कृपया नाम दर्ज करें';

  @override
  String get deleteCategory => 'श्रेणी हटाएं?';

  @override
  String get deleteCategoryConfirm =>
      'इस कार्रवाई को पूर्ववत नहीं किया जा सकता।';

  @override
  String get save => 'सहेजें';

  @override
  String get systemCategoryTitle => 'सिस्टम श्रेणी';

  @override
  String get systemCategoryMessage =>
      'यह श्रेणी सिस्टम द्वारा प्रबंधित है और इसे मैन्युअल रूप से संपादित नहीं किया जा सकता है।';

  @override
  String get sysCatTransfer => 'ट्रांसफर';

  @override
  String get sysCatTransferDesc => 'वॉलेट के बीच फंड ट्रांसफर';

  @override
  String get sysCatRecurring => 'आवर्ती';

  @override
  String get sysCatRecurringDesc => 'स्वचालित आवर्ती लेनदेन';

  @override
  String get sysCatWishlist => 'विशलिस्ट';

  @override
  String get sysCatWishlistDesc => 'विशलिस्ट खरीद से स्वचालित लेनदेन';

  @override
  String get sysCatBills => 'बिल';

  @override
  String get sysCatBillsDesc => 'बिल भुगतान से स्वचालित लेनदेन';

  @override
  String get dueDateLabel => 'देय तिथि';

  @override
  String get statusLabel => 'स्थिति';

  @override
  String get noPaymentsYet => 'अभी तक कोई भुगतान नहीं';

  @override
  String get sysCatDebts => 'उधारी';

  @override
  String get sysCatDebtsDesc => 'उधारी/ऋण रिकॉर्ड';

  @override
  String get sysCatSavings => 'बचत';

  @override
  String get sysCatSavingsDesc => 'बचत जमा/निकासी';

  @override
  String get sysCatSmartNotes => 'बंडल नोट्स';

  @override
  String get sysCatSmartNotesDesc => 'स्मार्ट बंडल से स्वचालित लेनदेन';

  @override
  String get sysCatReimburse => 'प्रतिपूर्ति';

  @override
  String get sysCatReimburseDesc => 'प्रतिपूर्ति ट्रैकिंग प्रणाली';

  @override
  String get budgetsTitle => 'बजट';

  @override
  String get noBudgetsYet => 'अभी तक कोई बजट नहीं';

  @override
  String get createBudget => 'बजट बनाएं';

  @override
  String get yourBudgets => 'आपके बजट';

  @override
  String get newBudget => 'नया बजट';

  @override
  String get editBudget => 'बजट संपादित करें';

  @override
  String get limitAmount => 'सीमा राशि';

  @override
  String get period => 'अवधि';

  @override
  String get weekly => 'साप्ताहिक';

  @override
  String get monthly => 'मासिक';

  @override
  String get yearly => 'वार्षिक';

  @override
  String get daily => 'दैनिक';

  @override
  String get deleteBudget => 'बजट हटाएं';

  @override
  String get deleteBudgetConfirm => 'क्या आप वाकई इस बजट को हटाना चाहते हैं?';

  @override
  String get enterAmount => 'राशि दर्ज करें';

  @override
  String get recurringTitle => 'आवर्ती';

  @override
  String get activeSubscriptions => 'सक्रिय सदस्यताएँ';

  @override
  String get noActiveSubscriptions => 'कोई सक्रिय सदस्यता नहीं';

  @override
  String get newRecurring => 'नया आवर्ती';

  @override
  String get editRecurring => 'आवर्ती संपादित करें';

  @override
  String get frequency => 'आवृत्ति';

  @override
  String get startDate => 'प्रारंभ तिथि';

  @override
  String get payWithWallet => 'वॉलेट से भुगतान करें';

  @override
  String get updateRecurring => 'अपडेट करें';

  @override
  String get saveRecurring => 'सहेजें';

  @override
  String get deleteRecurring => 'आवर्ती हटाएं?';

  @override
  String get deleteRecurringConfirm =>
      'यह भविष्य के ऑटो-भुगतान को रोक देगा। पिछले लेनदेन बने रहेंगे।';

  @override
  String get pleaseSelectWallet => 'कृपया वॉलेट चुनें';

  @override
  String get debtsTitle => 'उधारी';

  @override
  String get iOwe => 'मुझे देना है';

  @override
  String get owedToMe => 'मुझे लेना है';

  @override
  String get netBalance => 'शुद्ध शेष';

  @override
  String get debtFree => 'आप कर्ज मुक्त हैं!';

  @override
  String get noOneOwesYou => 'कोई आपको पैसे नहीं देता।';

  @override
  String get paidStatus => 'भुगतान किया';

  @override
  String get overdue => 'अतिदेय';

  @override
  String dueOnDate(String date) {
    return 'देय $date';
  }

  @override
  String amountLeft(String amount) {
    return '$amount बाकी';
  }

  @override
  String get deleteDebt => 'उधारी हटाएं?';

  @override
  String get deleteDebtConfirm => 'यह उधारी रिकॉर्ड हटा देगा।';

  @override
  String get sortByDate => 'तिथि के अनुसार क्रमबद्ध करें';

  @override
  String get sortByAmount => 'राशि के अनुसार क्रमबद्ध करें';

  @override
  String get editDebt => 'संपादित करें';

  @override
  String get addDebt => 'जोड़ें';

  @override
  String get iBorrowed => 'मैंने उधार लिया';

  @override
  String get iLent => 'मैंने उधार दिया';

  @override
  String get personName => 'व्यक्ति का नाम';

  @override
  String get whoHint => 'कौन?';

  @override
  String get required => 'आवश्यक';

  @override
  String get updateDebt => 'अपडेट करें';

  @override
  String get saveDebt => 'सहेजें';

  @override
  String get debtSaved => 'सहेजा गया';

  @override
  String get debtUpdated => 'अपडेट किया गया';

  @override
  String get debtDeleted => 'हटाया गया';

  @override
  String get debtDetails => 'विवरण';

  @override
  String get paymentHistory => 'भुगतान इतिहास';

  @override
  String youOweName(String name) {
    return 'आप $name को देते हैं';
  }

  @override
  String nameOwesYou(String name) {
    return '$name आपको देता है';
  }

  @override
  String totalAmount(String amount) {
    return 'कुल: $amount';
  }

  @override
  String paidAmount(String amount) {
    return 'भुगतान: $amount';
  }

  @override
  String get activeStatus => 'सक्रिय';

  @override
  String get addPayment => 'भुगतान जोड़ें';

  @override
  String get noneRecordOnly => 'कोई नहीं (केवल रिकॉर्ड)';

  @override
  String get confirmPayment => 'भुगतान की पुष्टि करें';

  @override
  String get paymentRecorded => 'भुगतान दर्ज किया गया!';

  @override
  String get deleteDebtWarning =>
      'यह रिकॉर्ड हटा देगा। वॉलेट शेष स्वचालित रूप से वापस नहीं किया जाएगा।';

  @override
  String get billsTitle => 'बिल';

  @override
  String get unpaid => 'अदत्त';

  @override
  String get paidTab => 'भुगतान किया';

  @override
  String get allCaughtUp => 'सब कुछ हो गया!';

  @override
  String get noUnpaidBills => 'फिलहाल कोई अदत्त बिल नहीं।';

  @override
  String get noHistoryYet => 'कोई इतिहास नहीं';

  @override
  String paidOnDate(String date) {
    return '$date को भुगतान किया';
  }

  @override
  String get dueToday => 'आज देय';

  @override
  String dueInDays(int days) {
    return '$days दिनों में देय';
  }

  @override
  String get pay => 'भुगतान करें';

  @override
  String get payBill => 'बिल भुगतान करें';

  @override
  String payBillTitle(String title) {
    return 'भुगतान \"$title\"?';
  }

  @override
  String get payFrom => 'भुगतान से:';

  @override
  String get noWalletsFound => 'कोई वॉलेट नहीं मिला';

  @override
  String get billPaidSuccess => 'बिल भुगतान सफल!';

  @override
  String get editBill => 'संपादित करें';

  @override
  String get addBill => 'जोड़ें';

  @override
  String get billDetails => 'विवरण';

  @override
  String get billName => 'बिल का नाम';

  @override
  String get billType => 'प्रकार';

  @override
  String get repeatBill => 'दोहराना?';

  @override
  String get autoCreateBill => 'स्वतः बनाएं';

  @override
  String get updateBill => 'अपडेट करें';

  @override
  String get saveBill => 'सहेजें';

  @override
  String get billSaved => 'सहेजा गया';

  @override
  String get billUpdated => 'अपडेट किया गया';

  @override
  String get billDeleted => 'हटाया गया';

  @override
  String get payBillDescription =>
      'यह एक सिस्टम लेनदेन बनाएगा और आपके वॉलेट से कटौती करेगा।';

  @override
  String get deleteBill => 'हटाएं?';

  @override
  String get deleteBillConfirm => 'इसे पूर्ववत नहीं किया जा सकता।';

  @override
  String get errorInvalidBill => 'मान्य शीर्षक और राशि दर्ज करें';

  @override
  String get wishlistTitle => 'विशलिस्ट';

  @override
  String get activeTab => 'सक्रिय';

  @override
  String get achievedTab => 'प्राप्त';

  @override
  String get emptyActiveWishlistMessage =>
      'वे चीजें जोड़ना शुरू करें जिन्हें आप खरीदना चाहते हैं';

  @override
  String get emptyAchievedWishlistMessage =>
      'अभी तक कोई सपना पूरा नहीं हुआ। चलते रहो!';

  @override
  String get noAchievementsYet => 'कोई उपलब्धि नहीं';

  @override
  String get wishlistEmpty => 'खाली है';

  @override
  String get deleteItemTitle => 'हटाएं?';

  @override
  String deleteItemConfirm(String title) {
    return '\"$title\" हटाएं?';
  }

  @override
  String get buy => 'खरीदें';

  @override
  String get buyItemTitle => 'खरीदें';

  @override
  String purchaseItemTitle(String title) {
    return '\"$title\" खरीदें?';
  }

  @override
  String get selectWalletLabel => 'वॉलेट चुनें:';

  @override
  String get noWalletsFoundMessage => 'पहले वॉलेट बनाएं।';

  @override
  String get amountLabel => 'राशि:';

  @override
  String get confirmPurchase => 'खरीद की पुष्टि करें';

  @override
  String get purchaseSuccessMessage => 'खरीद सफल! 🎉';

  @override
  String errorLaunchingUrl(String error) {
    return 'URL खोलने में त्रुटि: $error';
  }

  @override
  String get editWishlist => 'संपादित करें';

  @override
  String get addWishlist => 'जोड़ें';

  @override
  String get addPhoto => 'फोटो जोड़ें';

  @override
  String get itemName => 'आइटम का नाम';

  @override
  String get itemNameHint => 'उदा. लैपटॉप';

  @override
  String get priceLabel => 'मूल्य';

  @override
  String get targetDateLabel => 'लक्ष्य तिथि';

  @override
  String get selectDate => 'तिथि चुनें';

  @override
  String get productLinkLabel => 'लिंक (वैकल्पिक)';

  @override
  String get productLinkHint => 'उदा. https://...';

  @override
  String get updateWishlist => 'अपडेट करें';

  @override
  String get saveWishlist => 'सहेजें';

  @override
  String get errorInvalidWishlist => 'मान्य शीर्षक और मूल्य दर्ज करें';

  @override
  String get wishlistUpdated => 'अपडेट किया गया';

  @override
  String get wishlistSaved => 'सहेजा गया';

  @override
  String get deleteWishlistTitle => 'हटाएं?';

  @override
  String get deleteWishlistConfirm => 'इसे पूर्ववत नहीं किया जा सकता।';

  @override
  String get wishlistDeleted => 'हटाया गया';

  @override
  String errorPickingImage(String error) {
    return 'छवि चुनने में त्रुटि: $error';
  }

  @override
  String get smartNotesTitle => 'मेरे बंडल';

  @override
  String get emptySmartNotesMessage => 'अपना पहला बंडल बनाएं!';

  @override
  String get historyTitle => 'इतिहास';

  @override
  String errorMessage(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get addSmartNote => 'नया बंडल';

  @override
  String get noItemsInBundle => 'कोई आइटम नहीं';

  @override
  String payAmount(String amount) {
    return '$amount भुगतान करें';
  }

  @override
  String get paidAndCompleted => 'भुगतान और पूर्ण';

  @override
  String get undoPay => 'पूर्ववत करें';

  @override
  String get deleteSmartNoteTitle => 'हटाएं?';

  @override
  String confirmPaymentMessage(String amount) {
    return '$amount का लेनदेन बनाएं?';
  }

  @override
  String get paymentSuccess => 'पूर्ण!';

  @override
  String get undoPaymentTitle => 'भुगतान पूर्ववत करें?';

  @override
  String get undoPaymentConfirm =>
      'यह लेनदेन को हटा देगा और बंडल को फिर से खोल देगा।';

  @override
  String get undoAndReopen => 'पूर्ववत करें और खोलें';

  @override
  String get purchaseReopened => 'पुनः खोला गया';

  @override
  String get editSmartNote => 'संपादित करें';

  @override
  String get newSmartNote => 'नया बंडल';

  @override
  String get smartNoteName => 'बंडल का नाम';

  @override
  String get smartNoteNameHint => 'उदा. महीने का राशन';

  @override
  String get itemsList => 'आइटम सूची';

  @override
  String get addItem => 'आइटम जोड़ें';

  @override
  String get requiredShort => 'आवश्यक';

  @override
  String get additionalNotes => 'अतिरिक्त नोट्स';

  @override
  String get totalEstimate => 'कुल अनुमान';

  @override
  String get saveBundle => 'सहेजें';

  @override
  String get checkedTotal => 'चिह्नित कुल:';

  @override
  String get completed => 'पूर्ण';

  @override
  String get payAndFinish => 'भुगतान करें और समाप्त करें';

  @override
  String get payingWith => 'से भुगतान';

  @override
  String get noItemsChecked => 'कोई आइटम नहीं चुना गया!';

  @override
  String get smartNoteTransactionRecorded => 'दर्ज किया गया!';

  @override
  String get totalDreamValue => 'कुल मूल्य';

  @override
  String activeWishesCount(int count) {
    return '$count इच्छाएं';
  }

  @override
  String achievedDreamsCount(int count) {
    return '$count सपने पूरे हुए! 🎉';
  }

  @override
  String get billDataNotFound => 'बिल डेटा नहीं मिला';

  @override
  String get wishlistDataNotFound => 'विशलिस्ट डेटा नहीं मिला';

  @override
  String get editReimbursementNotSupported => 'संपादन समर्थित नहीं है';

  @override
  String get transactions => 'लेनदेन';

  @override
  String get noTransactionsFound => 'कोई लेनदेन नहीं मिला';

  @override
  String get noTransactionsInCategory => 'इस श्रेणी में कोई लेनदेन नहीं';

  @override
  String get noDataForPeriod => 'इस अवधि के लिए कोई डेटा नहीं';

  @override
  String get monthlyOverview => 'मासिक अवलोकन';

  @override
  String get unlockPremiumStats => 'प्रीमियम आंकड़े अनलॉक करें';

  @override
  String get totalBalance => 'कुल शेष';

  @override
  String get dailyBudget => 'दैनिक बजट';

  @override
  String get weeklyBudget => 'साप्ताहिक बजट';

  @override
  String get monthlyBudget => 'मासिक बजट';

  @override
  String get yearlyBudget => 'वार्षिक बजट';

  @override
  String get wishlistPurchase => 'विशलिस्ट खरीद';

  @override
  String get billPayment => 'बिल भुगतान';

  @override
  String get debtTransaction => 'उधारी लेनदेन';

  @override
  String get savingsTransaction => 'बचत लेनदेन';

  @override
  String get transferTransaction => 'ट्रांसफर';

  @override
  String get pressBackAgainToExit => 'बाहर निकलने के लिए फिर से दबाएं';

  @override
  String get quickRecord => 'त्वरित रिकॉर्ड';

  @override
  String get chatAction => 'चैट';

  @override
  String get scanAction => 'स्कैन';

  @override
  String get voiceAction => 'आवाज़';

  @override
  String get filterDay => 'दिन';

  @override
  String get filterWeek => 'सप्ताह';

  @override
  String get filterMonth => 'महीना';

  @override
  String get filterYear => 'वर्ष';

  @override
  String get filterAll => 'सभी';

  @override
  String get editTransaction => 'संपादित करें';

  @override
  String get addTransaction => 'जोड़ें';

  @override
  String get titleLabel => 'शीर्षक';

  @override
  String get enterDescriptionHint => 'विवरण दर्ज करें';

  @override
  String get enterTitleHint => 'शीर्षक दर्ज करें';

  @override
  String get enterValidAmount => 'मान्य राशि दर्ज करें';

  @override
  String get selectWalletError => 'वॉलेट चुनें';

  @override
  String get selectDestinationWalletError => 'गंतव्य वॉलेट चुनें';

  @override
  String get selectCategoryError => 'श्रेणी चुनें';

  @override
  String get saveTransaction => 'सहेजें';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String error(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get expenseDetails => 'खर्च विवरण';

  @override
  String get incomeDetails => 'आय विवरण';

  @override
  String get noExpensesFound => 'कोई खर्च नहीं';

  @override
  String get noIncomeFound => 'कोई आय नहीं';

  @override
  String get forThisDate => 'इस तारीख के लिए';

  @override
  String get timeFilterToday => 'आज';

  @override
  String get timeFilterThisWeek => 'इस सप्ताह';

  @override
  String get timeFilterThisMonth => 'इस महीने';

  @override
  String get timeFilterThisYear => 'इस वर्ष';

  @override
  String get timeFilterAllTime => 'सभी समय';

  @override
  String get dailyAverage => 'दैनिक औसत';

  @override
  String get projectedTotal => 'अनुमानित कुल';

  @override
  String get spendingHabitsNote => 'आदतों पर आधारित।';

  @override
  String get monthlyComparison => 'मासिक तुलना';

  @override
  String get spendingLessNote => 'आप कम खर्च कर रहे हैं!';

  @override
  String get spendingMoreNote => 'खर्च सामान्य से अधिक है।';

  @override
  String get topSpenders => 'शीर्ष खर्चे';

  @override
  String transactionsCount(int count) {
    return '$count लेनदेन';
  }

  @override
  String get activityHeatmap => 'हीटमैप';

  @override
  String get less => 'कम';

  @override
  String get more => 'अधिक';

  @override
  String get backupRecoveryTitle => 'बैकअप और रिकवरी';

  @override
  String get backupDescription => 'स्थानीय बैकअप फ़ाइल (JSON) बनाएं।';

  @override
  String get createBackup => 'बैकअप बनाएं';

  @override
  String get restoreBackup => 'बैकअप बहाल करें';

  @override
  String get createBackupSubtitle => 'JSON में निर्यात करें';

  @override
  String get restoreBackupSubtitle => 'JSON से आयात करें (डेटा मिटा देगा)';

  @override
  String get creatingBackup => 'बना रहा है...';

  @override
  String get restoringBackup => 'बहाल कर रहा है...';

  @override
  String backupSuccess(String path) {
    return 'सहेजा गया:\n$path';
  }

  @override
  String get restoreSuccess => 'बहाल हो गया! रीस्टार्ट करें।';

  @override
  String backupError(String error) {
    return 'विफल: $error';
  }

  @override
  String restoreError(String error) {
    return 'विफल: $error';
  }

  @override
  String get restoreWarningTitle => '⚠ चेतावनी: डेटा बहाल करें';

  @override
  String get restoreWarningMessage =>
      'यह वर्तमान डेटा को हटा देगा। क्या आप सुनिश्चित हैं?';

  @override
  String get yesRestore => 'हाँ, बहाल करें';

  @override
  String get exportDataTitle => 'डाटा निर्यात';

  @override
  String get dateRange => 'तिथि सीमा';

  @override
  String get transactionType => 'लेनदेन प्रकार';

  @override
  String get allWallets => 'सभी वॉलेट';

  @override
  String get allCategories => 'सभी श्रेणियाँ';

  @override
  String shareCsv(int count) {
    return 'CSV साझा करें ($count आइटम)';
  }

  @override
  String get saveToDownloads => 'डाउनलोड में सहेजें';

  @override
  String get calculating => 'गणना हो रही है...';

  @override
  String get noTransactionsMatch => 'कोई लेनदेन नहीं मिला';

  @override
  String exportFailed(String error) {
    return 'विफल: $error';
  }

  @override
  String saveFailed(String error) {
    return 'विफल: $error';
  }

  @override
  String fileSavedTo(String path) {
    return 'सहेजा गया: $path';
  }

  @override
  String get lastMonth => 'पिछले महीने';

  @override
  String get sendFeedbackTitle => 'फीडबैक भेजें';

  @override
  String get weValueYourVoice => 'हम आपकी राय की कद्र करते हैं';

  @override
  String get feedbackDescription => 'कोई विचार या बग? हमें बताएं!';

  @override
  String get chatViaWhatsApp => 'व्हाट्सएप पर चैट करें';

  @override
  String get repliesInHours => 'कुछ घंटों में जवाब देता है';

  @override
  String subCategoriesCount(int count) {
    return 'उप-श्रेणियाँ: $count';
  }

  @override
  String get unnamed => 'बिना नाम';

  @override
  String get ok => 'ठीक';

  @override
  String errorPrefix(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get whatsappMessage => 'नमस्ते Ollo टीम...';

  @override
  String get roadmapTitle => 'रोडमैप';

  @override
  String get roadmapInProgress => 'प्रगति में';

  @override
  String get roadmapPlanned => 'योजनाबद्ध';

  @override
  String get roadmapCompleted => 'पूर्ण';

  @override
  String get roadmapHighPriority => 'उच्च प्राथमिकता';

  @override
  String get roadmapBeta => 'बीटा';

  @override
  String get roadmapDev => 'देव';

  @override
  String get featureCloudBackupTitle => 'क्लाउड बैकअप';

  @override
  String get featureCloudBackupDesc => 'गूगल ड्राइव सिंक';

  @override
  String get featureAiInsightsTitle => 'एआई इनसाइट्स';

  @override
  String get featureAiInsightsDesc => 'गहन विश्लेषण';

  @override
  String get featureDataExportTitle => 'डेटा निर्यात';

  @override
  String get featureDataExportDesc => 'एक्सेल/CSV';

  @override
  String get featureBudgetForecastingTitle => 'बजट पूर्वानुमान';

  @override
  String get featureBudgetForecastingDesc => 'अगले महीने का अनुमान';

  @override
  String get featureMultiCurrencyTitle => 'बहु-मुद्रा';

  @override
  String get featureMultiCurrencyDesc => 'रीयल-टाइम रूपांतरण';

  @override
  String get featureReceiptScanningTitle => 'रसीद स्कैन (OCR)';

  @override
  String get featureReceiptScanningDesc => 'ऑटो-इनपुट';

  @override
  String get featureLocalBackupTitle => 'लोकल बैकअप';

  @override
  String get featureLocalBackupDesc => 'फ़ाइल में सहेजें';

  @override
  String get featureSmartNotesTitle => 'स्मार्ट नोट्स';

  @override
  String get featureSmartNotesDesc => 'खरीदारी सूची';

  @override
  String get featureRecurringTitle => 'आवर्ती लेनदेन';

  @override
  String get featureRecurringDesc => 'बिलों का स्वचालन';

  @override
  String get aboutTitle => 'Ollo के बारे में';

  @override
  String get aboutPhilosophyTitle => 'आपका वित्तीय साथी';

  @override
  String get aboutPhilosophyDesc =>
      'Ollo वित्त प्रबंधन को सरल बनाने के लिए है।';

  @override
  String get connectWithUs => 'जुड़े रहें';

  @override
  String version(String version) {
    return 'संस्करण $version';
  }

  @override
  String get helpTitle => 'सहायता';

  @override
  String get helpIntroTitle => 'कैसे मदद करें?';

  @override
  String get helpIntroDesc => 'FAQ या संपर्क';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get faqAddWalletQuestion => 'वॉलेट कैसे जोड़ें?';

  @override
  String get faqAddWalletAnswer => '\"वॉलेट\" मेनू में + बटन दबाएं।';

  @override
  String get faqExportDataQuestion => 'डेटा निर्यात?';

  @override
  String get faqExportDataAnswer => 'जल्द आ रहा है (प्रीमियम)।';

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
  String get contactSupport => 'संपर्क करें';

  @override
  String get reimbursementTitle => 'प्रतिपूर्ति';

  @override
  String get reimbursementPending => 'लंबित';

  @override
  String get reimbursementCompleted => 'पूर्ण';

  @override
  String get noPendingReimbursements => 'कोई लंबित नहीं';

  @override
  String get noCompletedReimbursements => 'कोई पूर्ण नहीं';

  @override
  String get markPaid => 'भुगतान चिह्नित करें';

  @override
  String get totalSavings => 'कुल बचत';

  @override
  String get financialBuckets => 'वित्तीय बक्से';

  @override
  String get noSavingsYet => 'कोई बचत नहीं';

  @override
  String growthThisMonth(String percent) {
    return '$percent% इस महीने';
  }

  @override
  String get myCards => 'मेरे कार्ड';

  @override
  String selectedCount(int count) {
    return '$count चयनित';
  }

  @override
  String get copyNumber => 'नंबर कॉपी करें';

  @override
  String get copyTemplate => 'टेम्पलेट कॉपी करें';

  @override
  String cardsCopied(int count) {
    return 'कॉपी किया गया!';
  }

  @override
  String get cardNumberCopied => 'कॉपीड!';

  @override
  String get cardTemplateCopied => 'कॉपीड!';

  @override
  String get noCardsYet => 'कोई कार्ड नहीं';

  @override
  String get addCardsMessage => 'खाते जोड़ें';

  @override
  String get premiumTitle => 'प्रीमियम';

  @override
  String get premiumSubtitle => 'पूर्ण क्षमता अनलॉक करें।';

  @override
  String get premiumAdvancedStats => 'उन्नत आँकड़े';

  @override
  String get premiumAdvancedStatsDesc => 'इंटरैक्टिव चार्ट';

  @override
  String get premiumDataExport => 'डेटा निर्यात';

  @override
  String get premiumDataExportDesc => 'CSV/Excel';

  @override
  String get premiumUnlimitedWallets => 'असीमित वॉलेट';

  @override
  String get premiumUnlimitedWalletsDesc => 'जितना चाहे उतना बनाएं';

  @override
  String get premiumSmartAlerts => 'स्मार्ट अलर्ट';

  @override
  String get premiumSmartAlertsDesc => 'अधिव्यय से बचें';

  @override
  String get upgradeButton => 'अपग्रेड - Rp 29.000 / लाइफटाइम';

  @override
  String get restorePurchase => 'खरीद बहाल करें';

  @override
  String get youArePremium => 'आप प्रीमियम हैं!';

  @override
  String get premiumWelcome => 'स्वागत है! 🌟';

  @override
  String get contactSupportMessage => 'नमस्ते Ollo सपोर्ट...';

  @override
  String get category_food => 'भोजन और पेय';

  @override
  String get category_transport => 'परिवहन';

  @override
  String get category_shopping => 'खरीदारी';

  @override
  String get category_housing => 'आवास';

  @override
  String get category_entertainment => 'मनोरंजन';

  @override
  String get category_health => 'स्वास्थ्य';

  @override
  String get category_education => 'शिक्षा';

  @override
  String get category_personal => 'व्यक्तिगत';

  @override
  String get category_financial => 'वित्तीय';

  @override
  String get category_family => 'परिवार';

  @override
  String get category_salary => 'वेतन';

  @override
  String get category_business => 'व्यापार';

  @override
  String get category_investments => 'निवेश';

  @override
  String get category_gifts_income => 'उपहार';

  @override
  String get category_other_income => 'अन्य';

  @override
  String get subcategory_breakfast => 'नाश्ता';

  @override
  String get subcategory_lunch => 'दोपहर का भोजन';

  @override
  String get subcategory_dinner => 'रात का खाना';

  @override
  String get subcategory_eateries => 'भोजनालय';

  @override
  String get subcategory_snacks => 'नाश्ता';

  @override
  String get subcategory_drinks => 'पेय';

  @override
  String get subcategory_groceries => 'किराना';

  @override
  String get subcategory_delivery => 'डिलीवरी';

  @override
  String get subcategory_alcohol => 'शराब';

  @override
  String get subcategory_bus => 'बस';

  @override
  String get subcategory_train => 'ट्रेन';

  @override
  String get subcategory_taxi => 'टैक्सी';

  @override
  String get subcategory_fuel => 'ईंधन';

  @override
  String get subcategory_parking => 'पार्किंग';

  @override
  String get subcategory_maintenance => 'रखरखाव';

  @override
  String get subcategory_insurance_car => 'बीमा';

  @override
  String get subcategory_toll => 'टोल';

  @override
  String get subcategory_clothes => 'कपड़े';

  @override
  String get subcategory_electronics => 'इलेक्ट्रॉनिक्स';

  @override
  String get subcategory_home => 'घर';

  @override
  String get subcategory_beauty => 'सुंदरता';

  @override
  String get subcategory_gifts => 'उपहार';

  @override
  String get subcategory_software => 'सॉफ्टवेयर';

  @override
  String get subcategory_tools => 'उपकरण';

  @override
  String get subcategory_rent => 'किराया';

  @override
  String get subcategory_mortgage => 'बंधक';

  @override
  String get subcategory_utilities => 'उपयोगिताएँ';

  @override
  String get subcategory_internet => 'इंटरनेट';

  @override
  String get subcategory_maintenance_home => 'रखरखाव';

  @override
  String get subcategory_furniture => 'फर्निचर';

  @override
  String get subcategory_services => 'सेवाएं';

  @override
  String get subcategory_movies => 'सिनेमा';

  @override
  String get subcategory_games => 'खेल';

  @override
  String get subcategory_streaming => 'स्ट्रीमिंग';

  @override
  String get subcategory_events => 'कार्यक्रम';

  @override
  String get subcategory_hobbies => 'शौक';

  @override
  String get subcategory_travel => 'यात्रा';

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
  String get subcategory_music => 'संगीत';

  @override
  String get subcategory_doctor => 'डॉक्टर';

  @override
  String get subcategory_pharmacy => 'फार्मेसी';

  @override
  String get subcategory_gym => 'जिम';

  @override
  String get subcategory_insurance_health => 'स्वास्थ्य बीमा';

  @override
  String get subcategory_mental_health => 'मानसिक स्वास्थ्य';

  @override
  String get subcategory_sports => 'खेल';

  @override
  String get subcategory_tuition => 'ट्यूशन';

  @override
  String get subcategory_books => 'किताबें';

  @override
  String get subcategory_courses => 'पाठ्यक्रम';

  @override
  String get subcategory_supplies => 'आपूर्ति';

  @override
  String get subcategory_haircut => 'बाल कटवाना';

  @override
  String get subcategory_spa => 'स्पा';

  @override
  String get subcategory_cosmetics => 'कॉस्मेटिक्स';

  @override
  String get subcategory_taxes => 'कर';

  @override
  String get subcategory_fees => 'फीस';

  @override
  String get subcategory_fines => 'जुर्माना';

  @override
  String get subcategory_insurance_life => 'जीवन बीमा';

  @override
  String get subcategory_childcare => 'बच्चे की देखभाल';

  @override
  String get subcategory_toys => 'खिलौने';

  @override
  String get subcategory_school_kids => 'स्कूल';

  @override
  String get subcategory_pets => 'पालतू जानवर';

  @override
  String get subcategory_monthly => 'मासिक';

  @override
  String get subcategory_weekly => 'साप्ताहिक';

  @override
  String get subcategory_bonus => 'बोनस';

  @override
  String get subcategory_overtime => 'ओवरटाइम';

  @override
  String get subcategory_sales => 'बिक्री';

  @override
  String get subcategory_profit => 'लाभ';

  @override
  String get subcategory_dividends => 'लाभांश';

  @override
  String get subcategory_interest => 'ब्याज';

  @override
  String get subcategory_crypto => 'क्रिप्टो';

  @override
  String get subcategory_stocks => 'स्टॉक्स';

  @override
  String get subcategory_real_estate => 'रियल एस्टेट';

  @override
  String get subcategory_birthday => 'जन्मदिन';

  @override
  String get subcategory_holiday => 'छुट्टी';

  @override
  String get subcategory_allowance => 'भत्ता';

  @override
  String get subcategory_refunds => 'रिफंड';

  @override
  String get subcategory_grants => 'अनुदान';

  @override
  String get subcategory_lottery => 'लॉटरी';

  @override
  String get subcategory_selling => 'बिक्री';

  @override
  String get editProfileTitle => 'प्रोफ़ाइल संपादित करें';

  @override
  String get nameLabel => 'नाम';

  @override
  String get emailLabel => 'ईमेल (वैकल्पिक)';

  @override
  String get uploadPhoto => 'फोटो अपलोड करें';

  @override
  String get saveChanges => 'परिवर्तन सहेजें';

  @override
  String get listeningMessage => 'Ollo सुन रहा है...';

  @override
  String get quickRecordTitle => 'त्वरित रिकॉर्ड';

  @override
  String get saySomethingHint => 'कुछ कहें...';

  @override
  String get stopAndProcess => 'रुकें और संसाधित करें';

  @override
  String get textInputHint => 'उदा. \"दोपहर का भोजन 50\"';

  @override
  String get draftReady => 'ड्राफ्ट तैयार';

  @override
  String get saveAdjust => 'सहेजें / समायोजित करें';

  @override
  String get notFound => 'नहीं मिला';

  @override
  String get selectWallet => 'वॉलेट चुनें';
}
