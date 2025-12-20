import 'package:flutter/material.dart';
import '../../../localization/generated/app_localizations.dart';
import '../../categories/domain/category.dart';

class CategoryLocalizationHelper {
  static String getLocalizedCategoryName(BuildContext context, Category category) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return category.name;

    String? key = category.externalId;
    
    // Fallback: Try to find key by name if externalId is missing
    if (key == null) {
      key = _englishNameToExternalId[category.name.toLowerCase()];
    }

    if (key == null) return category.name;

    final map = _getCategoryMap(l10n);
    return map[key] ?? category.name;
  }

  static String getLocalizedSubCategoryName(BuildContext context, SubCategory subCategory) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return subCategory.name ?? '';

    String? key = subCategory.id;

    // Fallback: Try to find key by name if id (externalId for sub) is missing or just looks like a name
    // Note: SubCategory 'id' in this project seems to serve as externalId string.
    if (key == null) {
        // Simple mapping or direct lower case check if key usually matches name
        key = subCategory.name?.toLowerCase();
    }

    if (key == null) return subCategory.name ?? '';

    final map = _getSubCategoryMap(l10n);
    return map[key] ?? subCategory.name ?? '';
  }

  static Map<String, String> _getCategoryMap(AppLocalizations l10n) {
    return {
      'food': l10n.category_food,
      'transport': l10n.category_transport,
      'shopping': l10n.category_shopping,
      'housing': l10n.category_housing,
      'entertainment': l10n.category_entertainment,
      'health': l10n.category_health,
      'education': l10n.category_education,
      'personal': l10n.category_personal,
      'financial': l10n.category_financial,
      'family': l10n.category_family,
      'salary': l10n.category_salary,
      'business': l10n.category_business,
      'investments': l10n.category_investments,
      'gifts_income': l10n.category_gifts_income,
      'other_income': l10n.category_other_income,
      
      // System Categories
      'system': l10n.system,
      'wishlist': l10n.wishlist,
      'bills': l10n.bills,
      'debts': l10n.debts,
      'savings': l10n.savings,
      'recurring': l10n.recurring,
      'reimburse': l10n.reimburse,
      'smartNotes': l10n.smartNotesTitle,
    };
  }

  // Fallback: Map common English names to externalIds
  static const Map<String, String> _englishNameToExternalId = {
    'food & drink': 'food',
    'food': 'food',
    'transportation': 'transport',
    'transport': 'transport',
    'shopping': 'shopping',
    'housing': 'housing',
    'entertainment': 'entertainment',
    'health': 'health',
    'education': 'education',
    'personal care': 'personal',
    'personal': 'personal',
    'financial': 'financial',
    'family': 'family',
    'salary': 'salary',
    'business': 'business',
    'investments': 'investments',
    'gifts': 'gifts_income',
    'other income': 'other_income',
  };

  static const Map<String, String> _englishSubNameToExternalId = {
     'breakfast': 'breakfast',
     'lunch': 'lunch',
     'dinner': 'dinner',
     'movies': 'movies',
     // Add more if needed, but subcategories usually match ID
  };

  static Map<String, String> _getSubCategoryMap(AppLocalizations l10n) {
    return {
      'breakfast': l10n.subcategory_breakfast,
      'lunch': l10n.subcategory_lunch,
      'dinner': l10n.subcategory_dinner,
      'eateries': l10n.subcategory_eateries,
      'snacks': l10n.subcategory_snacks,
      'drinks': l10n.subcategory_drinks,
      'groceries': l10n.subcategory_groceries,
      'delivery': l10n.subcategory_delivery,
      'alcohol': l10n.subcategory_alcohol,

      'bus': l10n.subcategory_bus,
      'train': l10n.subcategory_train,
      'taxi': l10n.subcategory_taxi,
      'fuel': l10n.subcategory_fuel,
      'parking': l10n.subcategory_parking,
      'maintenance': l10n.subcategory_maintenance,
      'insurance_car': l10n.subcategory_insurance_car,
      'toll': l10n.subcategory_toll,

      'clothes': l10n.subcategory_clothes,
      'electronics': l10n.subcategory_electronics,
      'home': l10n.subcategory_home,
      'beauty': l10n.subcategory_beauty,
      'gifts': l10n.subcategory_gifts,
      'software': l10n.subcategory_software,
      'tools': l10n.subcategory_tools,

      'rent': l10n.subcategory_rent,
      'mortgage': l10n.subcategory_mortgage,
      'utilities': l10n.subcategory_utilities,
      'internet': l10n.subcategory_internet,
      'maintenance_home': l10n.subcategory_maintenance_home,
      'furniture': l10n.subcategory_furniture,
      'services': l10n.subcategory_services,

      'movies': l10n.subcategory_movies,
      'games': l10n.subcategory_games,
      'streaming': l10n.subcategory_streaming,
      'events': l10n.subcategory_events,
      'hobbies': l10n.subcategory_hobbies,
      'travel': l10n.subcategory_travel,
      'music': l10n.subcategory_music,

      'doctor': l10n.subcategory_doctor,
      'pharmacy': l10n.subcategory_pharmacy,
      'gym': l10n.subcategory_gym,
      'insurance_health': l10n.subcategory_insurance_health,
      'mental_health': l10n.subcategory_mental_health,
      'sports': l10n.subcategory_sports,

      'tuition': l10n.subcategory_tuition,
      'books': l10n.subcategory_books,
      'courses': l10n.subcategory_courses,
      'supplies': l10n.subcategory_supplies,

      'haircut': l10n.subcategory_haircut,
      'spa': l10n.subcategory_spa,
      'cosmetics': l10n.subcategory_cosmetics,

      'taxes': l10n.subcategory_taxes,
      'fees': l10n.subcategory_fees,
      'fines': l10n.subcategory_fines,
      'insurance_life': l10n.subcategory_insurance_life,

      'childcare': l10n.subcategory_childcare,
      'toys': l10n.subcategory_toys,
      'school_kids': l10n.subcategory_school_kids,
      'pets': l10n.subcategory_pets,

      'monthly': l10n.subcategory_monthly,
      'weekly': l10n.subcategory_weekly,
      'bonus': l10n.subcategory_bonus,
      'overtime': l10n.subcategory_overtime,

      'sales': l10n.subcategory_sales,
      'profit': l10n.subcategory_profit,

      'dividends': l10n.subcategory_dividends,
      'interest': l10n.subcategory_interest,
      'crypto': l10n.subcategory_crypto,
      'stocks': l10n.subcategory_stocks,
      'real_estate': l10n.subcategory_real_estate,

      'birthday': l10n.subcategory_birthday,
      'holiday': l10n.subcategory_holiday,
      'allowance': l10n.subcategory_allowance,

      'refunds': l10n.subcategory_refunds,
      'grants': l10n.subcategory_grants,
      'lottery': l10n.subcategory_lottery,
      'selling': l10n.subcategory_selling,
    };
  }
}
