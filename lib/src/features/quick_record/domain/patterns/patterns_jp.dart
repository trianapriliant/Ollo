import 'pattern_base.dart';

const Map<String, CategoryPattern> japanesePatterns = {
  // --- EXPENSE ---
  'Food & Drink': CategoryPattern(
    mainKeywords: ['食べ物', '飲み物', '食事', '飲食', 'ごはん', 'ご飯'],
    subCategoryKeywords: {
      'Breakfast': ['朝食', '朝ごはん', 'モーニング', 'ブレックファースト', 'パン'],
      'Lunch': ['昼食', 'ランチ', 'お昼', '昼ごはん', '弁当', 'お弁当'],
      'Dinner': ['夕食', '晩ごはん', 'ディナー', '夜ご飯', '晩酌'],
      'Eateries': [
        'レストラン', '食堂', 'カフェ', '居酒屋', 'ファミレス', 'マクドナルド', 'ケンタッキー',
        'ラーメン', 'うどん', 'そば', '寿司', '焼肉', '吉野家', 'すき家'
      ],
      'Snacks': ['おやつ', 'スナック', 'お菓子', 'デザート', 'アイス', 'ケーキ', 'チョコレート', 'クッキー'],
      'Drinks': [
        '飲み物', 'ドリンク', 'コーヒー', '珈琲', 'お茶', '紅茶', 'ジュース', 'コーラ', 
        '水', 'ミネラルウォーター', 'スタバ', 'タピオカ'
      ],
      'Groceries': [
        '食料品', 'スーパー', 'コンビニ', 'セブン', 'ローソン', 'ファミマ', 
        '野菜', '果物', '肉', '魚', '米', '卵', '牛乳'
      ],
      'Delivery': ['出前', 'デリバリー', 'ウーバーイーツ', 'Uber Eats', '出前館'],
      'Alcohol': ['お酒', 'アルコール', 'ビール', 'ワイン', '日本酒', '焼酎', 'ハイボール', '飲み会'],
    },
  ),
  'Housing': CategoryPattern(
    mainKeywords: ['家', '住居', '住宅'],
    subCategoryKeywords: {
      'Rent': ['家賃', '賃貸', '敷金', '礼金'],
      'Mortgage': ['住宅ローン', 'ローン返済'],
      'Utilities': ['光熱費', '公共料金', '電気代', 'ガス代', '水道代', '電気', 'ガス', '水道'],
      'Internet': ['インターネット', 'Wi-Fi', 'プロバイダ', '通信費', 'スマホ代', '携帯代'],
      'Maintenance': ['修繕費', '修理', 'リフォーム', 'メンテナンス'],
      'Furniture': ['家具', 'インテリア', 'ベッド', 'ソファ', '机', '椅子', 'カーテン'],
      'Services': ['共益費', '管理費', '清掃代', 'NHK'],
    },
  ),
  'Shopping': CategoryPattern(
    mainKeywords: ['買い物', 'ショッピング', '購入'],
    subCategoryKeywords: {
      'Clothes': ['服', '衣類', 'ファッション', '洋服', 'ユニクロ', 'GU', 'シャツ', 'パンツ', '靴', '下着'],
      'Electronics': ['家電', '電化製品', 'スマホ', 'パソコン', 'PC', '充電器', 'イヤホン', 'テレビ'],
      'Home': ['日用品', '雑貨', '洗剤', 'トイレットペーパー', 'ティッシュ', 'キッチン用品'],
      'Beauty': ['美容', 'コスメ', '化粧品', 'メイク', 'スキンケア', '美容院', 'ヘアサロン', '散髪'],
      'Gifts': ['プレゼント', 'ギフト', 'お土産', '贈り物', 'お祝い'],
      'Software': ['アプリ', 'サブスク', 'ソフトウェア', '課金', 'Spotify', 'Netflix', 'Kindle'],
      'Tools': ['工具', 'DIY', '文房具'],
    },
  ),
  'Transport': CategoryPattern(
    mainKeywords: ['交通費', '移動'],
    subCategoryKeywords: {
      'Bus': ['バス', 'バス代', '乗車券'],
      'Train': ['電車', '地下鉄', '定期券', 'Suica', 'PASMO', '新幹線', '切符'],
      'Taxi': ['タクシー', 'タクシー代', '配車アプリ', 'Go', 'Uber'],
      'Fuel': ['ガソリン', '給油', '灯油', 'スタンド'],
      'Parking': ['駐車場', 'パーキング', '駐輪場'],
      'Maintenance': ['車検', '修理', 'オイル交換', '洗車'],
      'Insurance': ['自動車保険', '保険'],
      'Toll': ['高速道路', 'ETC', '高速代'],
    },
  ),
  'Entertainment': CategoryPattern(
    mainKeywords: ['娯楽', '趣味', '遊び'],
    subCategoryKeywords: {
      'Movies': ['映画', 'シネマ', '映画館', 'チケット'],
      'Games': ['ゲーム', '課金', 'スイッチ', 'PS5', 'ゲーセン'],
      'Streaming': ['動画配信', '音楽配信', 'サブスクリプション'],
      'Events': ['イベント', 'コンサート', 'ライブ', 'フェス', 'チケット代'],
      'Hobbies': ['趣味', '漫画', '釣り', 'キャンプ', 'ゴルフ', 'ヨガ'],
      'Travel': ['旅行', '旅費', 'ホテル', '宿', '航空券', '観光'],
      'Music': ['音楽', 'CD', 'レコード', '楽器', 'カラオケ'],
    },
  ),
  'Health': CategoryPattern(
    mainKeywords: ['健康', '医療'],
    subCategoryKeywords: {
      'Doctor': ['病院', 'クリニック', '診察', '治療費', '歯医者'],
      'Pharmacy': ['薬局', '薬', 'ドラッグストア', 'サプリ', 'ビタミン'],
      'Gym': ['ジム', 'フィットネス', 'スポーツ', 'プール'],
      'Insurance': ['健康保険', '生命保険', '医療保険'],
      'Mental Health': ['カウンセリング', 'メンタル'],
      'Sports': ['スポーツ用品', '運動'],
    },
  ),
  'Education': CategoryPattern(
    mainKeywords: ['教育', '学習'],
    subCategoryKeywords: {
      'Tuition': ['授業料', '学費', '月謝'],
      'Books': ['本', '書籍', '参考書', '教科書', '雑誌', 'マンガ'],
      'Courses': ['習い事', '塾', '予備校', '講座', 'セミナー'],
      'Supplies': ['文具', 'ノート', 'ペン', '教材'],
    },
  ),
  'Family': CategoryPattern(
    mainKeywords: ['家族'],
    subCategoryKeywords: {
      'Childcare': ['育児', '保育園', '幼稚園', 'ベビーシッター'],
      'Toys': ['おもちゃ', '玩具'],
      'School': ['学校', '小遣い'],
      'Pets': ['ペット', 'エサ', 'トリミング', '動物病院'],
    },
  ),
  'Financial': CategoryPattern(
    mainKeywords: ['金融', 'お金'],
    subCategoryKeywords: {
      'Taxes': ['税金', '所得税', '住民税', '消費税'],
      'Fees': ['手数料', '振込手数料', '年会費'],
      'Fines': ['罰金', '違反金'],
      'Insurance': ['保険料'],
    },
  ),
  'Personal': CategoryPattern(
    mainKeywords: ['個人'],
    subCategoryKeywords: {
      'Haircut': ['散髪', 'カット', 'カラー'],
      'Spa': ['マッサージ', 'スパ', '温泉', 'サウナ', '銭湯'],
      'Cosmetics': ['化粧品', 'コスメ'],
    },
  ),

  // --- INCOME ---
  'Salary': CategoryPattern(
    mainKeywords: ['給料', '収入'],
    subCategoryKeywords: {
      'Monthly': ['給与', '月給', '手取り'],
      'Weekly': ['週給', '日払い'],
      'Bonus': ['ボーナス', '賞与', '一時金'],
      'Overtime': ['残業代'],
    },
  ),
  'Business': CategoryPattern(
    mainKeywords: ['ビジネス', '事業'],
    subCategoryKeywords: {
      'Sales': ['売上', '販売'],
      'Services': ['サービス', '報酬', 'ギャラ'],
      'Profit': ['利益', '粗利'],
    },
  ),
  'Investments': CategoryPattern(
    mainKeywords: ['投資', '資産運用'],
    subCategoryKeywords: {
      'Dividends': ['配当', '配当金'],
      'Interest': ['利息', '金利'],
      'Crypto': ['仮想通貨', 'ビットコイン'],
      'Stocks': ['株', '株式', 'NISA', 'つみたてNISA'],
      'Real Estate': ['不動産', '家賃収入'],
    },
  ),
  'Gifts': CategoryPattern(
    mainKeywords: ['プレゼント', '贈与'],
    subCategoryKeywords: {
      'Birthday': ['誕生日', '誕プレ'],
      'Holiday': ['お年玉', 'お祝い'],
      'Allowance': ['仕送り', 'お小遣い'],
    },
  ),
  'Other': CategoryPattern(
    mainKeywords: ['その他'],
    subCategoryKeywords: {
      'Refunds': ['返金', '払い戻し'],
      'Grants': ['助成金', '補助金'],
      'Lottery': ['宝くじ', '当選'],
      'Selling': ['メルカリ', '売却', 'フリマ'],
    },
  ),
};
