import 'package:flutter/material.dart';
import '../features/settings/presentation/icon_style_provider.dart';

class IconHelper {
  /// Get icon with the current style applied
  /// This method converts the base filled icon to the requested variant
  static IconData getIconWithStyle(String iconName, IconStyle style) {
    final baseIcon = getIcon(iconName);
    return _applyStyle(baseIcon, style);
  }

  /// Apply style variant to an IconData
  /// Material Icons have a consistent pattern for variants:
  /// - Filled: base codepoint
  /// - Outlined: usually base + offset or _outlined suffix
  /// - Rounded: _rounded suffix
  /// - Sharp: _sharp suffix
  static IconData _applyStyle(IconData baseIcon, IconStyle style) {
    if (style == IconStyle.filled) return baseIcon;
    
    // For icons that have known variants, we use a lookup
    // This covers the most commonly used icons
    final variantMap = _getVariantMap(baseIcon);
    if (variantMap != null) {
      switch (style) {
        case IconStyle.outlined:
          return variantMap['outlined'] ?? baseIcon;
        case IconStyle.rounded:
          return variantMap['rounded'] ?? baseIcon;
        case IconStyle.sharp:
          return variantMap['sharp'] ?? baseIcon;
        case IconStyle.filled:
          return baseIcon;
      }
    }
    
    // Fallback: return base icon if no variant found
    return baseIcon;
  }

