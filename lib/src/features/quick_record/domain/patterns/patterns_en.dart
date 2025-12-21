import 'pattern_base.dart';

const Map<String, CategoryPattern> englishPatterns = {
  // --- EXPENSE ---
  'Food & Drink': CategoryPattern(
    mainKeywords: ['food', 'drink', 'eat', 'beverage', 'meal', 'hungry', 'thirsty'],
    subCategoryKeywords: {
      'Breakfast': [
        'breakfast', 'morning coffee', 'morning meal',
        'grab breakfast', 'breakfast combo',
        'cereal', 'toast', 'eggs', 'scrambled eggs',
        'pancakes', 'waffles', 'bacon', 'sausage',
        'breakfast sandwich', 'breakfast burrito',
        'hash browns', 'bagel', 'oatmeal', 'coffee & bagel'
      ],

      'Lunch': [
        'lunch', 'lunch break', 'lunch meal',
        'noon meal', 'having lunch', 'grab lunch',
        'lunch special', 'work lunch', 'quick lunch',
        'office lunch', 'takeout lunch'
      ],

      'Dinner': [
        'dinner', 'supper', 'evening meal',
        'dining out', 'dine out', 'late dinner',
        'family dinner', 'formal dinner',
        'steak dinner', 'seafood dinner',
        'takeout dinner', 'dinner order'
      ],

      'Eateries': [
        'restaurant', 'cafe', 'coffee shop',
        'diner', 'bistro', 'food stall', 'street food',
        'fast food', 'drive thru', 'takeout',
        'kfc', 'mcdonalds', 'mc donald\'s',
        'burger king', 'bk', 'pizza hut',
        'dominos', 'subway', 'starbucks',
        'chipotle', 'taco bell', 'popeyes',
        'wendy\'s', 'chick-fil-a', 'panda express',
        'dunkin', 'five guys', 'wendys'
      ],

      'Snacks': [
        'snack', 'snacking', 'chips', 'fries',
        'chocolate', 'candy', 'cookies', 'cake',
        'biscuit', 'biscuits', 'donut', 'croissant',
        'ice cream', 'popcorn', 'cheetos', 'doritos',
        'energy bar', 'protein bar'
      ],

      'Drinks': [
        'drink', 'drinks', 'coffee', 'tea', 'latte',
        'cappuccino', 'espresso', 'americano',
        'iced coffee', 'iced tea', 'juice',
        'milk', 'soft drink', 'soda', 'cola',
        'beverage', 'water', 'mineral water',
        'sparkling water', 'smoothie', 'milkshake',
        'frappuccino', 'slurpee'
      ],

      'Groceries': [
        'grocery', 'groceries', 'grocery store',
        'market', 'supermarket', 'convenience store',
        'walmart', 'costco', 'target', 'whole foods',
        'kroger', 'publix', 'safeway', 'trader joe\'s',
        'vegetables', 'fruits', 'meat', 'beef', 'chicken',
        'fish', 'seafood', 'rice', 'oil', 'bread',
        'milk', 'eggs', 'butter', 'cheese',
        'household items'
      ],

      'Delivery': [
        'delivery', 'food delivery', 'meal delivery',
        'order food', 'order online', 'takeout order',
        'delivery fee', 'service fee', 
        'uber eats', 'ubereats', 'doordash', 'door dash',
        'grubhub', 'postmates', 'seamless'
      ],

      'Alcohol': [
        'alcohol', 'beer', 'craft beer', 'wine',
        'liquor', 'whiskey', 'vodka', 'gin',
        'tequila', 'cocktail', 'rum', 'bourbon',
        'champagne', 'liqueur', 'bar tab', 'pint',
        'brewery', 'bar order', 'pub'
      ],
    },
  ),
  'Housing': CategoryPattern(
    mainKeywords: ['house', 'home', 'apartment', 'place'],
    subCategoryKeywords: {
      'Rent': [
        'rent', 'monthly rent', 'apartment rent', 'lease', 
        'rent payment', 'rental fee', 'house rent', 
        'rent due', 'rent balance',
        'housing', 'tenant rent', 'landlord payment'
      ],

      'Mortgage': [
        'mortgage', 'mortgage payment', 'home loan', 
        'housing loan', 'property loan', 'mortgage interest',
        'mortgage installment', 'mortgage insurance',
        'principal payment', 'escrow payment'
      ],

      'Utilities': [
        'utilities', 'utility bill', 
        'electricity', 'electric bill', 'power bill',
        'water', 'water bill', 'gas bill', 'gas service',
        'sewer bill', 'trash bill', 'waste services',
        'meter reading', 'utility payment'
      ],

      'Internet': [
        'internet', 'wifi', 'wi-fi', 'broadband', 
        'fiber internet', 'high-speed internet',
        'data plan', 'mobile data', 'unlimited data',
        'internet bill', 'internet service'
      ],

      'Maintenance': [
        'maintenance', 'repair', 'fix', 'broken appliance',
        'appliance repair', 'house repair', 'home maintenance',
        'plumber', 'electrician', 'contractor', 'handyman',
        'renovation', 'painting', 'roof repair', 
        'hvac repair', 'service ac', 'ac maintenance',
        'leak fix', 'pipe repair'
      ],

      'Furniture': [
        'furniture', 'home furniture', 'decor', 
        'home decor', 'interior decor',
        'bed', 'sofa', 'table', 'chair', 'dining table',
        'cupboard', 'wardrobe', 'cabinet', 'shelf',
        'nightstand', 'desk', 'work desk',
        'bed sheet', 'curtain', 'pillow', 
        'rug', 'carpet', 'mattress', 'dresser'
      ],

      'Services': [
        'security', 'security fee', 'community security',
        'cleaning', 'cleaning service', 'maid service',
        'housekeeper', 'garbage', 'trash', 
        'waste pickup', 'pest control', 'termite control',
        'yard service', 'lawn care', 'pool cleaning',
        'community fee', 'hoa fee'
      ],
    },
  ),
  'Shopping': CategoryPattern(
    mainKeywords: ['shopping', 'buy', 'purchase'],
    subCategoryKeywords: {
      'Clothes': [
        // general clothing
        'clothes', 'clothing', 'apparel', 'fashion', 'outfit', 'wardrobe',
        'buy clothes', 'new clothes', 'shopping clothes',
        'clothing purchase', 'clothing order',
        
        // garments
        'shirt', 't-shirt', 'tee', 'top', 
        'pants', 'trousers', 'jeans', 'slacks', 'shorts',
        'dress', 'skirt', 'suit', 'coat', 'jacket', 'hoodie',
        'sweatshirt', 'sweater', 'cardigan', 'blouse',
        'underwear', 'lingerie', 'boxers', 'briefs', 'bra', 'panties',
        'socks', 'stockings', 'hosiery',
        
        // footwear
        'shoes', 'sneakers', 'trainers', 'boots', 'sandals', 'flip flops',

        // accessories
        'belt', 'hat', 'cap', 'gloves', 'scarf', 'tie', 
        
        // shopping contexts
        'shoe store', 'clothing store', 'boutique',
        'fashion brand', 'online clothing purchase',

        // common brands
        'h&m', 'uniqlo', 'gap', 'nike clothing', 'adidas apparel',
        'old navy', 'american eagle', 'zara', 'forever 21', 'fashion nova'
      ],

      'Electronics': [
        'electronics', 'electronic item', 'tech item', 'gadget',
        'buy electronics', 'electronics purchase', 'repair electronics',

        // mobile/pc devices
        'phone', 'iphone', 'mobile', 'android phone',
        'computer', 'pc', 'desktop', 'laptop', 'macbook',
        'tablet', 'ipad',

        // peripherals
        'charger', 'charging cable', 'cable', 'adapter',
        'headphones', 'earbuds', 'airpods', 'wired earphones',
        'mouse', 'keyboard', 'monitor', 'printer', 'router', 'wifi router',

        // large appliances
        'television', 'tv', 'smart tv', 
        'washing machine', 'dryer', 'fridge', 'refrigerator',
        'freezer', 'dishwasher', 'microwave', 'oven',

        // cameras & audio
        'camera', 'dslr', 'action cam', 
        'speaker', 'sound system',

        // stores & brands typical on receipts
        'best buy', 'apple store', 'samsung store', 
        'lg electronics', 'sony electronics'
      ],

      'Home': [
        'home', 'home goods', 'household items', 
        'house supplies', 'home purchase',
        'home appliances', 'kitchenware', 'cookware', 'dishware',
        'utensils', 'plates', 'cups', 'cutlery',

        // bedroom & bathroom
        'bedding', 'linens', 'sheets', 'mattress cover',
        'blanket', 'duvet', 'pillowcase',
        'bath', 'bathroom supplies', 'towels', 'bath mat',
        'shower curtain',

        // cleaning
        'cleaning supplies', 'detergent', 'dish soap', 'bleach',

        // home improvement stores
        'home store', 'home goods store', 'bed bath & beyond'
      ],

      'Beauty': [
        'beauty', 'cosmetics', 'beauty products',
        'makeup', 'skincare', 'skin care', 'beauty supplies',

        // common items
        'lipstick', 'lip gloss', 'foundation', 
        'powder', 'compact powder', 'blush',
        'serum', 'moisturizer', 'toner', 'eye cream',
        'mask', 'face mask', 'sheet mask',

        // bath & body care
        'soap', 'body wash', 'shower gel',
        'shampoo', 'conditioner', 'hair mask',
        'perfume', 'cologne', 'body mist',

        // services
        'haircut', 'salon', 'barber', 
        'hair styling', 'hair coloring', 'manicure', 'pedicure', 
        'spa treatment', 'body spa', 'waxing',

        // stores/brands
        'sephora', 'ulta beauty'
      ],

      'Gifts': [
        'gift', 'present', 'souvenir',
        'giftbox', 'gift box', 'boxed gift',
        'gift basket', 'gift wrapping', 'wrapped gift',
        'birthday gift', 'holiday gift', 'christmas gift',
        'anniversary gift', 'wedding gift'
      ],

      'Software': [
        'software', 'app', 'mobile app', 'desktop app',
        'application', 'software license', 'paid app',
        'subscription', 'subscription fee', 
        'monthly subscription', 'annual subscription',
        'renew subscription', 'license renewal',

        // digital services
        'cloud storage', 'online service',

        // common services/brands
        'spotify', 'netflix', 'youtube premium', 'hulu', 'amazon prime',
        'adobe', 'photoshop', 'illustrator', 
        'microsoft office', 'office 365',
        'icloud', 'google drive', 'dropbox', 'vpn'
      ],

      'Tools': [
        'tools', 'hardware', 'hand tools', 
        'construction tools', 'repair tools',
        'tool set', 'tool kit', 'toolbox',

        // common items
        'hammer', 'screwdriver', 'flathead', 'philips head',
        'drill', 'power drill', 'cordless drill',
        'saw', 'hand saw', 'chain saw',
        'wrench', 'spanner', 'pliers',
        'measuring tape', 'sandpaper', 'level',

        // hardware stores
        'hardware store', 'home depot', 'lowes'
      ],
    },
  ),
  'Transport': CategoryPattern(
    mainKeywords: ['transport', 'travel', 'trip', 'commute'],
    subCategoryKeywords: {
      'Bus': ['bus','public bus','city bus','county bus','coach','shuttle','express bus','school bus','night bus','bus pass','bus ticket','bus fare','transport pass','monthly pass','metrobus','greyhound','megabus'],

      'Train': ['train','rail','railway','tube','metro','subway','underground','commuter rail','light rail','high-speed rail','bullet train','driverless','train ticket','train fare','season pass','platform fee','ticket','amtrak','eurostar'],

      'Taxi': ['taxi','cab','yellow cab','ride hail','ride share','uber','uberx','uberxl','lyft','grab','private hire','airport transfer','metered taxi'],

      'Fuel': ['fuel','gas','petrol','gasoline','diesel','premium gasoline','regular gasoline','unleaded','fuel refill','fuel surcharge','filling station','gas station','truck stop','fuel pump','fuel receipt'],

      'Parking': ['parking','parking fee','parking ticket','parking meter','parking garage','car park','parking pass','valet','street parking','overnight parking','public parking','monthly parking'],

      'Maintenance': ['mechanic','auto shop','car service','bike service','tune-up','inspection','oil change','filter change','tire change','wheel alignment','brake replacement','car repair','engine repair','car wash','detailing','body shop','smog check','emission test','servicing'],

      'Insurance': ['car insurance','auto insurance','vehicle insurance','bike insurance','motorcycle insurance','liability coverage','collision coverage','comprehensive coverage','full coverage','insurance premium','deductible'],

      'Toll': ['toll','toll fee','toll booth','toll road','highway fee','turnpike','express lane','fast lane','ez-pass','sunpass','road charge'],
    },
  ),
  'Entertainment': CategoryPattern(
    mainKeywords: ['entertainment', 'fun', 'play'],
    subCategoryKeywords: {
      'Movies': [
        'movie','cinema','film','movie ticket','theatre',
        'netflix','disney+','prime video','imax','hulu',
        'rental','vod','movie pass','popcorn','snacks'
      ],

      'Games': [
        'game','gaming','video game','steam','playstation',
        'xbox','nintendo','in-game purchase','battle pass','dlc',
        'game subscription','epic games','riot','uplay','microtransaction'
      ],

      'Streaming': [
        'streaming','subscription','music subscription','video subscription','monthly plan',
        'spotify','youtube premium','apple tv','crunchyroll','hbo max',
        'subscription fee','annual plan','trial renewal','auto renew'
      ],

      'Events': [
        'event','concert','ticket','show','exhibition',
        'festival','live performance','stand-up','sports event','match pass',
        'meet & greet','venue fee','entry fee','stadium','tour pass'
      ],

      'Hobbies': [
        'hobby','fishing','cycling','collection','toy',
        'gundam','lego','plants','gardening','photography',
        'camping','hiking','diy','crafting','painting'
      ],

      'Travel': [
        'travel','vacation','holiday','trip','hotel',
        'flight','resort','airbnb','booking','rental car',
        'visa fee','baggage fee','cruise','tour package','hostel'
      ],

      'Music': [
        'music','instrument','guitar','piano','drums',
        'song','album','vinyl','concert ticket','music lesson',
        'music sheet','studio time','microphone','mixer','subscription'
      ],
    },
  ),
  'Health': CategoryPattern(
    mainKeywords: ['health', 'medical', 'wellness'],
    subCategoryKeywords: {
      'Doctor': [
        'doctor','clinic','hospital','physician','specialist',
        'consultation','check-up','urgent care','primary care','appointment',
        'private practice','medical visit','co-pay','referral','medical bill'
      ],

      'Pharmacy': [
        'pharmacy','medicine','drug','drugstore','pill',
        'vitamin','supplement','prescription','rx refill','over-the-counter',
        'antibiotics','painkiller','cold medicine','prescription fee','health products'
      ],

      'Gym': [
        'gym','fitness','workout','membership','yoga',
        'pilates','swimming','class pass','personal trainer','fitness program',
        'gym subscription','annual pass','locker fee','sauna','wellness fee'
      ],

      'Insurance': [
        'health insurance','medical insurance','insurance premium','deductible','copayment',
        'claim','coverage','private insurance','annual premium','out-of-pocket'
      ],

      'Mental Health': [
        'therapy','psychologist','counseling','therapist','mental health service',
        'psychiatrist','session fee','support group','diagnosis','mental evaluation',
        'behavioral therapy','online therapy','mental care'
      ],

      'Sports': [
        'sports','gear','equipment','sportswear','athletic shoes',
        'training fee','team registration','court rental','club membership','coaching'
      ],
    },
  ),
  'Education': CategoryPattern(
    mainKeywords: ['education', 'school', 'university', 'college', 'learning'],
    subCategoryKeywords: {
      'Tuition': [
        'tuition','school fee','university fee','course fee','college fee',
        'enrollment fee','semester fee','credit hour fee','lab fee','registration fee'
      ],

      'Books': [
        'book','textbook','novel','magazine','ebook',
        'reference book','journal','publication','study guide','course book'
      ],

      'Courses': [
        'course','class','lesson','training','workshop',
        'seminar','webinar','udemy','coursera','edx',
        'subscription','bootcamp','online course','learning platform','certification'
      ],

      'Supplies': [
        'stationery','pen','pencil','notebook','paper',
        'school supplies','highlighter','binder','folder','ink',
        'printer paper','index cards','sticky notes','eraser','calculator'
      ],
    },
  ),
  'Family': CategoryPattern(
    mainKeywords: ['family', 'kids'],
    subCategoryKeywords: {
      'Childcare': [
        'childcare','babysitter','nanny','daycare','nursery',
        'after-school care','child care center','child support','tutor','preschool fee',
        'babysitting service','caregiver','drop-in care','infant care','kids club'
      ],

      'Toys': [
        'toys','doll','lego','puzzle','board game',
        'action figure','model kit','educational toy','remote car','stuffed animal'
      ],

      'School': [
        'allowance','pocket money','lunch money','school fee','field trip fee',
        'uniform','school lunch','snack money','book fee','activity fee'
      ],

      'Pets': [
        'pet','cat food','dog food','vet','veterinarian',
        'grooming','pet toys','pet supplies','pet clinic','boarding',
        'pet insurance','pet medication','vaccination','pet sitting','pet treats'
      ],
    },
  ),
  'Financial': CategoryPattern(
    mainKeywords: ['financial', 'money', 'admin'],
    subCategoryKeywords: {
      'Taxes': [
        'tax','income tax','property tax','goods tax','sales tax',
        'tax filing','capital gains tax','federal tax','state tax','withholding tax'
      ],

      'Fees': [
        'fee','bank fee','transfer fee','service fee','admin fee',
        'transaction fee','processing fee','maintenance fee','platform fee','monthly fee',
        'overdraft fee','atm fee','late processing fee','annual fee','penalty fee'
      ],

      'Fines': [
        'fine','penalty','late fee','ticket','violation fee',
        'parking fine','speeding ticket','court fine','traffic citation','regulatory penalty'
      ],

      'Insurance': [
        'insurance','life insurance','premium','insurance fee','coverage',
        'accident insurance','annual premium','policy payment','deductible','insurance claim'
      ],
    },
  ),
  'Personal': CategoryPattern(
    mainKeywords: ['personal', 'self care'],
    subCategoryKeywords: {
      'Haircut': [
        'haircut','barber','salon','hair styling','hair trim',
        'hair coloring','hair treatment','barbershop','hair appointment','hair wash'
      ],

      'Spa': [
        'spa','massage','sauna','reflexology','steam room',
        'spa treatment','aromatherapy','facial','hot stone massage','spa package'
      ],

      'Cosmetics': [
        'cosmetics','makeup','beauty products','skincare','lotion',
        'cream','serum','foundation','compact powder','lipstick',
        'concealer','moisturizer','toner','cleanser','sunscreen'
      ],
    },
  ),
  'Income': CategoryPattern(
    mainKeywords: ['income', 'earning'],
    subCategoryKeywords: {
      'Salary': ['salary', 'wage', 'paycheck', 'payroll'],
      'Business': ['business', 'sales', 'revenue', 'profit'],
      'Investments': ['investment', 'dividend', 'interest', 'crypto', 'stock', 'rent income'],
      'Gifts': ['gift', 'birthday money', 'bonus', 'allowance'],
    }
  ),
};
