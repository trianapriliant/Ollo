import 'pattern_base.dart';

// -----------------------------------------------------------------------------
// TEMPLATE FOR NEW LANGUAGE PATTERNS
// -----------------------------------------------------------------------------
// 1. Copy this file and rename it to patterns_<code>.dart (e.g., patterns_jp.dart)
// 2. Rename the variable `templatePatterns` to something unique (e.g., japanesePatterns)
// 3. Translate keywords in the list. Keep existing keys (Food & Drink, Breakfast, etc.) exactly as is!
// 4. Register in pattern_manager.dart
// -----------------------------------------------------------------------------

const Map<String, CategoryPattern> templatePatterns = {
  // --- EXPENSE ---
  'Food & Drink': CategoryPattern(
    mainKeywords: ['food', 'drink'], // Main category triggers
    subCategoryKeywords: {
      'Breakfast': ['breakfast keyword 1', 'breakfast keyword 2'],
      'Lunch': [],
      'Dinner': [],
      'Eateries': [], // Restaurants, Street Food
      'Snacks': [],
      'Drinks': [],
      'Groceries': [],
      'Delivery': [], // Food delivery services
      'Alcohol': [],
    },
  ),
  'Housing': CategoryPattern(
    mainKeywords: ['house', 'home'],
    subCategoryKeywords: {
      'Rent': [],
      'Mortgage': [],
      'Utilities': [], // Electricity, Water, Gas
      'Internet': [],
      'Maintenance': [], // Repairs
      'Furniture': [],
      'Services': [], // Cleaning, Security
    },
  ),
  'Shopping': CategoryPattern(
    mainKeywords: ['shopping', 'buy'],
    subCategoryKeywords: {
      'Clothes': [],
      'Electronics': [],
      'Home': [], // Household items
      'Beauty': [], // Skincare, Salon
      'Gifts': [],
      'Software': [], // Apps, Subscriptions
      'Tools': [],
    },
  ),
  'Transport': CategoryPattern(
    mainKeywords: ['transport', 'trip'],
    subCategoryKeywords: {
      'Bus': [],
      'Train': [],
      'Taxi': [], // Including Ride Hailing
      'Fuel': [],
      'Parking': [],
      'Maintenance': [], // Vehicle service
      'Insurance': [],
      'Toll': [],
    },
  ),
  'Entertainment': CategoryPattern(
    mainKeywords: ['entertainment', 'fun'],
    subCategoryKeywords: {
      'Movies': [],
      'Games': [],
      'Streaming': [], // Netflix, Spotify
      'Events': [], // Concerts
      'Hobbies': [],
      'Travel': [], // Holiday
      'Music': [], // Instruments
    },
  ),
  'Health': CategoryPattern(
    mainKeywords: ['health', 'medical'],
    subCategoryKeywords: {
      'Doctor': [],
      'Pharmacy': [],
      'Gym': [],
      'Insurance': [],
      'Mental Health': [],
      'Sports': [],
    },
  ),
  'Education': CategoryPattern(
    mainKeywords: ['education', 'school'],
    subCategoryKeywords: {
      'Tuition': [],
      'Books': [],
      'Courses': [],
      'Supplies': [],
    },
  ),
  'Family': CategoryPattern(
    mainKeywords: ['family'],
    subCategoryKeywords: {
      'Childcare': [],
      'Toys': [],
      'School': [], // Kids school money
      'Pets': [],
    },
  ),
  'Financial': CategoryPattern(
    mainKeywords: ['money', 'finance'],
    subCategoryKeywords: {
      'Taxes': [],
      'Fees': [], // Admin fees
      'Fines': [],
      'Insurance': [],
    },
  ),
  'Personal': CategoryPattern(
    mainKeywords: ['personal'],
    subCategoryKeywords: {
      'Haircut': [],
      'Spa': [],
      'Cosmetics': [],
    },
  ),

  // --- INCOME ---
  'Salary': CategoryPattern(
    mainKeywords: ['salary'],
    subCategoryKeywords: {
      'Monthly': [],
      'Weekly': [],
      'Bonus': [],
      'Overtime': [],
    },
  ),
  'Business': CategoryPattern(
    mainKeywords: ['business'],
    subCategoryKeywords: {
      'Sales': [],
      'Services': [],
      'Profit': [],
    },
  ),
  'Investments': CategoryPattern(
    mainKeywords: ['investment'],
    subCategoryKeywords: {
      'Dividends': [],
      'Interest': [],
      'Crypto': [],
      'Stocks': [],
      'Real Estate': [],
    },
  ),
  'Gifts': CategoryPattern( // Incoming gifts
    mainKeywords: ['gift income'],
    subCategoryKeywords: {
      'Birthday': [],
      'Holiday': [], // Angpao, THR
      'Allowance': [],
    },
  ),
  'Other': CategoryPattern( // Income
    mainKeywords: ['other income'],
    subCategoryKeywords: {
      'Refunds': [],
      'Grants': [],
      'Lottery': [],
      'Selling': [], // Selling used items
    },
  ),
};