  /// Get variant map for common icons
  static Map<String, IconData>? _getVariantMap(IconData icon) {
    // Most frequently used icons with their variants
    final variants = <int, Map<String, IconData>>{
      Icons.home.codePoint: {
        'outlined': Icons.home_outlined,
        'rounded': Icons.home_rounded,
        'sharp': Icons.home_sharp,
      },
      Icons.shopping_bag.codePoint: {
        'outlined': Icons.shopping_bag_outlined,
        'rounded': Icons.shopping_bag_rounded,
        'sharp': Icons.shopping_bag_sharp,
      },
      Icons.account_balance_wallet.codePoint: {
        'outlined': Icons.account_balance_wallet_outlined,
        'rounded': Icons.account_balance_wallet_rounded,
        'sharp': Icons.account_balance_wallet_sharp,
      },
      Icons.credit_card.codePoint: {
        'outlined': Icons.credit_card_outlined,
        'rounded': Icons.credit_card_rounded,
        'sharp': Icons.credit_card_sharp,
      },
      Icons.savings.codePoint: {
        'outlined': Icons.savings_outlined,
        'rounded': Icons.savings_rounded,
        'sharp': Icons.savings_sharp,
      },
      Icons.favorite.codePoint: {
        'outlined': Icons.favorite_outline,
        'rounded': Icons.favorite_rounded,
        'sharp': Icons.favorite_sharp,
      },
      Icons.fastfood.codePoint: {
        'outlined': Icons.fastfood_outlined,
        'rounded': Icons.fastfood_rounded,
        'sharp': Icons.fastfood_sharp,
      },
      Icons.directions_car.codePoint: {
        'outlined': Icons.directions_car_outlined,
        'rounded': Icons.directions_car_rounded,
        'sharp': Icons.directions_car_sharp,
      },
      Icons.restaurant.codePoint: {
        'outlined': Icons.restaurant_outlined,
        'rounded': Icons.restaurant_rounded,
        'sharp': Icons.restaurant_sharp,
      },
      Icons.local_cafe.codePoint: {
        'outlined': Icons.local_cafe_outlined,
        'rounded': Icons.local_cafe_rounded,
        'sharp': Icons.local_cafe_sharp,
      },
      Icons.medical_services.codePoint: {
        'outlined': Icons.medical_services_outlined,
        'rounded': Icons.medical_services_rounded,
        'sharp': Icons.medical_services_sharp,
      },
      Icons.movie.codePoint: {
        'outlined': Icons.movie_outlined,
        'rounded': Icons.movie_rounded,
        'sharp': Icons.movie_sharp,
      },
      Icons.work.codePoint: {
        'outlined': Icons.work_outline,
        'rounded': Icons.work_rounded,
        'sharp': Icons.work_sharp,
      },
      Icons.school.codePoint: {
        'outlined': Icons.school_outlined,
        'rounded': Icons.school_rounded,
        'sharp': Icons.school_sharp,
      },
      Icons.pets.codePoint: {
        'outlined': Icons.pets_outlined,
        'rounded': Icons.pets_rounded,
        'sharp': Icons.pets_sharp,
      },
      Icons.child_care.codePoint: {
        'outlined': Icons.child_care_outlined,
        'rounded': Icons.child_care_rounded,
        'sharp': Icons.child_care_sharp,
      },
      Icons.receipt.codePoint: {
        'outlined': Icons.receipt_outlined,
        'rounded': Icons.receipt_rounded,
        'sharp': Icons.receipt_sharp,
      },
      Icons.handshake.codePoint: {
        'outlined': Icons.handshake_outlined,
        'rounded': Icons.handshake_rounded,
        'sharp': Icons.handshake_sharp,
      },
      Icons.settings.codePoint: {
        'outlined': Icons.settings_outlined,
        'rounded': Icons.settings_rounded,
        'sharp': Icons.settings_sharp,
      },
      Icons.person.codePoint: {
        'outlined': Icons.person_outline,
        'rounded': Icons.person_rounded,
        'sharp': Icons.person_sharp,
      },
      Icons.people.codePoint: {
        'outlined': Icons.people_outline,
        'rounded': Icons.people_rounded,
        'sharp': Icons.people_sharp,
      },
      Icons.star.codePoint: {
        'outlined': Icons.star_outline,
        'rounded': Icons.star_rounded,
        'sharp': Icons.star_sharp,
      },
      Icons.shopping_cart.codePoint: {
        'outlined': Icons.shopping_cart_outlined,
        'rounded': Icons.shopping_cart_rounded,
        'sharp': Icons.shopping_cart_sharp,
      },
      Icons.store.codePoint: {
        'outlined': Icons.store_outlined,
        'rounded': Icons.store_rounded,
        'sharp': Icons.store_sharp,
      },
      Icons.local_mall.codePoint: {
        'outlined': Icons.local_mall_outlined,
        'rounded': Icons.local_mall_rounded,
        'sharp': Icons.local_mall_sharp,
      },
      Icons.flight.codePoint: {
        'outlined': Icons.flight_outlined,
        'rounded': Icons.flight_rounded,
        'sharp': Icons.flight_sharp,
      },
      Icons.train.codePoint: {
        'outlined': Icons.train_outlined,
        'rounded': Icons.train_rounded,
        'sharp': Icons.train_sharp,
      },
      Icons.local_hospital.codePoint: {
        'outlined': Icons.local_hospital_outlined,
        'rounded': Icons.local_hospital_rounded,
        'sharp': Icons.local_hospital_sharp,
      },
      Icons.fitness_center.codePoint: {
        'outlined': Icons.fitness_center_outlined,
        'rounded': Icons.fitness_center_rounded,
        'sharp': Icons.fitness_center_sharp,
      },
      Icons.music_note.codePoint: {
        'outlined': Icons.music_note_outlined,
        'rounded': Icons.music_note_rounded,
        'sharp': Icons.music_note_sharp,
      },
      Icons.sports_esports.codePoint: {
        'outlined': Icons.sports_esports_outlined,
        'rounded': Icons.sports_esports_rounded,
        'sharp': Icons.sports_esports_sharp,
      },
      Icons.category.codePoint: {
        'outlined': Icons.category_outlined,
        'rounded': Icons.category_rounded,
        'sharp': Icons.category_sharp,
      },
      Icons.account_balance.codePoint: {
        'outlined': Icons.account_balance_outlined,
        'rounded': Icons.account_balance_rounded,
        'sharp': Icons.account_balance_sharp,
      },
      Icons.wallet.codePoint: {
        'outlined': Icons.wallet_outlined,
        'rounded': Icons.wallet_rounded,
        'sharp': Icons.wallet_sharp,
      },
    };
    
    return variants[icon.codePoint];
  }

