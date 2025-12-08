/// Knowledge Base for Smart Pattern Matching with Sub-Category Support
class CategoryPattern {
  final List<String> mainKeywords;
  final Map<String, List<String>> subCategoryKeywords;

  const CategoryPattern({
    this.mainKeywords = const [],
    this.subCategoryKeywords = const {},
  });
}

const Map<String, CategoryPattern> defaultCategoryPatterns = {
  // --- EXPENSE ---
  'Food & Drink': CategoryPattern(
    mainKeywords: ['makan', 'minum', 'food', 'drink', 'kuliner', 'lapar', 'haus'],
    subCategoryKeywords: {
      'Breakfast': ['sarapan', 'bubur', 'nasi uduk', 'roti', 'pagi'],
      'Lunch': ['makan siang', 'lunch', 'siang'],
      'Dinner': ['makan malam', 'dinner', 'malam'],
      'Eateries': [
        'mie gacoan','mie ayam', 'bakso', 'soto', 'nasi goreng', 'gorengan', 'sate', 'pecel lele', 'ayam penyet', 'bubur ayam', 'warteg', 'kaki lima', // Warung
        'padang', 'rendang', 'betutu', 'gudeg', 'rawon', 'coto', 'restoran', 'resto', 'buffet', 'all you can eat', 'sushi', 'steak', // Resto
      ],
      'Snacks': ['cemilan', 'snack', 'jajan', 'coklat', 'keripik', 'roti', 'kue', 'martabak'],
      'Drinks': ['minum', 'kopi', 'teh', 'boba', 'jus', 'coffee', 'tea', 'latte', 'starbucks', 'chatime', 'haus', 'matcha', 'cappucino', 'espresso', 'smoothie', 'smoothie'],
      'Groceries': ['belanja', 'sayur', 'buah', 'beras', 'minyak', 'telur', 'bumbu', 'supermarket', 'pasar', 'indomaret', 'alfamart', 'grocery', 'groceries'],
      'Delivery': ['gofood', 'grabfood', 'shopeefood', 'delivery', 'pesan antar'],
      'Alcohol': ['bir', 'wine', 'alkohol', 'vodka', 'soju', 'beer'],
    },
  ),
  'Housing': CategoryPattern(
    mainKeywords: ['rumah', 'tempat tinggal', 'kost'],
    subCategoryKeywords: {
      'Rent': ['sewa', 'bayar kost', 'kontrakan', 'rent'],
      'Mortgage': ['kpr', 'cicilan rumah', 'mortgage'],
      'Utilities': ['listrik', 'air', 'pdam', 'pln', 'token', 'gas', 'lpg'],
      'Internet': ['wifi', 'indihome', 'biznet', 'myrepublic', 'first media', 'internet', 'paket data'],
      'Maintenance': ['tukang', 'perbaikan', 'renovasi', 'service ac', 'ledeng', 'cat'],
      'Furniture': ['meja', 'kursi', 'kasur', 'lemari', 'sofa', 'perabot'],
      'Services': ['satpam', 'kebersihan', 'sampah', 'ipl'],
    },
  ),
  'Shopping': CategoryPattern(
    mainKeywords: ['belanja', 'beli', 'shopping'],
    subCategoryKeywords: {
      'Clothes': ['baju', 'kaos', 'celana', 'kemeja', 'jaket', 'fashion', 'zara', 'uniqlo', 'h&m'],
      'Electronics': ['hp', 'laptop', 'charger', 'gadget', 'kabel', 'mouse', 'keyboard', 'elektronik'],
      'Home': ['dekorasi', 'sprei', 'korden', 'karpet', 'peralatan rumah'],
      'Beauty': ['makeup', 'skincare', 'skin care', 'lipstik', 'bedak', 'serum', 'toner', 'facial', 'salon', 'potong rambut'], // Moved Haircut here if implicit? Or Personal?
      'Gifts': ['kado', 'hadiah', 'oleh-oleh', 'bingkisan'],
      'Software': ['aplikasi', 'subscription', 'langganan app', 'adobe', 'office', 'windows'],
      'Tools': ['obeng', 'palu', 'perkakas', 'bor', 'alat tukang'],
    },
  ),
  'Transport': CategoryPattern(
    mainKeywords: ['transport', 'jalan', 'perjalanan', 'trip'],
    subCategoryKeywords: {
      'Bus': ['bus', 'bis', 'transjakarta', 'tj', 'damri'],
      'Train': ['kereta', 'kai', 'mrt', 'lrt', 'krl', 'commuter', 'stasiun'],
      'Taxi': ['taksi', 'taxi', 'grab', 'gojek', 'gocar', 'goride', 'uber', 'bluebird', 'maxim'],
      'Fuel': ['bensin', 'pertalite', 'pertamax', 'solar', 'isi bensin', 'pom bensin'],
      'Parking': ['parkir', 'parkiran', 'valet'],
      'Maintenance': ['bengkel', 'servis', 'ganti oli', 'tambal ban', 'cuci motor', 'cuci mobil'],
      'Insurance': ['asuransi mobil', 'asuransi motor'],
      'Toll': ['tol', 'e-toll', 'etoll', 'kartu tol'],
    },
  ),
  'Entertainment': CategoryPattern(
    mainKeywords: ['hiburan', 'fun', 'main'],
    subCategoryKeywords: {
      'Movies': ['nonton', 'bioskop', 'film', 'xxi', 'cgv', 'netflix', 'disney'],
      'Games': ['game', 'steam', 'playstation', 'topup', 'pubg', 'ml', 'mobile legend'],
      'Streaming': ['spotify', 'youtube premium', 'joox', 'apple music', 'vidio'],
      'Events': ['konser', 'tiket', 'pameran', 'festival', 'event'],
      'Hobbies': ['hobi', 'mancing', 'sepeda', 'koleksi', 'mainan', 'gundam'],
      'Travel': ['liburan', 'wisata', 'hotel', 'tiket pesawat', 'traveloka', 'tiket.com', 'healing'],
      'Music': ['alat musik', 'gitar', 'piano', 'lagu'],
    },
  ),
  'Health': CategoryPattern(
    mainKeywords: ['kesehatan', 'sakit', 'sehat'],
    subCategoryKeywords: {
      'Doctor': ['dokter', 'konsultasi', 'rs', 'rumah sakit', 'klinik', 'spesialis', 'halodoc'],
      'Pharmacy': ['obat', 'apotek', 'vitamin', 'suplemen', 'masker'],
      'Gym': ['fitness', 'olahraga', 'renang', 'badminton', 'futsal', 'yoga'],
      'Insurance': ['bpjs', 'asuransi kesehatan', 'premi'],
      'Mental Health': ['psikolog', 'konseling', 'terapi'],
      'Sports': ['bola', 'raket', 'sepatu lari', 'jersey'],
    },
  ),
  'Education': CategoryPattern(
    mainKeywords: ['belajar', 'sekolah', 'kuliah'],
    subCategoryKeywords: {
      'Tuition': ['spp', 'uang sekolah', 'uang kuliah', 'biaya semester', 'sks'],
      'Books': ['buku', 'novel', 'pelajaran', 'gramedia'],
      'Courses': ['kursus', 'les', 'bimbel', 'seminar', 'webinar', 'udemy', 'coursera', 'ruangguru'],
      'Supplies': ['alat tulis', 'pulpen', 'buku tulis', 'fotocopy', 'seragam'],
    },
  ),
  'Family': CategoryPattern(
    mainKeywords: ['keluarga', 'family'],
    subCategoryKeywords: {
      'Childcare': ['pengasuh', 'babysitter', 'daycare'],
      'Toys': ['mainan anak', 'boneka', 'lego'],
      'School': ['uang saku', 'jajan anak', 'sekolah anak'],
      'Pets': ['makanan kucing', 'makanan anjing', 'vet', 'dokter hewan', 'pasir kucing', 'whiskas'],
    },
  ),
  'Financial': CategoryPattern(
    mainKeywords: ['keuangan', 'bank', 'admin'],
    subCategoryKeywords: {
      'Taxes': ['pajak', 'pbb', 'spt'],
      'Fees': ['admin bank', 'biaya transfer', 'potongan'],
      'Fines': ['denda', 'tilang'],
      'Insurance': ['asuransi jiwasraya', 'asuransi umum'],
    },
  ),
  'Personal': CategoryPattern(
    mainKeywords: ['pribadi', 'diri sendiri'],
    subCategoryKeywords: {
      'Haircut': ['potong rambut', 'cukur', 'barbershop', 'pangkas'],
      'Spa': ['pijat', 'massage', 'spa', 'refleksi'],
      'Cosmetics': ['kosmetik', 'parfum', 'deodoran', 'makeup', 'lipstik', 'bedak', 'foundation', 'concealer', 'cushion', 'blush', 'eyeliner', 'maskara', 'eyeshadow',
      'pembersih muka', 'skincare', 'toner', 'serum', 'moisturizer', 'pelembab', 'sunscreen', 'sunblock',
      'krim malam', 'krim siang', 'lotion', 'body lotion', 'body butter', 'body scrub', 'lulur', 'masker wajah',
      'hair care', 'shampoo', 'conditioner', 'hair serum', 'pomade', 'hair gel', 'cat rambut', 'handbody',
      'deodorant spray', 'roll on', 'body mist'],
    },
  ),

  // --- INCOME ---
  'Salary': CategoryPattern(
    mainKeywords: ['pendapatan', 'salary'],
    subCategoryKeywords: {
      'Monthly': [
        'gaji', 'gaji bulanan', 'gajian', 'monthly', 'gaji pokok',
        'salary', 'pendapatan bulanan', 'income bulanan', 'penghasilan tetap',
        'pemasukan rutin', 'upah bulanan', 'gaji tetap', 'uang bulanan',
        'fixed salary', 'bayaran bulanan'
      ],

      'Weekly': [
        'gaji mingguan', 'upah', 'upah mingguan', 'upah harian', 'daily pay',
        'weekly pay', 'uang harian', 'uang mingguan', 'bayaran mingguan',
        'bayaran harian', 'honor harian', 'honor mingguan'
      ],

      'Bonus': [
        'thr', 'tunjangan hari raya', 'bonus', 'insentif', 'komisi',
        'bonus penjualan', 'bonus performa', 'bonus akhir tahun', 'bonus target',
        'reward', 'tip', 'tips', 'service fee', 'uang jasa', 'uang tip',
        'uang tambahan', 'uang komisi', 'fee hasil kerja'
      ],

      'Overtime': [
        'lembur', 'uang lembur', 'overtime', 'ot', 'bayaran lembur',
        'honor lembur', 'uang tambahan lembur', 'jam lembur', 'jam tambahan',
        'extra time', 'upah lembur', 'uang kerja tambahan'
      ],
    },
  ),
  'Business': CategoryPattern(
    mainKeywords: ['bisnis', 'usaha', 'jualan'],
    subCategoryKeywords: {
      'Sales': ['penjualan', 'omzet', 'hasil jual'],
      'Services': ['jasa', 'service', 'freelance', 'proyek'],
      'Profit': ['laba', 'profit', 'keuntungan'],
    },
  ),
  'Investments': CategoryPattern(
    mainKeywords: ['investasi', 'cuan'],
    subCategoryKeywords: {
      'Dividends': ['dividen', 'bagi hasil'],
      'Interest': ['bunga bank', 'bunga deposito'],
      'Crypto': ['crypto', 'bitcoin', 'eth', 'trading'],
      'Stocks': ['saham', 'stock', 'rdn', 'capital gain'],
      'Real Estate': ['sewa rumah', 'kosan', 'properti'],
    },
  ),
  'Gifts': CategoryPattern(
    mainKeywords: ['hadiah', 'kado'],
    subCategoryKeywords: {
      'Birthday': ['ulang tahun', 'ultah'],
      'Holiday': ['angpao', 'lebaran', 'natal'],
      'Allowance': ['uang jajan', 'kiriman orang tua'],
    },
  ),
  'Other': CategoryPattern(
    mainKeywords: ['lainnya', 'other'],
    subCategoryKeywords: {
      'Refunds': ['refund', 'kembalian', 'retur'],
      'Grants': ['hibah', 'bantuan', 'bansos'],
      'Lottery': ['arisan', 'undian', 'lotre', 'hadiah undian'],
      'Selling': ['jual barang', 'preloved', 'bekas'],
    },
  ),
};
