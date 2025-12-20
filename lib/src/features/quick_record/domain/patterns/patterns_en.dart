import 'pattern_base.dart';

const Map<String, CategoryPattern> englishPatterns = {
  // --- EXPENSE ---
  'Food & Drink': CategoryPattern(
    mainKeywords: ['food', 'drink', 'eat', 'beverage', 'meal', 'hungry', 'thirsty'],
    subCategoryKeywords: {
      'Breakfast': [
        'breakfast', 'morning coffee', 'cereal', 'toast', 'eggs', 'pancakes', 'waffles', 'bacon'
      ],

      'Lunch': [
        'lunch', 'lunch break', 'noon meal', 'having lunch'
      ],

      'Dinner': [
        'dinner', 'supper', 'evening meal', 'dining out', 'dine out', 'late dinner'
      ],

      'Eateries': [
        'restaurant', 'cafe', 'diner', 'bistro', 'food stall', 'street food', 'fast food',
        'kfc', 'mcdonalds', 'burger king', 'pizza hut', 'dominos', 'subway', 'starbucks'
      ],

      'Snacks': [
        'snack', 'chips', 'chocolate', 'candy', 'cookies', 'cake', 'biscuit', 'donut', 'croissant', 'ice cream'
      ],

      'Drinks': [
        'drink', 'coffee', 'tea', 'latte', 'cappuccino', 'espresso', 'juice', 'milk', 
        'soft drink', 'soda', 'beverage', 'water', 'mineral water', 'smoothie', 'milkshake'
      ],

      'Groceries': [
        'grocery', 'groceries', 'market', 'supermarket', 'convenience store', 
        'vegetables', 'fruits', 'meat', 'fish', 'rice', 'oil', 'bread', 'milk', 'eggs'
      ],

      'Delivery': [
        'delivery', 'food delivery', 'order food', 'order online', 'uber eats', 'door dash', 'delivery fee'
      ],

      'Alcohol': [
        'alcohol', 'beer', 'wine', 'liquor', 'whiskey', 'vodka', 'gin', 'tequila', 'cocktail', 'rum'
      ],
    },
  ),
  'Housing': CategoryPattern(
    mainKeywords: ['house', 'home', 'apartment', 'place'],
    subCategoryKeywords: {
      'Rent': [
        'rent', 'monthly rent', 'apartment rent', 'lease', 'housing'
      ],

      'Mortgage': [
        'mortgage', 'home loan', 'housing loan', 'property loan'
      ],

      'Utilities': [
        'utilities', 'electricity', 'water bill', 'power bill', 'gas bill', 'utility bill', 'electric bill'
      ],

      'Internet': [
        'internet', 'wifi', 'data plan', 'mobile data', 'internet bill', 'broadband'
      ],

      'Maintenance': [
        'maintenance', 'repair', 'fix', 'plumber', 'electrician', 'service ac', 'renovation', 'painting'
      ],

      'Furniture': [
        'furniture', 'decor', 'bed', 'sofa', 'table', 'chair', 'cupboard', 
        'bed sheet', 'curtain', 'pillow', 'rug', 'carpet', 'shelf', 'cabinet'
      ],

      'Services': [
        'security', 'cleaning', 'trash', 'garbage', 'pest control', 'maid', 'housekeeper'
      ],
    },
  ),
  'Shopping': CategoryPattern(
    mainKeywords: ['shopping', 'buy', 'purchase'],
    subCategoryKeywords: {
      'Clothes': [
        'clothes', 'clothing', 'apparel', 'fashion', 'outfit',
        'shirt', 'pants', 'trousers', 'jeans', 'dress', 'jacket', 'hoodie', 'shoes', 'sneakers', 'socks', 'underwear'
      ],

      'Electronics': [
        'electronics', 'gadget',
        'phone', 'mobile', 'computer', 'laptop', 'charger', 'headphones', 'earbuds', 
        'television', 'tv', 'washing machine', 'fridge', 'tablet', 'camera'
      ],

      'Home': [
        'home appliances', 'kitchenware', 'cookware', 'utensils', 'bedding', 'bath'
      ],

      'Beauty': [
        'beauty', 'cosmetics', 'makeup', 'skincare',
        'lipstick', 'foundation', 'powder', 'serum', 'moisturizer', 'facial', 
        'soap', 'body wash', 'shampoo', 'conditioner', 'perfume', 'haircut', 'salon', 'barber'
      ],

      'Gifts': [
        'gift', 'present', 'souvenir', 'giftbox'
      ],

      'Software': [
        'software', 'app', 'application', 'subscription', 'license',
        'spotify', 'netflix', 'youtube premium', 'adobe', 'microsoft office', 'icloud', 'google drive'
      ],

      'Tools': [
        'tools', 'hardware', 'hammer', 'screwdriver', 'drill', 'saw', 'wrench', 'toolkit'
      ],
    },
  ),
  'Transport': CategoryPattern(
    mainKeywords: ['transport', 'travel', 'trip', 'commute'],
    subCategoryKeywords: {
      'Bus': [
        'bus', 'public bus', 'city bus', 'bus ticket', 'bus fare'
      ],

      'Train': [
        'train', 'subway', 'metro', 'driverless', 'tube', 'railway', 'train ticket', 'train fare', 'ticket'
      ],

      'Taxi': [
        'taxi', 'cab', 'uber', 'lyft', 'ride share', 'grab'
      ],

      'Fuel': [
        'fuel', 'gas', 'petrol', 'gasoline', 'diesel', 'filling station', 'gas station'
      ],

      'Parking': [
        'parking', 'parking fee', 'parking ticket', 'valet'
      ],

      'Maintenance': [
        'mechanic', 'car service', 'bike service', 'oil change', 'tire change', 'car repair', 'car wash'
      ],

      'Insurance': [
        'car insurance', 'vehicle insurance', 'bike insurance'
      ],

      'Toll': [
        'toll', 'toll fee', 'toll road', 'highway fee'
      ],
    },
  ),
  'Entertainment': CategoryPattern(
    mainKeywords: ['entertainment', 'fun', 'play'],
    subCategoryKeywords: {
      'Movies': [
        'movie', 'cinema', 'film', 'movie ticket', 'theatre', 'netflix', 'disney+', 'prime video'
      ],

      'Games': [
        'game', 'gaming', 'video game', 'steam', 'playstation', 'xbox', 'nintendo', 'in-game purchase'
      ],

      'Streaming': [
        'streaming', 'subscription', 'music subscription', 'video subscription'
      ],

      'Events': [
        'event', 'concert', 'ticket', 'show', 'exhibition', 'festival'
      ],

      'Hobbies': [
        'hobby', 'fishing', 'cycling', 'collection', 'toy', 'gundam', 'lego', 'plants', 'gardening'
      ],

      'Travel': [
        'travel', 'vacation', 'holiday', 'trip', 'hotel', 'flight', 'resort', 'airbnb', 'booking'
      ],

      'Music': [
        'music', 'instrument', 'guitar', 'piano', 'drums', 'song', 'album'
      ],
    },
  ),
  'Health': CategoryPattern(
    mainKeywords: ['health', 'medical', 'wellness'],
    subCategoryKeywords: {
      'Doctor': ['doctor', 'clinic', 'hospital', 'physician', 'specialist', 'consultation'],
      'Pharmacy': ['pharmacy', 'medicine', 'drug', 'drugstore', 'pill', 'vitamin', 'supplement', 'prescription'],
      'Gym': ['gym', 'fitness', 'workout', 'membership', 'yoga', 'pilates', 'swimming'],
      'Insurance': ['health insurance', 'medical insurance'],
      'Mental Health': ['therapy', 'psychologist', 'counseling', 'therapist'],
      'Sports': ['sports', 'gear', 'equipment'],
    },
  ),
  'Education': CategoryPattern(
    mainKeywords: ['education', 'school', 'university', 'college', 'learning'],
    subCategoryKeywords: {
      'Tuition': ['tuition', 'school fee', 'university fee', 'course fee'],
      'Books': ['book', 'textbook', 'novel', 'magazine'],
      'Courses': ['course', 'class', 'lesson', 'training', 'workshop', 'seminar', 'webinar', 'udemy', 'coursera'],
      'Supplies': ['stationery', 'pen', 'pencil', 'notebook', 'paper', 'school supplies'],
    },
  ),
  'Family': CategoryPattern(
    mainKeywords: ['family', 'kids'],
    subCategoryKeywords: {
      'Childcare': ['childcare', 'babysitter', 'nanny', 'daycare'],
      'Toys': ['toys', 'doll', 'lego'],
      'School': ['allowance', 'pocket money'],
      'Pets': ['pet', 'cat food', 'dog food', 'vet', 'veterinarian'],
    },
  ),
  'Financial': CategoryPattern(
    mainKeywords: ['financial', 'money', 'admin'],
    subCategoryKeywords: {
      'Taxes': ['tax', 'income tax', 'property tax', 'goods tax'],
      'Fees': ['fee', 'bank fee', 'transfer fee', 'service fee', 'admin fee', 'transaction fee'],
      'Fines': ['fine', 'penalty', 'late fee', 'ticket'],
      'Insurance': ['insurance', 'life insurance', 'premium'],
    },
  ),
  'Personal': CategoryPattern(
    mainKeywords: ['personal', 'self care'],
    subCategoryKeywords: {
      'Haircut': ['haircut', 'barber', 'salon', 'hair styling'],
      'Spa': ['spa', 'massage', 'sauna', 'reflexology'],
      'Cosmetics': ['cosmetics', 'makeup', 'beauty products', 'skincare', 'lotion', 'cream'],
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