  static IconData getIcon(String iconName) {
    switch (iconName.toLowerCase().trim()) {
      // Finance & Wallet
      case 'account_balance_wallet': return Icons.account_balance_wallet;
      case 'account_balance': return Icons.account_balance;
      case 'credit_card': return Icons.credit_card;
      case 'payments': return Icons.payments;
      case 'savings': return Icons.savings;
      case 'monetization_on': return Icons.monetization_on;
      case 'wallet': return Icons.wallet;
      case 'money': return Icons.wallet; // Mapped 'money' to Wallet icon as requested
      case 'cash': return Icons.wallet; // Mapped 'cash' to Wallet icon as requested, just in case
      case 'currency_exchange': return Icons.currency_exchange;
      case 'transfer': return Icons.swap_horiz; // Added Transfer icon
      case 'send_money': return Icons.send;
      case 'compare_arrows': return Icons.compare_arrows;
      case 'account_box': return Icons.account_box;
      
      // Shopping & Retail
      case 'shopping_bag': return Icons.shopping_bag;
      case 'shopping_cart': return Icons.shopping_cart;
      case 'store': return Icons.store;
      case 'local_mall': return Icons.local_mall;
      case 'redeem': return Icons.redeem;
      case 'card_giftcard': return Icons.card_giftcard;
      case 'sell': return Icons.sell;
      case 'checkroom': return Icons.checkroom;
      case 'local_grocery_store': return Icons.local_grocery_store;
      case 'groceries': return Icons.local_grocery_store;
      case 'food': return Icons.fastfood;
      case 'transport': return Icons.directions_car;
      
      // Transport & Travel
      case 'directions_car': return Icons.directions_car;
      case 'directions_bus': return Icons.directions_bus;
      case 'flight': return Icons.flight;
      case 'train': return Icons.train;
      case 'local_taxi': return Icons.local_taxi;
      case 'two_wheeler': return Icons.two_wheeler;
      case 'directions_boat': return Icons.directions_boat;
      case 'local_gas_station': return Icons.local_gas_station;
      case 'commute': return Icons.commute;
      
      // Home & Living
      case 'home': return Icons.home;
      case 'house': return Icons.home; // Added mapping for 'house'
      case 'apartment': return Icons.apartment;
      case 'cottage': return Icons.cottage;
      case 'weekend': return Icons.weekend;
      case 'chair': return Icons.chair;
      case 'bed': return Icons.bed;
      case 'kitchen': return Icons.kitchen;
      
      // Food & Drink
      case 'fastfood': return Icons.fastfood;
      case 'restaurant': return Icons.restaurant;
      case 'local_cafe': return Icons.local_cafe;
      case 'local_bar': return Icons.local_bar;
      case 'bakery_dining': return Icons.bakery_dining;
      case 'lunch_dining': return Icons.lunch_dining;
      case 'dinner_dining': return Icons.dinner_dining;
      case 'icecream': return Icons.icecream;
      case 'coffee': return Icons.coffee;
      case 'cake': return Icons.cake;
      case 'liquor': return Icons.liquor;
      
      // Health & Wellness
      case 'medical_services': return Icons.medical_services;
      case 'local_hospital': return Icons.local_hospital;
      case 'local_pharmacy': return Icons.local_pharmacy;
      case 'fitness_center': return Icons.fitness_center;
      case 'pool': return Icons.pool;
      case 'spa': return Icons.spa;
      case 'monitor_heart': return Icons.monitor_heart;
      
      // Entertainment & Leisure
      case 'movie': return Icons.movie;
      case 'sports_esports': return Icons.sports_esports;
      case 'music_note': return Icons.music_note;
      case 'camera_alt': return Icons.camera_alt;
      case 'live_tv': return Icons.live_tv;
      case 'theater_comedy': return Icons.theater_comedy;
      case 'sports_soccer': return Icons.sports_soccer;
      case 'sports_basketball': return Icons.sports_basketball;
      case 'sports_tennis': return Icons.sports_tennis;
      case 'sports_golf': return Icons.sports_golf;
      case 'sports_football': return Icons.sports_football;
      case 'sports_volleyball': return Icons.sports_volleyball;
      case 'pool': return Icons.pool;
      case 'kitesurfing': return Icons.kitesurfing;
      case 'surfing': return Icons.surfing;
      case 'palette': return Icons.palette;
      case 'brush': return Icons.brush;
      case 'piano': return Icons.piano;
      case 'mic': return Icons.mic;
      case 'headphones': return Icons.headphones;
      
      // Nature & Outdoors
      case 'forest': return Icons.forest;
      case 'terrain': return Icons.terrain;
      case 'landscape': return Icons.landscape;
      case 'beach_access': return Icons.beach_access;
      case 'park': return Icons.park;
      case 'wb_sunny': return Icons.wb_sunny;
      case 'nightlight': return Icons.nightlight;
      case 'local_florist': return Icons.local_florist;
      case 'grass': return Icons.grass;
      case 'hiking': return Icons.hiking;
      case 'eco': return Icons.eco;
      case 'shopping_basket': return Icons.shopping_basket;
      case 'apple': return Icons.apple;
      case 'fruits': return Icons.apple;
      
      // Family & People
      case 'person': return Icons.person;
      case 'people': return Icons.people;
      case 'group': return Icons.group;
      case 'groups': return Icons.groups;
      case 'child_friendly': return Icons.child_friendly;
      case 'baby_changing_station': return Icons.baby_changing_station;
      case 'family_restroom': return Icons.family_restroom;
      case 'face': return Icons.face;
      case 'mood': return Icons.mood;
      case 'send': return Icons.send;

      
      // Activity & Fitness
      case 'directions_run': return Icons.directions_run;
      case 'directions_walk': return Icons.directions_walk;
      case 'directions_bike': return Icons.directions_bike;
      case 'fitness_center': return Icons.fitness_center;
      case 'self_improvement': return Icons.self_improvement;
      
      // Work & Education
      case 'work': return Icons.work;
      case 'school': return Icons.school;
      case 'menu_book': return Icons.menu_book;
      case 'computer': return Icons.computer;
      case 'business_center': return Icons.business_center;
      case 'science': return Icons.science;
      case 'calculate': return Icons.calculate;
      case 'architecture': return Icons.architecture;
      case 'construction': return Icons.construction;
      case 'engineering': return Icons.engineering;
      
      // Technology & Devices
      case 'smartphone': return Icons.smartphone;
      case 'laptop': return Icons.laptop;
      case 'headphones': return Icons.headphones;
      case 'watch': return Icons.watch;
      case 'router': return Icons.router;
      case 'gamepad': return Icons.gamepad;
      
      // Others
      case 'pets': return Icons.pets;
      case 'child_care': return Icons.child_care;
      case 'card_travel': return Icons.card_travel;
      case 'explore': return Icons.explore;
      case 'favorite': return Icons.favorite;
      case 'star': return Icons.star;
      case 'lock': return Icons.lock;
      case 'key': return Icons.key;
      case 'build': return Icons.build;
      case 'delete': return Icons.delete;
      case 'bolt': return Icons.bolt;
      case 'water_drop': return Icons.water_drop;
      case 'wifi': return Icons.wifi;
      case 'receipt': return Icons.receipt;
      case 'attach_money': return Icons.attach_money;
      case 'trending_up': return Icons.trending_up;
      case 'pie_chart': return Icons.pie_chart;
      case 'currency_bitcoin': return Icons.currency_bitcoin;
      case 'help': return Icons.help_outline;
      
      case 'local_pizza': return Icons.local_pizza;
      case 'cleaning_services': return Icons.cleaning_services;
      case 'celebration': return Icons.celebration;
      case 'more_horiz': return Icons.more_horiz;
      case 'lightbulb': return Icons.lightbulb;
      case 'healing': return Icons.healing;
      case 'theater_comedy': return Icons.theater_comedy;
      case 'casino': return Icons.casino;
      case 'receipt_long': return Icons.receipt_long;
      case 'handshake': return Icons.handshake;
      case 'category': return Icons.category;
      
      // System Category Aliases
      case 'debt': return Icons.handshake;
      case 'debts': return Icons.handshake;
      case 'bill': return Icons.receipt_long;
      case 'bills': return Icons.receipt_long;
      case 'wishlist': return Icons.favorite;
      case 'saving': return Icons.savings;
      case 'savings': return Icons.savings;
      case 'note': return Icons.edit_note;
      case 'notes': return Icons.edit_note;
      case 'smart note': return Icons.edit_note;
      case 'smart notes': return Icons.edit_note;
      case 'Smart Note': return Icons.edit_note;
      case 'Smart Notes': return Icons.edit_note;
      case 'edit_note': return Icons.edit_note;
      
      
      // Specific Sub-categories (User Requested) & Seed Data Matches
      case 'delivery': return Icons.delivery_dining;
      case 'delivery_dining': return Icons.delivery_dining; // Match seed: delivery_dining
      
      case 'parking': return Icons.local_parking;
      case 'local_parking': return Icons.local_parking; // Match seed: local_parking
      
      case 'maintenance': return Icons.build;
      case 'car_repair': return Icons.car_repair; // Match seed: car_repair
      case 'plumbing': return Icons.plumbing; // Match seed: plumbing
      
      case 'insurance': return Icons.security; 
      case 'security': return Icons.security; // Match seed: security
      case 'health_and_safety': return Icons.health_and_safety; // Match seed: health_and_safety
      case 'shield': return Icons.shield; // Match seed: shield
      
      case 'toll': return Icons.toll; 
      
      case 'electronics': return Icons.devices; 
      case 'devices': return Icons.devices; // Match seed: devices
      case 'developer_board': return Icons.developer_board; // Match seed: software
      
      case 'software': return Icons.terminal; 
      
      case 'events': return Icons.event; 
      case 'event_seat': return Icons.event_seat; // Match seed: event_seat
      
      case 'haircut': return Icons.content_cut;
      case 'content_cut': return Icons.content_cut; // Match seed: content_cut
      
      case 'courses': return Icons.school; 
      case 'cast_for_education': return Icons.cast_for_education; // Match seed: cast_for_education
      
      case 'supplies': return Icons.backpack;
      case 'backpack': return Icons.backpack; // Match seed: backpack
      
      case 'fines': return Icons.local_police; 
      case 'gavel': return Icons.gavel; // Match seed: gavel
      
      case 'toys': return Icons.toys;
      
      case 'monthly': return Icons.calendar_month;
      case 'calendar_today': return Icons.calendar_today; // Match seed: calendar_today
      
      case 'weekly': return Icons.calendar_view_week;
      case 'date_range': return Icons.date_range; // Match seed: date_range
      
      case 'overtime': return Icons.more_time;
      case 'access_time': return Icons.access_time; // Match seed: access_time
      
      case 'services': return Icons.design_services;
      case 'design_services': return Icons.design_services; // Match seed: design_services
      
      case 'stocks': return Icons.show_chart;
      case 'show_chart': return Icons.show_chart; // Match seed: show_chart
      
      case 'real estate': return Icons.real_estate_agent;
      case 'real_estate': return Icons.real_estate_agent;
      case 'real_estate_agent': return Icons.real_estate_agent; // Match seed: real_estate_agent
      case 'domain': return Icons.domain; // Match seed: domain
      
      case 'selling': return Icons.storefront;
      case 'storefront': return Icons.storefront; // Match seed: storefront
      
      case 'settings': return Icons.settings;
      case 'system': return Icons.settings_applications;
      case 'adjustment': return Icons.tune;
      case 'tune': return Icons.tune;
      
      case 'undo': return Icons.undo; // Refunds
      case 'casino': return Icons.casino; // Lottery

      default: return Icons.help_outline;
    }
  }
}
