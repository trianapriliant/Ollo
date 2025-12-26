import 'pattern_base.dart';

const Map<String, CategoryPattern> indonesianPatterns = {
  // --- EXPENSE ---
  'Food & Drink': CategoryPattern(
    mainKeywords: ['makan', 'minum', 'food', 'drink', 'kuliner', 'lapar', 'haus'],
    subCategoryKeywords: {
      'Breakfast': [
        'sarapan', 'bubur', 'nasi uduk', 'roti', 'pagi', 
        'telur setengah matang', 'lontong sayur', 'nasi kuning', 
        'ketupat', 'sereal', 'oatmeal', 'breakfast',
        'pagi hari', 'bubur ayam', 'kopi pagi', 'makan pagi',
        'morning coffee', 'cereal', 'toast', 'eggs', 'pancakes'
      ],

      'Lunch': [
        'makan siang', 'lunch', 'siang', 'break', 
        'jam makan siang', 'nasi siang', 'warteg siang',
        'makan di kantor', 'takeaway siang',
        'lunch break', 'noon meal', 'having lunch'
      ],

      'Dinner': [
        'makan malam', 'dinner', 'malam', 'late dinner', 
        'makan di luar', 'makan bareng malam', 'malam hari',
        'makan lesehan', 'makan tengah malam', 'midnight meal',
        'supper', 'evening meal', 'dining out', 'dine out'
      ],

      'Eateries': [
        // Warung / kaki lima / street food
        'gacoan', 'mie gacoan', 'mie ayam', 'bakso', 
        'soto', 'nasi goreng', 'gorengan', 'sate',
        'pecel lele', 'ayam penyet', 'bubur ayam', 'warteg',
        'kaki lima', 'angkringan', 'rm', 'rm padang', 
        'ayam geprek', 'ayam bakar', 'ikan bakar',
        'lalapan', 'mie aceh', 'pempek', 'nasi padang','nasi ayam', 'nasi rames'

        // Restoran / resto modern / mall
        'padang', 'rendang', 'betutu', 'gudeg', 'rawon', 'coto',
        'restoran', 'resto', 'buffet', 'all you can eat', 
        'ayce', 'mall food court', 'food court', 'table service',

        // Brand atau franchise umum
        'sushi', 'steak', 'kfc', 'mcd', 'mcdonalds',
        'hokben', 'rice bowl', 'wingstop', 'burger king',
        'piza hut', 'pizzahut', 'pizzahut', 'pizza', 
        'dominos', 'marugame udon', 'solaria', 'mixue',
        'seblak', 'dimsum', 'shabu shabu',
        'restaurant', 'cafe', 'diner', 'bistro', 'food stall', 'street food'
      ],

      'Snacks': [
        'cucur','cucur adaby','cucur adaby yang enaq','cemilan', 'snack', 'jajan', 'coklat', 'keripik', 'roti',
        'kue', 'martabak', 'dimsum', 'basreng', 'macaroni', 
        'kacang', 'permen', 'kue basah', 'kue kering', 
        'donat', 'donut', 'croissant', 'wafer',
        'chips', 'chocolate', 'candy', 'cookies', 'cake', 'biscuit'
      ],

      'Drinks': [
        'minum', 'kopi', 'teh', 'boba', 'jus', 
        'coffee', 'tea', 'latte', 'matcha', 
        'cappucino', 'cappuccino', 'espresso', 
        'smoothie', 'milkshake', 'susu', 'le minerale',
        'mineral water', 'aqua', 'es teh', 'teh botol',
        'starbucks', 'chatime', 'haus', 'janji jiwa',
        'kopi kenangan', 'fore coffee', 'teh poci',
        'minuman dingin', 'minuman panas',
        'water', 'juice', 'milk', 'soft drink', 'soda', 'beverage'
      ],

      'Groceries': [
        'belanja', 'belanja bulanan', 'sayur', 
        'beras', 'minyak', 'telur', 'bumbu', 'gula', 'garam',
        'tisu', 'sabun', 'susu', 'baygon', 'mie instan',
        'supermarket', 'pasar', 'indomaret', 'alfamart',
        'superindo', 'lottemart', 'hypermart', 'fresh market',
        'grocery', 'groceries', 'belanja dapur', 'bahan makanan', 'belanja makanan', 'belanja bahan makanan',
        'market', 'supermarket', 'convenience store', 'vegetables', 'rice', 'oil', 'galon', 'galon air', 'galon air minum', 'galon akua', 'akua', 'le mineral'
      ],

      'Fruits': [
        'buah', 'buah-buahan', 'buah buahan', 'beli buah', 'buah segar',
        'apel', 'pisang', 'jeruk', 'mangga', 'anggur', 
        'strawberry', 'stroberi', 'semangka', 'melon', 'nanas', 'pepaya', 
        'pir', 'persik', 'plum', 'ceri', 'blueberry', 'raspberry',
        'lemon', 'limau', 'alpukat', 'kelapa', 'delima',
        'durian', 'leci', 'rambutan', 'manggis', 'salak', 'duku', 'langsat',
        'jambu', 'jambu biji', 'sirsak', 'nangka', 'sawo', 'markisa',
        'fruit', 'fruits', 'banana', 'orange', 'apple', 'mango', 'grape'
      ],

      'Delivery': [
        'gofood', 'grabfood', 'shopeefood', 
        'delivery', 'pesan antar', 'ongkir makanan',
        'food delivery', 'antar makanan', 'kurir makanan',
        'diantar driver', 'order makanan online', 'order makanan', 'order online', 'order food',
        'delivery fee', 'uber eats', 'door dash'
      ],

      'Alcohol': [
        'bir', 'wine', 'alkohol', 'vodka', 'soju', 'beer',
        'whiskey', 'whisky', 'gin', 'tequila', 'minuman keras',
        'minuman beralkohol', 'liquor', 'alcohol',
        'wine', 'beer'
      ],
    },
  ),
  'Housing': CategoryPattern(
    mainKeywords: ['rumah', 'tempat tinggal', 'kost'],
    subCategoryKeywords: {
      'Rent': [
        'sewa', 'bayar kost', 'kontrakan', 'kontrak rumah', 
        'bayar kamar', 'bayar tempat tinggal', 'sewa bulanan', 
        'pembayaran kos', 'uang kos', 'uang kontrakan', 
        'boarding house', 'rent', 'sewa apartemen', 'bayar apart',
        'monthly rent', 'apartment rent', 'lease',
        'biaya sewa', 'tagihan sewa', 'uang sewa', 'kos', 'sewa kos', 'bayar kos',
        'bayar sewa', 'bayar kontrakan'
      ],

      'Mortgage': [
        'kpr', 'cicilan rumah', 'mortgage', 'kredit rumah', 
        'angsuran rumah', 'kredit properti', 'cicilan properti',
        'pembayaran kpr', 'angsuran kpr', 'kpr btn', 'kpr bca', 
        'kredit pemilikan rumah', 'bunga kpr', 'cicilan apartemen', 'kpa'
      ],

      'Utilities': [
        'listrik', 'bayar listrik', 'air', 'pdam', 'pln', 'token',
        'pulsa listrik', 'gas', 'lpg', 'elpiji', 'pgn', 'meteran',
        'tagihan air', 'tagihan listrik', 'pembayaran pdam',
        'bayar pln', 'biaya utilitas', 'utilitas',
        'electricity', 'water bill', 'power bill', 'gas bill', 'utility',
        'iuran sampah', 'uang kebersihan', 'tagihan gas'
      ],

      'Internet': [
        'wifi', 'bayar wifi', 'langganan wifi', 'paket data', 
        'internet', 'indihome', 'first media', 'biznet', 
        'myrepublic', 'cbn fiber', 'oxigen', 'hinet', 
        'indosat', 'telkomsel', 'tri', 'xl', 
        'kabel internet', 'wifi bulanan', 'pemasangan wifi',
        'tagihan internet', 'kuota', 'beli kuota', 'paket internet',
        'internet bill', 'wifi bill', 'data plan', 'mobile data'
      ],

      'Maintenance': [
        'tukang', 'perbaikan', 'service', 'service ac', 
        'renovasi', 'kebocoran', 'ledeng', 'plafon',
        'cat', 'pengecatan', 'repair', 'servis kulkas',
        'service mesin cuci', 'tukang bangunan', 'tukang cat',
        'jasa tukang', 'ganti pipa', 'perbaikan rumah',
        'genteng bocor', 'ganti kran', 'perbaikan listrik', 'korslet'
      ],

      'Furniture': [
        'meja', 'kursi', 'kasur', 'lemari', 'sofa', 
        'dipan', 'bantal', 'guling', 'spring bed',
        'perabot', 'perabotan', 'furniture', 
        'rak', 'bufet', 'meja belajar', 'meja makan',
        'almari', 'kabinet', 'kursi tamu', 'karpet',
        'dekorasi rumah', 'hiasan dinding', 'gorden', 'tirai'
      ],

      'Services': [
        'satpam', 'keamanan', 'security', 'petugas keamanan', 
        'kebersihan', 'cleaning service', 'cs', 
        'sampah', 'tarikan sampah', 'pengangkutan sampah',
        'ipl', 'iuran bulanan', 'iuran lingkungan',
        'petugas komplek', 'karyawan komplek', 'biaya lingkungan'
      ],
    },
  ),
  'Shopping': CategoryPattern(
    mainKeywords: ['belanja', 'beli', 'shopping'],
    subCategoryKeywords: {
      'Clothes': [
        'baju', 'kaos', 'celana', 'kemeja', 'jaket', 
        'hoodie', 'sweater', 'jeans', 'celana jeans',
        'rok', 'dress', 'kebaya', 'jas', 'pakaian',
        'fashion', 'outfit', 'baju kondangan',
        'shirt', 'pants', 'trousers', 'shoes', 'sneakers',
        'sepatu', 'sandal', 'tas', 'dompet', 'topi',
        'jilbab', 'kerudung', 'gamis', 'batik',
        'zara', 'uniqlo', 'h&m', 'brand pakaian',
        'beli baju', 'belanja baju', 'fitting'
      ],

      'Electronics': [
        'hp', 'laptop', 'pc', 'komputer',
        'charger', 'gadget', 'kabel', 'powerbank',
        'earphone', 'headphone', 'speaker',
        'keyboard', 'mouse', 'monitor', 'elektronik',
        'tablet', 'ipad', 'processor', 'ssd', 'hdd',
        'kulkas', 'mesin cuci', 'tv', 'ac',
        'kamera', 'camera', 'tripod', 'lensa',
        'samsung', 'iphone', 'xiaomi', 'oppo', 'vivo',
        'electronic store', 'service hp', 'repair laptop'
      ],

      'Home': [
        'peralatan rumah', 'alat rumah tangga', 'alat rumah',
        'dekorasi', 'dekor', 'interior rumah',
        'sprei', 'seprai', 'bed cover', 'sarung bantal',
        'korden', 'gorden', 'tirai', 'karpet',
        'keset', 'lemari', 'rak piring', 'perabot kecil',
        'peralatan kamar mandi', 'dispenser', 'vacuum cleaner',
        'sapu', 'pel', 'ember', 'gayung', 'sikat',
        'deterjen', 'sabun cuci', 'pewangi pakaian',
        'furniture', 'decor', 'bed sheet', 'curtain'
      ],

      'Beauty': [
        'makeup', 'skincare', 'skin care',
        'lipstik', 'lipstick', 'bedak', 'serum', 'essence',
        'toner', 'pelembab', 'moisturizer', 'masker wajah',
        'cream wajah', 'facial', 'perawatan wajah',
        'salon', 'spa', 'perawatan tubuh',
        'potong rambut', 'haircut', 'cat rambut', 'hair dye',
        'sabun', 'shampoo','sampo', 'perawatan rambut', 'parfume', 'parfum', 'perfume',
        'body lotion', 'hand body', 'lulur', 'massage', 'creambath'
      ],

      'Gifts': [
        'kado', 'hadiah', 'gift', 'oleh-oleh',
        'bingkisan', 'souvenir', 'hampers', 'parcel',
        'kado ulang tahun', 'giftbox', 'premium gift',
        'bungkus kado', 'kotak kado', 'hadiah wisuda', 'hadiah nikah'
      ],

      'Software': [
        'aplikasi', 'subscription', 'subscribe',
        'langganan app', 'pembelian aplikasi',
        'adobe', 'photoshop', 'illustrator', 'premiere',
        'office', 'ms office', 'word', 'excel', '365', 
        'windows', 'license key', 'product key',
        'spotify', 'youtube premium', 'netflix', 'disney+',
        'antivirus', 'vpn', 'cloud storage', 'google drive'
      ],

      'Tools': [
        'obeng', 'palu', 'perkakas', 'bor',
        'mesin bor', 'kunci inggris', 'kunci pas',
        'alat tukang', 'alat bangunan', 'peralatan bengkel',
        'gergaji', 'tang', 'bor listrik', 'obeng set',
        'toolkit', 'toolbox', 'meteran', 'paku', 'sekrup', 'baut'
      ],
    },
  ),
  'Transport': CategoryPattern(
    mainKeywords: ['transport', 'jalan', 'perjalanan', 'trip'],
    subCategoryKeywords: {
      'Bus': [
        'bus', 'bis', 'transjakarta', 'tj', 'damri',
        'bst', 'trans jogja', 'suroboyo bus', 'brt', 
        'bus kota', 'bus rapid transit', 'minibus',
        'busway', 'halte bus', 'bayar bus',
        'public bus', 'city bus', 'bus ticket', 'bus fare'
      ],

      'Train': [
        'kereta', 'kai', 'mrt', 'lrt', 'krl', 'commuter',
        'stasiun', 'lokal line', 'commuterline', 'prameks',
        'kereta api', 'boarding kereta', 'kai access', 
        'tiket kereta', 'tap in kereta',
        'train ticket', 'subway', 'metro', 'tube', 'railway', 'train fare'
      ],

      'Taxi': [
        'taksi', 'taxi', 'grab', 'gojek', 'gocar', 'goride',
        'gograb', 'uber', 'bluebird', 'maxim',
        'grabcar', 'grabbike', 'go bluebird',
        'taxi meter', 'pick up taxi', 'ojol', 
        'ojek online', 'angkutan online',
        'cab', 'ride share', 'uber'
      ],

      'Fuel': [
        'bensin', 'pertalite', 'pertamax', 'solar',
        'bbm', 'isi bensin', 'pom bensin', 'spbu',
        'pertamina', 'fuel', 'isi bbm', 
        'isi bensin full', 'beli bbm', 
        'e7', // kode transaksi spbu di mutasi bank kadang muncul
        'mypertamina',
        'gas', 'petrol', 'gasoline', 'filling station'
      ],

      'Parking': [
        'parkir', 'parkiran', 'valet', 'e-parking',
        'parkir motor', 'parkir mobil', 'lapak parkir',
        'tiket parkir', 'biaya parkir',
        'parking fee', 'parking ticket', 'valet parking'
      ],

      'Maintenance': [
        'bengkel', 'servis', 'service', 'service motor',
        'service mobil', 'ganti oli', 'oli mesin', 'oli gardan',
        'perawatan kendaraan', 'tambal ban', 'radiator',
        'tune up', 'overhaul', 'spare part', 
        'understeel', 'perbaikan kendaraan'
      ],

      'Insurance': [
        'asuransi mobil', 'asuransi motor', 
        'premi asuransi kendaraan', 'bayar premi mobil',
        'asuransi kendaraan bermotor', 'klaim asuransi kendaraan'
      ],

      'Toll': [
        'tol', 'e-toll', 'etoll', 'kartutol', 'tap tol',
        'jalan tol', 'bayar tol', 'tol gate', 'transaksi tol',
        'top up e-toll', 'top up kartu tol'
      ],
    },
  ),
  'Entertainment': CategoryPattern(
    mainKeywords: ['hiburan', 'fun', 'main'],
    subCategoryKeywords: {
      'Movies': [
        'nonton', 'bioskop', 'film', 
        'xxi', 'cgv', 'cinepolis', 'movimax',
        'netflix', 'disney', 'disney+', 'disney plus',
        'prime video', 'amazon prime', 'hbomax', 'hbo', 
        'viu', 'catchplay', 'tix id', 'tiket nonton',
        'sewa film', 'movie rental',
        'cinema', 'movie ticket', 'film rental'
      ],

      'Games': [
        'game', 'gaming', 'main game', 
        'steam', 'epic games', 'playstation', 'psn',
        'nintendo', 'switch', 'xbox', 
        'topup', 'top up', 'isi diamond', 
        'pubg', 'ml', 'mobile legend', 'mlbb',
        'genshin', 'genshin impact', 'roblox', 'valorant',
        'voucher game', 'koin game', 'chip game'
      ],

      'Streaming': [
        'spotify', 'youtube premium', 'youtube+', 
        'joox', 'apple music', 'apple tv', 'vidio', 
        'vidio premier', 'hotstar', 'spotify premium',
        'langganan streaming', 'subscription streaming', 
        'langganan musik', 'streaming musik'
      ],

      'Events': [
        'konser', 'tiket', 'ticket', 
        'pameran', 'expo', 'exhibition',
        'festival', 'event', 'acara',
        'seminar', 'webinar', 'konferensi', 'conference',
        'presale', 'meet & greet', 'meet and greet'
      ],

      'Hobbies': [
        'hobi', 'mancing', 'pancing', 
        'pancingan', 'umpan', 'joran', 'reel',
        'sepeda', 'gowes', 'bike',
        'koleksi', 'collection', 'kolektor',
        'mainan', 'toy', 'figures', 'action figure',
        'gundam', 'gunpla', 'lego', 'model kit',
        'aquarium', 'aquascape', 'bonsai', 'tanaman hias'
      ],

      'Travel': [
        'liburan', 'holiday', 'travel',
        'wisata', 'trip', 'tour', 'tur', 
        'hotel', 'penginapan', 'guest house', 'villa',
        'tiket pesawat', 'flight ticket', 
        'garuda', 'lion air', 'citilink', 'airasia',
        'traveloka', 'tiket.com', 'agoda', 'booking.com',
        'tour guide', 'city tour', 'healing'
      ],

      'Music': [
        'musik', 'alat musik', 
        'gitar', 'bass', 'drum', 'piano', 'keyboard', 
        'ukulele', 'biola', 'saxophone',
        'les musik', 'les gitar', 'kursus musik',
        'lagu', 'mp3', 'album musik', 'recording'
      ],
    },
  ),
  'Health': CategoryPattern(
    mainKeywords: ['kesehatan', 'sakit', 'sehat'],
    subCategoryKeywords: {
      'Doctor': ['dokter', 'konsultasi', 'rs', 'rumah sakit', 'klinik', 'spesialis', 'halodoc'],
      'Pharmacy': ['obat', 'apotek', 'vitamin', 'suplemen', 'masker', 'strip', 'kapsul', 'tablet', 'resep', 'sirup'],
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
    mainKeywords: ['keuangan', 'admin'],
    subCategoryKeywords: {
      'Taxes': [
        'pajak', 'pbb', 'spt', 'pajak bumi bangunan', 'ppn', 
        'pph', 'pajak penghasilan', 'bayar pajak', 'tagihan pajak',
        'bea materai', 'materai', 'pajak kendaraan', 'pkb',
        'stnk', 'balik nama', 'swdkllj', 'e-samsat', 'samsat',
        'pajak tahunan', 'pajak bulanan', 'pajak usaha',
        'lapor pajak', 'setor pajak', 'ebilling'
      ],

      'Fees': [
        'admin bank', 'administrasi bank', 'biaya admin', 
        'biaya transfer', 'fee transfer', 'potongan', 'fee bank',
        'charge', 'bank fee', 'service fee', 'platform fee',
        'biaya layanan', 'biaya tarik tunai', 'biaya top up',
        'biaya pemeliharaan', 'monthly fee', 'handling fee',
        'biaya kartu', 'annual fee', 'biaya transaksi', 
        'potongan bank', 'fee marketplace'
      ],

      'Fines': [
        'denda', 'tilang', 'denda keterlambatan', 'late fee',
        'penalty', 'penalti', 'denda buku', 'denda perpustakaan',
        'overdue fine', 'denda telat bayar', 'charge keterlambatan',
        'sanksi administrasi'
      ],

      'Insurance': [
        'asuransi', 'asuransi jiwasraya', 'asuransi umum', 
        'premi', 'premi asuransi', 'iuran asuransi', 'bayar asuransi',
        'asuransi kesehatan', 'asuransi jiwa', 'asuransi mobil',
        'asuransi motor', 'bpjs', 'bpjs kesehatan', 'bpjs ketenagakerjaan',
        'klaim asuransi', 'unit link', 'polis', 'tagihan premi',
        'asuransi prudential', 'asuransi allianz', 'asuransi sinarmas'
      ],
    },
  ),
  'Personal': CategoryPattern(
    mainKeywords: ['pribadi', 'diri sendiri'],
    subCategoryKeywords: {
      'Haircut': [
        'potong rambut', 'cukur', 'cukuran', 'pangkas',
        'pangkas rambut', 'gunting rambut', 'barbershop',
        'barber', 'barbers', 'salon', 'salon rambut',
        'haircut', 'hair cut', 'tukang cukur', 'tukang pangkas',
        'rapihin rambut', 'fade', 'catok rambut',
        'keramas salon', 'blow rambut', 'hair styling'
      ],

      'Spa': [
        'spa', 'pijat', 'massage', 'full body massage',
        'foot massage', 'pijat refleksi', 'refleksi', 
        'reflexology', 'body spa', 'body scrub', 
        'lulur', 'sauna', 'mandi uap', 'body treatment', 
        'totok wajah', 'facial massage', 'relaksasi', 
        'aromatherapy', 'totok punggung'
      ],
      'Cosmetics': ['kosmetik', 'parfum', 'deodoran', 'makeup', 'lipstik', 'bedak', 'foundation', 'concealer', 'cushion', 'blush', 'eyeliner', 'maskara', 'eyeshadow',
      'pembersih muka', 'skincare', 'toner', 'serum', 'moisturizer', 'pelembab', 'sunscreen', 'sunblock',
      'krim malam', 'krim siang', 'lotion', 'body lotion', 'body butter', 'body scrub', 'lulur', 'masker wajah',
      'hair care', 'shampoo', 'conditioner', 'hair serum', 'pomade', 'hair gel', 'cat rambut', 'handbody',
      'deodorant spray', 'roll on', 'body mist'],
    },
  ),
  'Friend': CategoryPattern(
    mainKeywords: ['teman', 'friend', 'sobat', 'kawan'],
    subCategoryKeywords: {
      'Transfer': [
        'transfer teman', 'tf teman', 'kirim teman', 'kirim ke teman',
        'transfer ke teman', 'transfer friend', 'send to friend'
      ],
      'Treat': [
        'traktir', 'traktir teman', 'bayarin teman', 'bayarin',
        'treat', 'treat teman', 'beliin teman', 'beli untuk teman',
        'bayar makan teman', 'bayar teman', 'bayarin teman'
      ],
      'Refund': [
        'refund teman', 'balikin duit teman', 'balikin uang teman',
        'kembaliin uang teman', 'bayar balik teman', 'ganti uang teman'
      ],
      'Loan': [
        'pinjam', 'pinjemin teman', 'kasih pinjam', 'pinjami teman',
        'kasih pinjaman', 'utangin', 'hutangin'
      ],
      'Gift': [
        'kado teman', 'hadiah teman', 'beli kado teman',
        'gift friend', 'beliin hadiah', 'hadiah buat teman'
      ],
    },
  ),

  // --- INCOME ---

  'Salary': CategoryPattern(
    mainKeywords: ['pendapatan', 'salary'],
    subCategoryKeywords: {
      'Monthly': [
        'penghasilan','penghasilan bulanan','gaji', 'gaji bulanan', 'gajian', 'monthly', 'gaji pokok',
        'salary', 'pendapatan bulanan', 'income bulanan', 'penghasilan tetap',
        'pemasukan rutin', 'upah bulanan', 'gaji tetap', 'uang bulanan',
        'fixed salary', 'bayaran bulanan', 'uang tetap', 'uang tetap bulanan', 'uang tetap rutin', 'uang tetap rutin bulanan'
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
      'Sales': [
        'penjualan', 'omzet', 'omset', 'hasil jual', 'pendapatan jual',
        'transaksi penjualan', 'pemasukan toko', 'sales revenue',
        'hasil dagang', 'hasil usaha', 'jual produk', 'jualan',
        'pembeli bayar', 'invoice dibayar', 'penerimaan penjualan',
        'closing', 'closing sales', 'paid order', 'order selesai'
      ],

      'Services': [
        'jasa', 'service', 'servis', 'freelance', 'freelancer',
        'fee jasa', 'fee proyek', 'proyek', 'hasil jasa', 'upah jasa',
        'jasa layanan', 'honor', 'honorarium', 'bayaran jasa',
        'jasa desain', 'jasa edit', 'jasa konsultasi',
        'service fee', 'komisi jasa', 'pelayanan'
      ],

      'Profit': [
        'laba', 'profit', 'keuntungan', 'margin', 'selisih keuntungan',
        'profit bersih', 'keuntungan bersih', 'gross profit',
        'nett profit', 'net profit', 'laba usaha', 'profit usaha',
        'cuan', 'gain', 'earning', 'hasil bersih'
      ],
    },
  ),
  'Investments': CategoryPattern(
    mainKeywords: ['investasi', 'cuan'],
    subCategoryKeywords: {
      'Dividends': [
        'dividen','bagi hasil','bagi laba','bagi untung','pembagian keuntungan',
        'profit sharing','hasil saham','dividen tunai','dividen rdn','yield',
        'pembagian laba','div.','dividen masuk'
      ],
      'Interest': [
        'bunga bank','bunga deposito','bunga tabungan','interest','return deposito',
        'bonus tabungan','nisbah','ujrah','margin','bagi hasil tabungan',
        'bunga berjalan','imbal hasil','bunga investasi','margin bank',
        'bunga pinjaman masuk'
      ],
      'Crypto': [
        'crypto','kripto','bitcoin','btc','eth','ether','bnb','doge','altcoin',
        'token','crypto trading','trading koin','jual beli crypto','swap crypto',
        'staking reward','mining','airdrop','profit crypto','cuan crypto',
        'futures','leverage','binance'
      ],
      'Stocks': [
        'saham','stock','stocks','rdn','rekening dana nasabah','RDN masuk',
        'capital gain','cuan saham','profit saham','dividen saham','jual saham',
        'beli saham','trading saham','invest saham','IHSG','bluechip','lot saham'
      ],
      'Real Estate': [
        'sewa properti','rental properti','properti','property rental',
        'terima uang kos','terima uang kost','terima uang kontrakan','terima uang rental kost','terima uang sewa','ruko',
        'kapling','jual rumah','jual tanah','sewa kamar','deposit sewa'
      ],
    },
  ),
  'Gifts': CategoryPattern(
    mainKeywords: ['hadiah', 'kado'],
    subCategoryKeywords: {
      'Birthday': [
        'ulang tahun', 'ultah', 'birthday', 'hadiah ultah', 'kado ulang tahun',
        'uang ulang tahun', 'uang ultah', 'birthday gift', 'gift birthday'
      ],

      'Holiday': [
        'angpao', 'ampao', 'uang angpao', 'uang ampao', 'lebaran', 'idul fitri',
        'idul adha', 'ramadhan', 'natal', 'christmas', 'imlek', 'tahun baru',
        'holiday gift', 'hadiah liburan', 'uang liburan', 'musiman'
      ],

      'Allowance': [
        'pesangon','uang jajan', 'kiriman orang tua', 'kiriman ortu', 'uang bulanan orang tua',
        'monthly allowance', 'allowance', 'uang saku', 'uang kiriman',
        'transfer orang tua', 'dikirim orang tua'
      ],

    },
  ),
  'Other': CategoryPattern(
    mainKeywords: ['lainnya', 'other'],
    subCategoryKeywords: {
      'Refunds': [
        'refund', 'refund dana', 'pengembalian dana', 
        'kembalian', 'retur', 'pembatalan pesanan', 
        'kredit balik', 'refund transaksi', 
        'saldo dikembalikan', 'uang kembali', 
        'pengembalian pembelian', 'return'
      ],

      'Grants': [
        'hibah', 'bantuan', 'bansos', 
        'subsidi', 'grant', 'bantuan pemerintah', 
        'bantuan finansial', 'santunan', 
        'uang bantuan', 'dana hibah', 
        'tunai bansos', 'bansos tunai', 'bantuan sosial'
      ],

      'Lottery': [
        'arisan', 'undian', 'lotre', 
        'hadiah undian', 'dapat hadiah', 'tombola',
        'giveaway', 'hadiah acara', 
        'lottery', 'lucky draw', 'menang undian',
        'hadiah uang', 'hadiah tunai', 'prize win'
      ],

      'Selling': [
        'jual barang', 'penjualan', 'preloved', 
        'bekas', 'thrifting', 'jual online',
        'lapak jual', 'jualan barang', 'menjual aset',
        'jual inventaris', 'jual hp', 'jual laptop',
        'jualan second', 'barang bekas',
        'hasil penjualan', 'pendapatan jual'
      ],
    },
  ),
};
