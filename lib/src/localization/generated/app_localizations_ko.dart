// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get quickRecordHelpTitle => '다음과 같이 말해보세요:';

  @override
  String get quickRecordHelp1 => '\"어제 커피 4500원 카카오뱅크\"';

  @override
  String get quickRecordHelp2 => '\"월급 300만원 국민은행\"';

  @override
  String get quickRecordHelp3 => '\"점심 8000원 토스\"';

  @override
  String get quickRecordHelp4 => '\"주유 50000원 신한카드\"';

  @override
  String get quickRecordHelp5 => '\"월세 50만원 1일에 카카오뱅크\"';

  @override
  String get quickRecordHelp6 => '\"카페 5000원 현금\"';

  @override
  String get quickRecordHelp7 => '\"인터넷 3만원 20일에 자동이체\"';

  @override
  String get quickRecordHelp8 => '\"영화 15000원 이번주 일요일\"';

  @override
  String get quickRecordHelp9 => '\"친구 갚음 5만원 현금\"';

  @override
  String get quickRecordHelp10 => '\"엄마 용돈 10만원 국민은행\"';

  @override
  String get customizeMenu => '메뉴 사용자 지정';

  @override
  String get menuOrder => '메뉴 순서';

  @override
  String get resetMenu => '메뉴 초기화';

  @override
  String get home => '홈';

  @override
  String get cardAppearance => '카드 디자인';

  @override
  String get selectTheme => '테마 선택';

  @override
  String get themeClassic => '클래식 블루';

  @override
  String get themeSunset => '선셋 오렌지';

  @override
  String get themeOcean => '오션 틸';

  @override
  String get themeBerry => '베리 퍼플';

  @override
  String get themeForest => '네이처 그린';

  @override
  String get themeMidnight => '미드나잇 다크';

  @override
  String get themeOasis => '캄 오아시스';

  @override
  String get themeLavender => '소프트 라벤더';

  @override
  String get themeCottonCandy => '파스텔 드림';

  @override
  String get themeMint => '심플리 민트';

  @override
  String get themePeach => '심플리 피치';

  @override
  String get themeSoftBlue => '심플리 블루';

  @override
  String get themeLilac => '심플리 라일락';

  @override
  String get themeLemon => '심플리 레몬';

  @override
  String get themeArgon => '아르곤';

  @override
  String get themeVelvetSun => '벨벳 선';

  @override
  String get themeSummer => '썸머';

  @override
  String get themeBrokenHearts => '브로큰 하트';

  @override
  String get themeRelay => '릴레이';

  @override
  String get themeCinnamint => '시나민트';

  @override
  String get wallet => '지갑';

  @override
  String get profile => '프로필';

  @override
  String get statistics => '통계';

  @override
  String get expense => '지출';

  @override
  String get income => '수입';

  @override
  String get transfer => '이체';

  @override
  String get amount => '금액';

  @override
  String get to => '받는 곳';

  @override
  String get addNoteHint => '메모 추가...';

  @override
  String get cancel => '취소';

  @override
  String get done => '완료';

  @override
  String get errorInvalidAmount => '올바른 금액을 입력하세요';

  @override
  String get errorSelectWallet => '지갑을 선택해주세요';

  @override
  String get errorSelectDestinationWallet => '보낼 지갑을 선택해주세요';

  @override
  String get errorSameWallets => '출금 및 입금 지갑은 달라야 합니다';

  @override
  String get errorSelectCategory => '카테고리를 선택해주세요';

  @override
  String get transactionDetail => '거래 상세';

  @override
  String get title => '제목';

  @override
  String get category => '카테고리';

  @override
  String get dateTime => '일시';

  @override
  String get date => '날짜';

  @override
  String get time => '시간';

  @override
  String get note => '메모';

  @override
  String get deleteTransaction => '거래 삭제';

  @override
  String get deleteTransactionConfirm => '이 거래를 삭제하시겠습니까? 지갑 잔액이 복구됩니다.';

  @override
  String get delete => '삭제';

  @override
  String get edit => '편집';

  @override
  String get markCompleted => '완료됨으로 표시';

  @override
  String get markCompletedConfirm => '이 지출 결의를 완료 처리하시겠습니까?';

  @override
  String get confirm => '확인';

  @override
  String get system => '시스템';

  @override
  String get recentTransactions => '최근 내역';

  @override
  String get noTransactions => '내역 없음';

  @override
  String get startRecording => '수입과 지출을 기록하여 금융 생활을 체계적으로 관리하세요! 🚀';

  @override
  String get menu => '메뉴';

  @override
  String get budget => '예산';

  @override
  String get recurring => '반복';

  @override
  String get savings => '저축';

  @override
  String get total => '합계';

  @override
  String get bills => '청구서';

  @override
  String get debts => '채무';

  @override
  String get wishlist => '위시리스트';

  @override
  String get cards => '카드';

  @override
  String get notes => '메모';

  @override
  String get reimburse => '지출 결의';

  @override
  String get unknown => '알 수 없음';

  @override
  String welcome(String name) {
    return '$name님, 안녕하세요!';
  }

  @override
  String get welcomeSimple => '안녕하세요!';

  @override
  String get settings => '설정';

  @override
  String get developerOptions => '개발자 옵션';

  @override
  String get futureFeatures => '향후 기능';

  @override
  String get backupRecovery => '백업 & 복구';

  @override
  String get aiAutomation => 'AI 자동화';

  @override
  String get feedbackRoadmap => '피드백 & 로드맵';

  @override
  String get dataExport => '데이터 내보내기';

  @override
  String get dataManagement => '데이터 관리';

  @override
  String get categories => '카테고리';

  @override
  String get wallets => '지갑 관리';

  @override
  String get general => '일반';

  @override
  String get helpSupport => '고객 지원';

  @override
  String get sendFeedback => '피드백 보내기';

  @override
  String get bugReport => 'Report Bug';

  @override
  String get bugReportDeviceInfo => 'Device Information';

  @override
  String get bugReportFeature => 'Feature with issue';

  @override
  String get bugReportSeverity => 'Severity';

  @override
  String get bugReportTitle => 'Bug Title';

  @override
  String get bugReportTitleHint => 'Brief description of the issue';

  @override
  String get bugReportTitleRequired => 'Please enter a title';

  @override
  String get bugReportDescription => 'Description';

  @override
  String get bugReportDescriptionHint => 'What happened? What did you expect?';

  @override
  String get bugReportDescriptionRequired => 'Please describe the bug';

  @override
  String get bugReportSteps => 'Steps to Reproduce';

  @override
  String get bugReportStepsHint => '1. Go to...\n2. Tap on...\n3. See error';

  @override
  String get bugReportSend => 'Send Report';

  @override
  String get bugReportSendVia => 'Send via';

  @override
  String get optional => 'Optional';

  @override
  String get aboutOllo => 'Ollo 정보';

  @override
  String get updateLog => 'Update Log';

  @override
  String get colorPalette => '색상 팔레트';

  @override
  String get colorPalettePreview => '미리보기';

  @override
  String get colorPaletteSelectTheme => '테마 선택';

  @override
  String get account => '계정';

  @override
  String get deleteData => '데이터 삭제';

  @override
  String get logout => '로그아웃';

  @override
  String get comingSoon => '준비 중';

  @override
  String get comingSoonDesc => 'AI가 거래를 분류하고 스마트한 금융 인사이트를 제공합니다.';

  @override
  String get cantWait => '기대됩니다!';

  @override
  String get deleteAllData => '모든 데이터 삭제?';

  @override
  String deleteAllDataConfirm(String confirmationText) {
    return '이 작업을 수행하면 모든 거래, 지갑, 예산 및 메모가 영구적으로 삭제됩니다. 이 작업은 되돌릴 수 없습니다.\n\n확인하려면 아래에 \"$confirmationText\"를 입력하세요:';
  }

  @override
  String get deleteDataConfirmationText => '데이터 삭제';

  @override
  String get dataDeletedSuccess => '모든 데이터가 성공적으로 삭제되었습니다. 앱을 다시 시작하세요.';

  @override
  String dataDeleteFailed(String error) {
    return '데이터 삭제 실패: $error';
  }

  @override
  String get currency => '통화';

  @override
  String get language => '언어';

  @override
  String get selectCurrency => '통화 선택';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get selectCategory => '카테고리 선택';

  @override
  String get myWallets => '내 지갑';

  @override
  String get emptyWalletsTitle => '지갑이 없습니다';

  @override
  String get emptyWalletsMessage => '지갑이나 은행 계좌를 추가하여 기록을 시작하세요! 💳';

  @override
  String get addWallet => '새 지갑 추가';

  @override
  String get editWallet => '지갑 편집';

  @override
  String get newWallet => '새 지갑';

  @override
  String get walletName => '지갑 이름';

  @override
  String get initialBalance => '초기 잔액';

  @override
  String get walletDetails => '지갑 상세';

  @override
  String get appearance => '디자인';

  @override
  String get icon => '아이콘';

  @override
  String get color => '색상';

  @override
  String get saveWallet => '지갑 저장';

  @override
  String get walletTypeCash => '현금';

  @override
  String get walletTypeBank => '은행 계좌';

  @override
  String get walletTypeEWallet => '전자지갑';

  @override
  String get walletTypeCreditCard => '신용카드';

  @override
  String get walletTypeExchange => '거래소 / 투자';

  @override
  String get walletTypeOther => '기타';

  @override
  String get debitCard => '직불카드';

  @override
  String get categoriesTitle => '카테고리';

  @override
  String get noCategoriesFound => '카테고리 없음';

  @override
  String get editCategory => '카테고리 편집';

  @override
  String get newCategory => '새 카테고리';

  @override
  String get categoryName => '카테고리 이름';

  @override
  String get enterCategoryName => '이름을 입력하세요';

  @override
  String get deleteCategory => '카테고리 삭제?';

  @override
  String get deleteCategoryConfirm => '이 작업은 되돌릴 수 없습니다.';

  @override
  String get save => '저장';

  @override
  String get systemCategoryTitle => '시스템 카테고리';

  @override
  String get systemCategoryMessage =>
      '이 카테고리는 시스템에서 관리하며 수동으로 편집하거나 삭제할 수 없습니다.';

  @override
  String get sysCatTransfer => '이체';

  @override
  String get sysCatTransferDesc => '지갑 간 자금 이체';

  @override
  String get sysCatRecurring => '반복';

  @override
  String get sysCatRecurringDesc => '자동 반복 거래';

  @override
  String get sysCatWishlist => '위시리스트';

  @override
  String get sysCatWishlistDesc => '위시리스트 구매 내역';

  @override
  String get sysCatBills => '청구서';

  @override
  String get sysCatBillsDesc => '청구서 납부 내역';

  @override
  String get dueDateLabel => '만기일';

  @override
  String get statusLabel => '상태';

  @override
  String get noPaymentsYet => '지불 내역 없음';

  @override
  String get sysCatDebts => '채무';

  @override
  String get sysCatDebtsDesc => '부채/대출 기록';

  @override
  String get sysCatSavings => '저축';

  @override
  String get sysCatSavingsDesc => '저축 입금/출금 내역';

  @override
  String get sysCatSmartNotes => '번들 메모';

  @override
  String get sysCatSmartNotesDesc => '스마트 번들 내역';

  @override
  String get sysCatReimburse => '지출 결의';

  @override
  String get sysCatReimburseDesc => '지출 결의 내역 추적';

  @override
  String get sysCatAdjustment => '잔액 조정';

  @override
  String get sysCatAdjustmentDesc => '수동 지갑 잔액 수정';

  @override
  String get budgetsTitle => '예산';

  @override
  String get noBudgetsYet => '예산이 없습니다';

  @override
  String get createBudget => '예산 만들기';

  @override
  String get yourBudgets => '내 예산';

  @override
  String get newBudget => '새 예산';

  @override
  String get editBudget => '예산 편집';

  @override
  String get limitAmount => '한도 금액';

  @override
  String get period => '기간';

  @override
  String get weekly => '매주';

  @override
  String get monthly => '월간';

  @override
  String get yearly => '매년';

  @override
  String get daily => '매일';

  @override
  String get deleteBudget => '예산 삭제';

  @override
  String get deleteBudgetConfirm => '이 예산을 삭제하시겠습니까?';

  @override
  String get enterAmount => '금액 입력';

  @override
  String get recurringTitle => '반복';

  @override
  String get activeSubscriptions => '활성 구독';

  @override
  String get noActiveSubscriptions => '활성 구독 없음';

  @override
  String get newRecurring => '새 반복 거래';

  @override
  String get editRecurring => '반복 거래 편집';

  @override
  String get frequency => '주기';

  @override
  String get startDate => '시작일';

  @override
  String get payWithWallet => '지불 지갑';

  @override
  String get updateRecurring => '반복 거래 업데이트';

  @override
  String get saveRecurring => '반복 거래 저장';

  @override
  String get deleteRecurring => '반복 거래 삭제?';

  @override
  String get deleteRecurringConfirm =>
      '이 작업은 향후 자동 결제를 중지합니다. 과거 거래 내역은 유지됩니다.';

  @override
  String get pleaseSelectWallet => '지갑을 선택해주세요';

  @override
  String get debtsTitle => '채무';

  @override
  String get iOwe => '내가 빌린 돈';

  @override
  String get owedToMe => '내가 빌려준 돈';

  @override
  String get netBalance => '순 잔액';

  @override
  String get debtFree => '빚이 없습니다!';

  @override
  String get noOneOwesYou => '받을 돈이 없습니다.';

  @override
  String get paidStatus => '지불됨';

  @override
  String get overdue => '연체';

  @override
  String dueOnDate(String date) {
    return '$date 만기';
  }

  @override
  String amountLeft(String amount) {
    return '$amount 남음';
  }

  @override
  String get deleteDebt => '채무 삭제?';

  @override
  String get deleteDebtConfirm => '채무 기록이 삭제됩니다.';

  @override
  String get sortByDate => '날짜순 정렬';

  @override
  String get sortByAmount => '금액순 정렬';

  @override
  String get editDebt => '채무/대출 편집';

  @override
  String get addDebt => '채무/대출 추가';

  @override
  String get iBorrowed => '빌림 (부채)';

  @override
  String get iLent => '빌려줌 (자산)';

  @override
  String get personName => '이름';

  @override
  String get whoHint => '누구?';

  @override
  String get required => '필수';

  @override
  String get updateDebt => '채무 업데이트';

  @override
  String get saveDebt => '채무 저장';

  @override
  String get debtSaved => '채무가 저장되었습니다';

  @override
  String get debtUpdated => '채무가 업데이트되었습니다';

  @override
  String get debtDeleted => '채무 삭제됨';

  @override
  String get debtDetails => '채무 상세';

  @override
  String get paymentHistory => '지불 내역';

  @override
  String youOweName(String name) {
    return '$name님에게 빌림';
  }

  @override
  String nameOwesYou(String name) {
    return '$name님이 빌려감';
  }

  @override
  String totalAmount(String amount) {
    return '합계: $amount';
  }

  @override
  String paidAmount(String amount) {
    return '지불됨: $amount';
  }

  @override
  String get activeStatus => '활성';

  @override
  String get addPayment => '지불 추가';

  @override
  String get noneRecordOnly => '없음 (기록만)';

  @override
  String get confirmPayment => '지불 확인';

  @override
  String get paymentRecorded => '지불이 기록되었습니다!';

  @override
  String get balanceUpdateDetected => '잔액 업데이트 감지됨';

  @override
  String get recordAsTransaction => '거래로 기록하시겠습니까?';

  @override
  String recordAsTransactionDesc(String amount) {
    return '잔액이 $amount만큼 변경되었습니다. 이 차액을 거래로 기록하시겠습니까?';
  }

  @override
  String get adjustmentTitle => '잔액 조정';

  @override
  String get skip => '아니요, 조정만 함';

  @override
  String get record => '네, 기록함';

  @override
  String get updateBalance => '잔액 업데이트';

  @override
  String get newBalance => '새 잔액';

  @override
  String get deleteWalletTitle => '지갑 삭제?';

  @override
  String deleteWalletConfirm(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';
  }

  @override
  String get deleteDebtWarning => '이 작업은 채무 기록을 삭제합니다. 지갑 잔액은 자동으로 복구되지 않습니다.';

  @override
  String get billsTitle => '청구서';

  @override
  String get unpaid => '미납';

  @override
  String get paidTab => '납부됨';

  @override
  String get allCaughtUp => '모두 완료되었습니다!';

  @override
  String get noUnpaidBills => '미납된 청구서가 없습니다.';

  @override
  String get noHistoryYet => '기록 없음';

  @override
  String paidOnDate(String date) {
    return '$date에 지불됨';
  }

  @override
  String get dueToday => '오늘 마감';

  @override
  String dueInDays(int days) {
    return '$days일 후 마감';
  }

  @override
  String get pay => '지불';

  @override
  String get payBill => '청구서 지불';

  @override
  String payBillTitle(String title) {
    return '\"$title\" 지불?';
  }

  @override
  String get payFrom => '지불 출처:';

  @override
  String get noWalletsFound => '지갑 없음';

  @override
  String get billPaidSuccess => '청구서 지불 완료!';

  @override
  String get editBill => '청구서 편집';

  @override
  String get addBill => '청구서 추가';

  @override
  String get billDetails => '청구서 상세';

  @override
  String get billName => '청구서 이름';

  @override
  String get billType => '청구서 유형';

  @override
  String get selectBillType => 'Select Bill Type';

  @override
  String get repeatBill => '이 청구서 반복?';

  @override
  String get autoCreateBill => '새 청구서 자동 생성';

  @override
  String get updateBill => '청구서 업데이트';

  @override
  String get saveBill => '청구서 저장';

  @override
  String get billSaved => '청구서 저장됨';

  @override
  String get billUpdated => '청구서 업데이트됨';

  @override
  String get billDeleted => '청구서 삭제됨';

  @override
  String get payBillDescription => '시스템 거래가 생성되고 지갑에서 차감됩니다.';

  @override
  String get deleteBill => '청구서 삭제?';

  @override
  String get deleteBillConfirm => '이 작업은 되돌릴 수 없습니다.';

  @override
  String get errorInvalidBill => '올바른 제목과 금액을 입력하세요';

  @override
  String get wishlistTitle => '위시리스트';

  @override
  String get activeTab => '진행 중';

  @override
  String get achievedTab => '달성됨';

  @override
  String get emptyActiveWishlistMessage => '구매하고 싶은 아이템을 추가하세요';

  @override
  String get emptyAchievedWishlistMessage => '아직 달성한 꿈이 없습니다. 계속 노력하세요!';

  @override
  String get noAchievementsYet => '달성 기록 없음';

  @override
  String get wishlistEmpty => '위시리스트가 비어 있습니다';

  @override
  String get deleteItemTitle => '아이템 삭제?';

  @override
  String deleteItemConfirm(String title) {
    return '\"$title\"을(를) 삭제하시겠습니까?';
  }

  @override
  String get buy => '구매';

  @override
  String get buyItemTitle => '아이템 구매';

  @override
  String purchaseItemTitle(String title) {
    return '\"$title\" 구매?';
  }

  @override
  String get selectWalletLabel => '지갑 선택:';

  @override
  String get noWalletsFoundMessage => '지갑이 없습니다. 먼저 지갑을 생성하세요.';

  @override
  String get amountLabel => '금액:';

  @override
  String get confirmPurchase => '구매 확인';

  @override
  String get purchaseSuccessMessage => '구매 성공! 꿈을 이뤘습니다! 🎉';

  @override
  String errorLaunchingUrl(String error) {
    return 'URL 실행 오류: $error';
  }

  @override
  String get editWishlist => '위시리스트 편집';

  @override
  String get addWishlist => '위시리스트 추가';

  @override
  String get addPhoto => '사진 추가';

  @override
  String get itemName => '아이템 이름';

  @override
  String get itemNameHint => '예: 새 노트북';

  @override
  String get priceLabel => '가격';

  @override
  String get targetDateLabel => '목표 날짜';

  @override
  String get selectDate => '날짜 선택';

  @override
  String get productLinkLabel => '상품 링크 (선택)';

  @override
  String get productLinkHint => '예: https://coupang.com/...';

  @override
  String get updateWishlist => '위시리스트 업데이트';

  @override
  String get saveWishlist => '위시리스트 저장';

  @override
  String get errorInvalidWishlist => '올바른 제목과 가격을 입력하세요';

  @override
  String get wishlistUpdated => '위시리스트 업데이트됨';

  @override
  String get wishlistSaved => '아이템이 위시리스트에 추가되었습니다!';

  @override
  String get deleteWishlistTitle => '위시리스트 삭제?';

  @override
  String get deleteWishlistConfirm => '이 작업은 되돌릴 수 없습니다.';

  @override
  String get wishlistDeleted => '위시리스트 삭제됨';

  @override
  String errorPickingImage(String error) {
    return '이미지 선택 오류: $error';
  }

  @override
  String get smartNotesTitle => '내 번들';

  @override
  String get emptySmartNotesMessage => '첫 번째 번들을 만드세요!';

  @override
  String get historyTitle => '기록';

  @override
  String errorMessage(String error) {
    return '오류: $error';
  }

  @override
  String get addSmartNote => '새 번들';

  @override
  String get noItemsInBundle => '번들에 아이템이 없습니다';

  @override
  String payAmount(String amount) {
    return '$amount 결제';
  }

  @override
  String get paidAndCompleted => '결제 및 완료';

  @override
  String get undoPay => '결제 취소';

  @override
  String get deleteSmartNoteTitle => '번들 삭제?';

  @override
  String confirmPaymentMessage(String amount) {
    return '$amount 거래를 생성하시겠습니까?';
  }

  @override
  String get paymentSuccess => '결제 및 완료됨!';

  @override
  String get undoPaymentTitle => '결제 취소?';

  @override
  String get undoPaymentConfirm => '거래를 삭제하고 지갑을 환불하며 번들을 다시 엽니다.';

  @override
  String get undoAndReopen => '취소 및 다시 열기';

  @override
  String get purchaseReopened => '구매 다시 열림';

  @override
  String get editSmartNote => '번들 편집';

  @override
  String get newSmartNote => '새 번들';

  @override
  String get smartNoteName => '번들 이름';

  @override
  String get smartNoteNameHint => '예: 월간 식료품';

  @override
  String get itemsList => '아이템 목록';

  @override
  String get addItem => '아이템 추가';

  @override
  String get requiredShort => '필수';

  @override
  String get additionalNotes => '추가 메모';

  @override
  String get totalEstimate => '총 예상 금액';

  @override
  String get saveBundle => '번들 저장';

  @override
  String get checkedTotal => '선택된 합계:';

  @override
  String get completed => '완료됨';

  @override
  String get payAndFinish => '결제 및 종료';

  @override
  String get payingWith => '결제 수단';

  @override
  String get noItemsChecked => '결제할 아이템이 선택되지 않았습니다!';

  @override
  String get smartNoteTransactionRecorded => '거래 기록 및 번들 완료됨!';

  @override
  String get totalDreamValue => '총 꿈의 가치';

  @override
  String activeWishesCount(int count) {
    return '$count개 소망';
  }

  @override
  String achievedDreamsCount(int count) {
    return '$count개의 꿈 달성! 🎉';
  }

  @override
  String get billDataNotFound => '청구서 데이터를 찾을 수 없습니다';

  @override
  String get wishlistDataNotFound => '위시리스트 데이터를 찾을 수 없습니다';

  @override
  String get editReimbursementNotSupported => '지출 결의 편집은 아직 완벽하게 지원되지 않습니다';

  @override
  String get transactions => '거래';

  @override
  String get noTransactionsFound => '거래를 찾을 수 없습니다';

  @override
  String get noTransactionsInCategory => '이 카테고리에 거래가 없습니다';

  @override
  String get noDataForPeriod => '이 기간에 대한 데이터가 없습니다';

  @override
  String get monthlyOverview => '월간 개요';

  @override
  String get unlockPremiumStats => '프리미엄 통계 잠금 해제';

  @override
  String get totalBalance => '총 잔액';

  @override
  String get dailyBudget => '일일 예산';

  @override
  String get weeklyBudget => '주간 예산';

  @override
  String get monthlyBudget => '월간 예산';

  @override
  String get yearlyBudget => '연간 예산';

  @override
  String get wishlistPurchase => '위시리스트 구매';

  @override
  String get billPayment => '청구서 납부';

  @override
  String get debtTransaction => '채무 거래';

  @override
  String get savingsTransaction => '저축 거래';

  @override
  String get transferTransaction => '이체';

  @override
  String get transferFee => '이체 수수료';

  @override
  String get transferFeeHint => '수수료 (선택)';

  @override
  String get importData => '데이터 가져오기';

  @override
  String get importDataTitle => '거래 가져오기';

  @override
  String get downloadTemplate => '템플릿 다운로드';

  @override
  String get uploadCsv => 'CSV 업로드';

  @override
  String importSuccess(Object count) {
    return '$count개의 거래를 성공적으로 가져왔습니다!';
  }

  @override
  String importPartialSuccess(Object success, Object failed) {
    return '$success건 가져오기 성공. 실패: $failed건.';
  }

  @override
  String get templateSaved => '템플릿이 다운로드 폴더에 저장되었습니다';

  @override
  String get importInfoText =>
      '데이터를 올바르게 가져오려면 템플릿을 사용하세요. 열 이름이 정확히 일치해야 합니다.';

  @override
  String get pressBackAgainToExit => '뒤로 버튼을 한 번 더 누르면 종료됩니다';

  @override
  String get quickRecord => '빠른 기록';

  @override
  String get chatAction => '채팅';

  @override
  String get scanAction => '스캔';

  @override
  String get voiceAction => '음성';

  @override
  String get filterDay => '일';

  @override
  String get filterWeek => '주';

  @override
  String get filterMonth => '월';

  @override
  String get filterYear => '년';

  @override
  String get filterAll => '전체';

  @override
  String get editTransaction => '거래 편집';

  @override
  String get addTransaction => '거래 추가';

  @override
  String get titleLabel => '제목';

  @override
  String get enterDescriptionHint => '설명 입력';

  @override
  String get enterTitleHint => '제목 입력 (예: 아침 식사)';

  @override
  String get enterValidAmount => '올바른 금액을 입력하세요';

  @override
  String get selectWalletError => '지갑을 선택해주세요';

  @override
  String get selectDestinationWalletError => '보낼 지갑을 선택해주세요';

  @override
  String get selectCategoryError => '카테고리를 선택해주세요';

  @override
  String get saveTransaction => '거래 저장';

  @override
  String get loading => '로딩 중...';

  @override
  String error(String error) {
    return '오류: $error';
  }

  @override
  String get expenseDetails => '지출 상세';

  @override
  String get incomeDetails => '수입 상세';

  @override
  String get noExpensesFound => '지출 내역 없음';

  @override
  String get noIncomeFound => '수입 내역 없음';

  @override
  String get forThisDate => '해당 날짜';

  @override
  String get timeFilterToday => '오늘';

  @override
  String get timeFilterThisWeek => '이번 주';

  @override
  String get timeFilterThisMonth => '이번 달';

  @override
  String get timeFilterThisYear => '올해';

  @override
  String get timeFilterAllTime => '전체 기간';

  @override
  String get dailyOverview => '일일 개요';

  @override
  String get dailyAverage => '일일 평균';

  @override
  String get projectedTotal => '예상 합계';

  @override
  String get spendingHabitsNote => '이번 달 소비 습관을 기반으로 합니다.';

  @override
  String get monthlyComparison => '월간 비교';

  @override
  String get spendingLessNote => '지난달보다 적게 쓰고 있습니다!';

  @override
  String get spendingMoreNote => '평소보다 지출이 많습니다.';

  @override
  String get topSpenders => '최고 지출';

  @override
  String transactionsCount(int count) {
    return '$count건의 거래';
  }

  @override
  String get activityHeatmap => '활동 히트맵';

  @override
  String get less => '적음';

  @override
  String get more => '많음';

  @override
  String get backupRecoveryTitle => '백업 & 복구';

  @override
  String get backupDescription =>
      '로컬 백업 파일(JSON)을 생성하여 데이터를 안전하게 보호하세요. 나중에 또는 다른 기기에서 복원할 수 있습니다.';

  @override
  String get popularBanks => '인기 은행';

  @override
  String get eWallets => '전자지갑';

  @override
  String get bankEWalletLogos => '은행 & 전자지갑 로고';

  @override
  String get genericIcons => '일반 아이콘';

  @override
  String get changeIcon => '아이콘 변경';

  @override
  String get typeLabel => '유형';

  @override
  String get createBackup => '백업 생성';

  @override
  String get restoreBackup => '백업 복원';

  @override
  String get createBackupSubtitle => '모든 데이터를 JSON 파일로 내보내기';

  @override
  String get restoreBackupSubtitle => 'JSON 파일에서 데이터 가져오기 (현재 데이터 삭제됨)';

  @override
  String get creatingBackup => '백업 생성 중...';

  @override
  String get restoringBackup => '백업 복원 중...';

  @override
  String get preferences => '환경설정';

  @override
  String get weeklyActivityHeatmap => '주간 활동';

  @override
  String backupSuccess(String path) {
    return '백업이 다음 위치에 저장되었습니다:\n$path';
  }

  @override
  String get restoreSuccess =>
      '백업이 성공적으로 복원되었습니다!\n데이터가 즉시 표시되지 않으면 앱을 다시 시작하세요.';

  @override
  String backupError(String error) {
    return '백업 생성 실패: $error';
  }

  @override
  String restoreError(String error) {
    return '백업 복원 실패: $error';
  }

  @override
  String get restoreWarningTitle => '⚠️ 경고: 데이터 복원';

  @override
  String get restoreWarningMessage =>
      '백업을 복원하면 이 기기의 현재 모든 데이터가 삭제되고 백업 내용으로 대체됩니다.\n\n이 작업은 되돌릴 수 없습니다. 계속하시겠습니까?';

  @override
  String get yesRestore => '네, 복원합니다';

  @override
  String get exportDataTitle => '데이터 내보내기';

  @override
  String get dateRange => '날짜 범위';

  @override
  String get transactionType => '거래 유형';

  @override
  String get allWallets => '모든 지갑';

  @override
  String get allCategories => '모든 카테고리';

  @override
  String shareCsv(int count) {
    return 'CSV 공유 ($count개 항목)';
  }

  @override
  String get saveToDownloads => '다운로드 폴더에 저장';

  @override
  String get calculating => '계산 중...';

  @override
  String get noTransactionsMatch => '선택한 필터와 일치하는 거래가 없습니다.';

  @override
  String exportFailed(String error) {
    return '내보내기 실패: $error';
  }

  @override
  String saveFailed(String error) {
    return '저장 실패: $error';
  }

  @override
  String fileSavedTo(String path) {
    return '파일이 저장된 위치: $path';
  }

  @override
  String get lastMonth => '지난달';

  @override
  String get sendFeedbackTitle => '피드백 보내기';

  @override
  String get weValueYourVoice => '여러분의 의견을 소중하게 생각합니다';

  @override
  String get feedbackDescription =>
      '새로운 기능 아이디어가 있나요? 버그를 찾으셨나요? 아니면 그냥 인사하고 싶으신가요? 저희는 들을 준비가 되어 있습니다! 여러분의 피드백은 Ollo의 발전에 큰 힘이 됩니다.';

  @override
  String get chatViaWhatsApp => 'WhatsApp으로 채팅';

  @override
  String get repliesInHours => '보통 몇 시간 내에 응답합니다';

  @override
  String subCategoriesCount(int count) {
    return '$count개 하위 카테고리';
  }

  @override
  String get unnamed => '이름 없음';

  @override
  String get ok => '확인';

  @override
  String errorPrefix(String error) {
    return '오류: $error';
  }

  @override
  String get whatsappMessage => '안녕하세요 Ollo 팀, 피드백을 보내고 싶습니다...';

  @override
  String get roadmapTitle => '제품 로드맵';

  @override
  String get roadmapInProgress => '진행 중';

  @override
  String get roadmapPlanned => '계획됨';

  @override
  String get roadmapCompleted => '완료됨';

  @override
  String get roadmapHighPriority => '높은 우선순위';

  @override
  String get roadmapBeta => '베타';

  @override
  String get roadmapDev => '개발';

  @override
  String get featureCloudBackupTitle => '클라우드 백업 (Google Drive)';

  @override
  String get featureCloudBackupDesc => '데이터를 개인 Google Drive에 안전하게 동기화하세요.';

  @override
  String get featureAiInsightsTitle => '고급 AI 인사이트';

  @override
  String get featureAiInsightsDesc => '개인 맞춤형 팁과 함께 소비 습관을 심층 분석합니다.';

  @override
  String get featureDataExportTitle => 'CSV/Excel로 데이터 내보내기';

  @override
  String get featureDataExportDesc =>
      'Excel 또는 Sheets에서 외부 분석을 위해 거래 내역을 내보냅니다.';

  @override
  String get featureBudgetForecastingTitle => '예산 예측';

  @override
  String get featureBudgetForecastingDesc => '과거 데이터를 기반으로 다음 달 지출을 예측합니다.';

  @override
  String get featureMultiCurrencyTitle => '다중 통화 지원';

  @override
  String get featureMultiCurrencyDesc => '국제 거래를 위한 실시간 환율 변환.';

  @override
  String get featureReceiptScanningTitle => '영수증 스캔 OCR';

  @override
  String get featureReceiptScanningDesc => '영수증을 스캔하여 거래 세부 정보를 자동으로 입력합니다.';

  @override
  String get featureLocalBackupTitle => '전체 로컬 백업';

  @override
  String get featureLocalBackupDesc => '모든 앱 데이터(거래, 지갑, 메모 등)를 로컬 파일로 백업합니다.';

  @override
  String get featureSmartNotesTitle => '스마트 메모';

  @override
  String get featureSmartNotesDesc => '체크리스트와 합계 계산이 포함된 쇼핑 목록.';

  @override
  String get featureRecurringTitle => '반복 거래';

  @override
  String get featureRecurringDesc => '청구서 및 급여 입력을 자동화합니다.';

  @override
  String get aboutTitle => 'Ollo 정보';

  @override
  String get aboutPhilosophyTitle => '당신의 금융 동반자';

  @override
  String get aboutPhilosophyDesc =>
      'Ollo는 재정 관리가 복잡하지 않아야 한다는 믿음에서 탄생했습니다. 저희는 당신이 금융 목표를 하나씩 달성할 수 있도록 돕는 스마트하고 친근한 금융 동반자를 만들고자 합니다.';

  @override
  String get connectWithUs => '문의하기';

  @override
  String version(String version) {
    return '버전 $version';
  }

  @override
  String get helpTitle => '도움말 & 지원';

  @override
  String get helpIntroTitle => '무엇을 도와드릴까요?';

  @override
  String get helpIntroDesc => '자주 묻는 질문에 대한 답변을 찾거나 지원 팀에 직접 문의하세요.';

  @override
  String get faqTitle => '자주 묻는 질문 (FAQ)';

  @override
  String get faqAddWalletQuestion => '새 지갑을 어떻게 추가하나요?';

  @override
  String get faqAddWalletAnswer =>
      '\"지갑\" 메뉴로 이동하여 오른쪽 상단 모서리의 \"+\" 버튼을 누르세요. 지갑 유형(현금, 은행 등)을 선택하고 이름과 초기 잔액을 입력한 다음 저장하세요.';

  @override
  String get faqExportDataQuestion => '내 데이터를 내보낼 수 있나요?';

  @override
  String get faqExportDataAnswer =>
      '데이터 내보내기는 곧 제공될 프리미엄 기능입니다. 거래 내역을 CSV 또는 Excel 형식으로 내보낼 수 있게 됩니다.';

  @override
  String get faqResetDataQuestion => '데이터를 어떻게 초기화하나요?';

  @override
  String get faqResetDataAnswer =>
      '현재, 개별 거래나 지갑을 삭제할 수 있습니다. 전체 공장 초기화 옵션은 향후 업데이트의 설정 메뉴에서 제공될 예정입니다.';

  @override
  String get faqSecureDataQuestion => '내 데이터는 안전한가요?';

  @override
  String get faqSecureDataAnswer =>
      '네, 모든 데이터는 기기에 로컬로 저장됩니다. 저희는 귀하의 개인 금융 데이터를 외부 서버에 업로드하지 않습니다.';

  @override
  String get faqQuickRecordQuestion => 'What is Quick Record?';

  @override
  String get faqQuickRecordAnswer =>
      'The fastest way to track! Use the Widget or Notification Tile, then say \"Lunch 20k using Cash\" or scan a receipt.';

  @override
  String get faqWidgetQuestion => 'How to add Widgets?';

  @override
  String get faqWidgetAnswer =>
      'Long press home screen > Widgets > Find \"Ollo\". Available: Budget Widget (4x1), Daily Graph, and Quick Access.';

  @override
  String get contactSupport => '지원 팀 문의';

  @override
  String get reimbursementTitle => '지출 결의';

  @override
  String get reimbursementPending => '대기 중';

  @override
  String get reimbursementCompleted => '완료됨';

  @override
  String get noPendingReimbursements => '대기 중인 지출 결의 없음';

  @override
  String get noCompletedReimbursements => '완료된 지출 결의 없음';

  @override
  String get markPaid => '지불 완료로 표시';

  @override
  String get totalSavings => '총 저축';

  @override
  String get financialBuckets => '금융 버킷';

  @override
  String get noSavingsYet => '저축 없음';

  @override
  String growthThisMonth(String percent) {
    return '이번 달 $percent% 성장';
  }

  @override
  String get myCards => '내 카드';

  @override
  String selectedCount(int count) {
    return '$count개 선택됨';
  }

  @override
  String get copyNumber => '번호 복사';

  @override
  String get copyTemplate => '템플릿 복사';

  @override
  String cardsCopied(int count) {
    return '$count개 카드 복사됨!';
  }

  @override
  String get cardNumberCopied => '카드 번호가 복사되었습니다!';

  @override
  String get cardTemplateCopied => '카드 템플릿이 복사되었습니다!';

  @override
  String get noCardsYet => '카드가 없습니다';

  @override
  String get addCardsMessage => '은행 계좌 또는 전자지갑을 추가하세요';

  @override
  String get premiumTitle => '잠재력 잠금 해제';

  @override
  String get premiumSubtitle => '고급 기능과 무제한 액세스를 위해 프리미엄으로 업그레이드하세요.';

  @override
  String get premiumAdvancedStats => '고급 통계';

  @override
  String get premiumAdvancedStatsDesc => '대화형 차트 & 심층 분석';

  @override
  String get premiumDataExport => '데이터 내보내기';

  @override
  String get premiumDataExportDesc => '백업을 위해 CSV/Excel로 내보내기';

  @override
  String get premiumUnlimitedWallets => '무제한 지갑';

  @override
  String get premiumUnlimitedWalletsDesc => '필요한 만큼 지갑을 생성하세요';

  @override
  String get premiumSmartAlerts => '스마트 알림';

  @override
  String get premiumSmartAlertsDesc => '과소비하기 전에 알림 받기';

  @override
  String get upgradeButton => '지금 업그레이드 - Rp 29.000 / 평생';

  @override
  String get restorePurchase => '구매 복원';

  @override
  String get youArePremium => '프리미엄 회원입니다!';

  @override
  String get premiumWelcome => '프리미엄에 오신 것을 환영합니다! 🌟';

  @override
  String get contactSupportMessage => '안녕하세요 Ollo 지원 팀, 도움이 필요합니다...';

  @override
  String get category_food => '식비';

  @override
  String get category_transport => '교통';

  @override
  String get category_shopping => '쇼핑';

  @override
  String get category_housing => '주거';

  @override
  String get category_entertainment => '문화/여가';

  @override
  String get category_health => '건강';

  @override
  String get category_education => '교육';

  @override
  String get category_personal => '개인';

  @override
  String get category_financial => '금융';

  @override
  String get category_family => '가족';

  @override
  String get category_friend => '친구';

  @override
  String get category_salary => '여';

  @override
  String get category_business => '사업';

  @override
  String get category_investments => '투자';

  @override
  String get category_gifts_income => '선물';

  @override
  String get category_other_income => '기타';

  @override
  String get subcategory_breakfast => '아침';

  @override
  String get subcategory_lunch => '점심';

  @override
  String get subcategory_dinner => '저녁';

  @override
  String get subcategory_eateries => '외식';

  @override
  String get subcategory_snacks => '간식';

  @override
  String get subcategory_drinks => '음료';

  @override
  String get subcategory_groceries => '식료품';

  @override
  String get subcategory_delivery => '배달';

  @override
  String get subcategory_alcohol => '술/유흥';

  @override
  String get subcategory_bus => '버스';

  @override
  String get subcategory_train => '지하철/기차';

  @override
  String get subcategory_taxi => '택시';

  @override
  String get subcategory_fuel => '주유';

  @override
  String get subcategory_parking => '주차';

  @override
  String get subcategory_maintenance => '정비';

  @override
  String get subcategory_insurance_car => '보험 (차량)';

  @override
  String get subcategory_toll => '통행료';

  @override
  String get subcategory_clothes => '의류';

  @override
  String get subcategory_electronics => '전자제품';

  @override
  String get subcategory_home => '가구/인테리어';

  @override
  String get subcategory_beauty => '미용';

  @override
  String get subcategory_gifts => '선물';

  @override
  String get subcategory_software => '소프트웨어';

  @override
  String get subcategory_tools => '공구/장비';

  @override
  String get subcategory_rent => '월세';

  @override
  String get subcategory_mortgage => '대출이자';

  @override
  String get subcategory_utilities => '공과금';

  @override
  String get subcategory_internet => '인터넷';

  @override
  String get subcategory_maintenance_home => '수리/보수';

  @override
  String get subcategory_furniture => '가구';

  @override
  String get subcategory_services => '서비스';

  @override
  String get subcategory_movies => '영화';

  @override
  String get subcategory_games => '게임';

  @override
  String get subcategory_streaming => '스트리밍';

  @override
  String get subcategory_events => '공연/이벤트';

  @override
  String get subcategory_hobbies => '취미';

  @override
  String get subcategory_travel => '여행';

  @override
  String get monthlyCommitment => '고정 지출';

  @override
  String get upcomingBill => '다가오는 청구서';

  @override
  String get noUpcomingBills => '다가오는 청구서 없음';

  @override
  String get today => '오늘';

  @override
  String get tomorrow => '내일';

  @override
  String inDays(int days) {
    return '$days일 후';
  }

  @override
  String get needTwoWallets => '지갑 2개 이상 필요';

  @override
  String get nettBalance => '순 잔액';

  @override
  String get activeDebt => '활성 부채';

  @override
  String get last30Days => '최근 30일';

  @override
  String get currentBalance => '현재 잔액';

  @override
  String get premiumMember => '프리미엄 회원';

  @override
  String get upgradeToPremium => '프리미엄으로 업그레이드';

  @override
  String get unlimitedAccess => '무제한 액세스 권한이 있습니다!';

  @override
  String get unlockFeatures => '모든 기능을 잠금 해제하고 제한을 제거하세요.';

  @override
  String get from => '보내는 곳';

  @override
  String get subcategory_music => '음악';

  @override
  String get subcategory_doctor => '병원';

  @override
  String get subcategory_pharmacy => '약국';

  @override
  String get subcategory_gym => '헬스장';

  @override
  String get subcategory_insurance_health => '건강보험';

  @override
  String get subcategory_mental_health => '정신건강';

  @override
  String get subcategory_sports => '스포츠';

  @override
  String get subcategory_tuition => '등록금/학원비';

  @override
  String get subcategory_books => '교재/도서';

  @override
  String get subcategory_courses => '온라인 강의';

  @override
  String get subcategory_supplies => '학용품';

  @override
  String get subcategory_haircut => '헤어';

  @override
  String get subcategory_spa => '스파/마사지';

  @override
  String get subcategory_cosmetics => '화장품';

  @override
  String get subcategory_taxes => '세금';

  @override
  String get subcategory_fees => '수수료';

  @override
  String get subcategory_fines => '벌금';

  @override
  String get subcategory_insurance_life => '생명보험';

  @override
  String get subcategory_childcare => '육아';

  @override
  String get subcategory_toys => '장난감';

  @override
  String get subcategory_school_kids => '학교';

  @override
  String get subcategory_pets => '반려동물';

  @override
  String get subcategory_transfer_friend => '송금';

  @override
  String get subcategory_treat => '한턱';

  @override
  String get subcategory_refund_friend => '환불';

  @override
  String get subcategory_loan_friend => '대출';

  @override
  String get subcategory_gift_friend => '선물';

  @override
  String get subcategory_monthly => '월급';

  @override
  String get subcategory_weekly => '주급';

  @override
  String get subcategory_bonus => '보너스';

  @override
  String get subcategory_overtime => '초과근무수당';

  @override
  String get subcategory_sales => '판매 수익';

  @override
  String get subcategory_profit => '사업 이익';

  @override
  String get subcategory_dividends => '배당금';

  @override
  String get subcategory_interest => '이자';

  @override
  String get subcategory_crypto => '암호화폐';

  @override
  String get subcategory_stocks => '주식';

  @override
  String get subcategory_real_estate => '부동산';

  @override
  String get subcategory_birthday => '생일';

  @override
  String get subcategory_holiday => '명절 용돈';

  @override
  String get subcategory_allowance => '용돈';

  @override
  String get subcategory_refunds => '환불';

  @override
  String get subcategory_grants => '지원금';

  @override
  String get subcategory_lottery => '복권';

  @override
  String get subcategory_selling => '중고 판매';

  @override
  String get editProfileTitle => '프로필 편집';

  @override
  String get nameLabel => '이름';

  @override
  String get emailLabel => '이메일 (선택)';

  @override
  String get uploadPhoto => '사진 업로드';

  @override
  String get saveChanges => '변경사항 저장';

  @override
  String get listeningMessage => 'Ollo AI가 듣고 있습니다...';

  @override
  String get quickRecordTitle => '빠른 기록';

  @override
  String get saySomethingHint => '\'점심 5000원\' 이라고 말해보세요...';

  @override
  String get stopAndProcess => '중지 및 처리';

  @override
  String get textInputHint => '예: \"점심 8000원\", \"월급 300만원\"';

  @override
  String get draftReady => '초안 준비 완료';

  @override
  String get saveAdjust => '저장 및 수정';

  @override
  String get notFound => '결과 없음';

  @override
  String get selectWallet => '지갑 선택';

  @override
  String get exitAppTitle => '앱 종료';

  @override
  String get exitAppConfirm => '앱을 종료하시겠습니까?';

  @override
  String get onboardingSavingsTitle => '저축';

  @override
  String get onboardingSavingsSubtitle => '자산을 늘리세요';

  @override
  String get onboardingSavingsDesc =>
      '돈이 어디로 가는지 추적하고 불필요한 지출을 줄여 더 효과적으로 저축을 시작하세요.';

  @override
  String get onboardingStatsTitle => '통계';

  @override
  String get onboardingStatsSubtitle => '깊은 통찰력';

  @override
  String get onboardingStatsDesc =>
      '더 현명한 재정 결정을 내리기 위해 상세한 보고서로 수입 및 지출 추세를 분석하세요.';

  @override
  String get onboardingMgmtTitle => '관리';

  @override
  String get onboardingMgmtSubtitle => '완벽한 통제';

  @override
  String get onboardingMgmtDesc => '모든 지갑, 계좌 및 예산을 간단하고 직관적인 한 곳에서 관리하세요.';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingGetStarted => '시작하기';

  @override
  String get onboardingLanguageDesc => '애플리케이션 인터페이스의 선호 언어를 선택하세요.';

  @override
  String get onboardingVoiceTitle => '음성 명령';

  @override
  String get onboardingVoiceDesc => '음성 명령 및 빠른 기록에 사용할 언어를 선택하세요.';

  @override
  String get onboardingNotifTitle => '스마트 알림';

  @override
  String get onboardingNotifDesc => '매일 알림을 활성화하여 기록 연속성을 유지하세요.';

  @override
  String get onboardingProfileTitle => '프로필';

  @override
  String get onboardingProfileDesc => '본인에 대해 조금 알려주세요. 이 정보는 프로필에 표시됩니다.';

  @override
  String get onboardingWalletTitle => '첫 번째 지갑';

  @override
  String get onboardingWalletDesc => '주 현금 지갑을 설정합시다. 현재 보유 현금을 입력하세요.';

  @override
  String get onboardingDailyReminders => '일일 알림';

  @override
  String get onboardingRemindersSubtitle => '지출 기록을 위한 유용한 알림을 받으세요.';

  @override
  String get onboardingFullname => '전체 이름';

  @override
  String get onboardingNameHint => '예: 홍길동';

  @override
  String get onboardingEmail => '이메일 (선택 사항)';

  @override
  String get onboardingEmailHint => 'user@example.com';

  @override
  String get onboardingBalanceHint => '예: 500000';

  @override
  String get onboardingWalletGuide =>
      '나중에 지갑 메뉴에서 더 많은 지갑(은행, 전자 지갑)을 추가할 수 있습니다.';

  @override
  String get badgeFirstStepTitle => '첫 걸음';

  @override
  String get badgeFirstStepDesc => '첫 거래 기록하기';

  @override
  String get badgeWeekWarriorTitle => '7일 연속';

  @override
  String get badgeWeekWarriorDesc => '7일 연속으로 지출 추적하기';

  @override
  String get badgeConsistentSaverTitle => '규율';

  @override
  String get badgeConsistentSaverDesc => '총 30일 동안 추적하기';

  @override
  String get badgeBigSpenderTitle => '큰 손';

  @override
  String get badgeBigSpenderDesc => '100건 이상의 거래 기록하기';

  @override
  String get badgeSaverTitle => '저축가';

  @override
  String get badgeSaverDesc => '지출보다 수입이 많음';

  @override
  String get badgeNightOwlTitle => '올빼미';

  @override
  String get badgeNightOwlDesc => '오후 10시 이후에 거래 기록하기';

  @override
  String get badgeEarlyBirdTitle => '얼리 버드';

  @override
  String get badgeEarlyBirdDesc => '오전 5시 - 오전 8시 사이에 거래 기록하기';

  @override
  String get badgeWeekendWarriorTitle => '주말';

  @override
  String get badgeWeekendWarriorDesc => '토요일 또는 일요일에 거래 기록하기';

  @override
  String get badgeWealthTitle => '부';

  @override
  String get badgeWealthDesc => '10,000,000 이상의 거래량 축적';

  @override
  String get level => '레벨';

  @override
  String get currentStreak => '현재 연속';

  @override
  String get totalActive => '총 활동';

  @override
  String get achievements => '업적';

  @override
  String get days => '일';

  @override
  String get levelNovice => '초보 저축가';

  @override
  String get levelConsistent => '꾸준한 저축가';

  @override
  String get levelEnthusiast => '금융 애호가';

  @override
  String get badgeFirstLogTitle => '첫 로그';

  @override
  String get badgeFirstLogDesc => '가장 첫 번째 거래를 기록하세요';

  @override
  String get badgeStreak3Title => '워밍업';

  @override
  String get badgeStreak3Desc => '3일 일일 연속';

  @override
  String get badgeStreak7Title => '불타오르는 중';

  @override
  String get badgeStreak7Desc => '7일 일일 연속';

  @override
  String get badgeStreak14Title => '거침없는';

  @override
  String get badgeStreak14Desc => '14일 일일 연속';

  @override
  String get badgeStreak30Title => '마스터';

  @override
  String get badgeStreak30Desc => '30일 일일 연속';

  @override
  String get badgeStreak100Title => '전설적인';

  @override
  String get badgeStreak100Desc => '100일 일일 연속';

  @override
  String get badgeWeeklyLoggerTitle => '주간 기록자';

  @override
  String get badgeWeeklyLoggerDesc => '한 달 동안 매주 최소 하나의 거래 입력';

  @override
  String get badgeFirstBudgetTitle => '첫 예산';

  @override
  String get badgeFirstBudgetDesc => '첫 예산 만들기';

  @override
  String get badgeUnderBudgetTitle => '예산 프로';

  @override
  String get badgeUnderBudgetDesc => '이번 달 예산보다 적게 지출';

  @override
  String get badgeBudgetMasterTitle => '예산 마스터';

  @override
  String get badgeBudgetMasterDesc => '3개월 연속 예산 미만 유지';

  @override
  String get badgeMultiBudgeterTitle => '전략가';

  @override
  String get badgeMultiBudgeterDesc => '3개 이상의 카테고리에 대한 예산 만들기';

  @override
  String get badgeFirstGoalTitle => '꿈꾸는 자';

  @override
  String get badgeFirstGoalDesc => '첫 저축 목표 만들기';

  @override
  String get badgeGoalCompletedTitle => '성취자';

  @override
  String get badgeGoalCompletedDesc => '저축 목표 달성 (100%)';

  @override
  String get badgeGoalSprintTitle => '스프린터';

  @override
  String get badgeGoalSprintDesc => '마감일 전에 저축 목표 달성';

  @override
  String get badgeMidnightCheckoutTitle => '자정 체크아웃';

  @override
  String get badgeMidnightCheckoutDesc => '자정 이후 쇼핑 (안티 배지)';

  @override
  String get badgeImpulseKingTitle => '충동 구매왕';

  @override
  String get badgeImpulseKingDesc => '하루에 5건 이상의 거래 (안티 배지)';

  @override
  String get badgeExplorerTitle => '탐험가';

  @override
  String get badgeExplorerDesc => '5개의 다른 카테고리에서 거래 기록';

  @override
  String get badgeLunchTimeTitle => '점심 시간';

  @override
  String get badgeLunchTimeDesc => '오전 11시 - 오후 1시 사이에 거래 기록';

  @override
  String get badgeBigSaverTitle => '큰 저축가';

  @override
  String get badgeBigSaverDesc => '총 수입 5,000,000 축적';

  @override
  String get badgeGiverTitle => '관대한';

  @override
  String get badgeGiverDesc => '5건 이상의 이체 거래 수행';

  @override
  String get badgeThriftyTitle => '검소한';

  @override
  String get badgeThriftyDesc => '월 지출이 수입의 50% 미만';

  @override
  String get badgeWeekendBingeTitle => '주말 폭주';

  @override
  String get badgeWeekendBingeDesc => '주말에 5건 이상의 거래 수행';

  @override
  String get levelRookie => '루키';

  @override
  String get levelBudgetWarrior => '예산 전사';

  @override
  String get levelMoneyNinja => '머니 닌자';

  @override
  String get levelFinanceSensei => '금융 센세이';

  @override
  String get levelWealthTycoon => '부의 거물';

  @override
  String get badgeSectionConsistency => '일관성 및 연속';

  @override
  String get badgeSectionBudget => '예산 관리';

  @override
  String get badgeSectionSaving => '저축 목표';

  @override
  String get badgeSectionMisc => '재미 및 기타';

  @override
  String get gamificationSettingsTitle => 'Gamification Settings';

  @override
  String get settingsShowDashboardLevel => 'Show Level on Dashboard';

  @override
  String get settingsShowDashboardLevelDesc =>
      'Display your level progress on the home screen';

  @override
  String get settingsSpoilerMode => 'Spoiler Mode';

  @override
  String get settingsSpoilerModeDesc => 'Hide details of locked badges';

  @override
  String get settingsAchievementNotifications => 'Achievement Notifications';

  @override
  String get settingsAchievementNotificationsDesc =>
      'Show popup when a new badge is unlocked';

  @override
  String get notificationNewBadgeUnlocked => 'New Badge Unlocked!';

  @override
  String get notificationCongratulations => 'Congratulations!';

  @override
  String notificationYouEarnedXP(int amount) {
    return 'You earned $amount XP';
  }

  @override
  String get notificationAwesome => 'Awesome';

  @override
  String get seeAll => 'See All';

  @override
  String get selectIcon => 'Select Icon';

  @override
  String get type => 'Type';

  @override
  String get editSubCategory => 'Edit Sub-Category';

  @override
  String get newSubCategory => 'New Sub-Category';

  @override
  String get name => 'Name';

  @override
  String get subCategoryHint => 'e.g. Breakfast';

  @override
  String get subCategories => 'Sub-Categories';

  @override
  String get add => 'Add';

  @override
  String get noSubCategories => 'No sub-categories';

  @override
  String get vipMember => 'VIP 회원';

  @override
  String get freeMember => '무료 회원';

  @override
  String get premiumFeatures => '프리미엄 기능';

  @override
  String get chooseYourPlan => '요금제 선택';

  @override
  String get restorePurchases => '구매 복원';

  @override
  String get haveVipCode => 'VIP 코드가 있으신가요?';

  @override
  String get enterVipCode => 'VIP 코드 입력';

  @override
  String get enterYourCode => '코드를 입력하세요';

  @override
  String get redeem => '사용하기';

  @override
  String get welcomeToPremium => '프리미엄에 오신 것을 환영합니다!';

  @override
  String get thankYouForSupport => '지원해 주셔서 감사합니다. 모든 프리미엄 기능을 즐기세요!';

  @override
  String get continue_ => '계속';

  @override
  String get purchasesRestored => '구매가 성공적으로 복원되었습니다!';

  @override
  String get noPurchasesFound => '이전 구매 내역이 없습니다.';

  @override
  String get purchaseFailed => '구매에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get welcomeToVip => 'VIP에 오신 것을 환영합니다! 🎉';

  @override
  String get invalidVipCode => '잘못된 코드입니다. 다시 시도해 주세요.';

  @override
  String currentPlan(String plan) {
    return '현재 요금제: $plan';
  }

  @override
  String get earlyAccessBenefits => '조기 액세스 및 독점 혜택';

  @override
  String get voiceQuickRecord => '음성 빠른 기록';

  @override
  String get voiceQuickRecordDesc => '음성으로 거래 추가';

  @override
  String get advancedStatistics => '고급 통계';

  @override
  String get advancedStatisticsDesc => '재정에 대한 심층 분석';

  @override
  String get dataExportDesc => 'CSV 및 Excel로 내보내기';

  @override
  String get smartScan => '스마트 스캔';

  @override
  String get smartScanDesc => '영수증 자동 스캔';

  @override
  String get premiumThemes => '프리미엄 테마';

  @override
  String get premiumThemesDesc => '독점 그라데이션 테마';

  @override
  String get unlimitedWallets => '무제한 지갑';

  @override
  String get unlimitedWalletsDesc => '지갑 수 제한 없음';

  @override
  String get vipExclusive => 'VIP 전용';

  @override
  String get earlyAccess => '조기 액세스';

  @override
  String get earlyAccessDesc => '새로운 기능을 먼저 받으세요';

  @override
  String get prioritySupport => '우선 지원';

  @override
  String get prioritySupportDesc => '버그 보고 우선 처리';

  @override
  String get betaFeatures => '베타 기능';

  @override
  String get betaFeaturesDesc => '실험적 기능 체험';

  @override
  String get sixMonths => '6개월';

  @override
  String get annual => '연간';

  @override
  String get lifetime => '평생';

  @override
  String get perMonth => '/월';

  @override
  String get per6Months => '/6개월';

  @override
  String get perYear => '/년';

  @override
  String get oneTime => '일회성';

  @override
  String get save17 => '17% 절약';

  @override
  String get save33 => '33% 절약';

  @override
  String get bestValue => '최고의 가치';

  @override
  String get forever => '영원히';

  @override
  String get freeTrialDays => '7일 무료';

  @override
  String get pro => 'PRO';

  @override
  String get premiumFeature => '프리미엄 기능';

  @override
  String get thisFeatureRequiresPremium => '이 기능은 프리미엄 구독이 필요합니다';
}
