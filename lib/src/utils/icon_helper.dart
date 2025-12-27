import 'package:flutter/material.dart';
import '../features/settings/presentation/icon_pack_provider.dart';
import 'iconoir_mapper.dart';

class IconHelper {
  /// Returns a Widget based on the selected icon pack.
  /// Use this method when you have access to the icon pack from Riverpod provider.
  static Widget getIconWidget(
    String iconName, {
    required IconPack pack,
    double size = 24,
    Color? color,
  }) {
    if (pack == IconPack.iconoir) {
      return IconoirMapper.getIcon(iconName, size: size, color: color);
    }
    return Icon(getIcon(iconName), size: size, color: color);
  }

  static IconData getIcon(String iconName) {
    switch (iconName.toLowerCase().trim()) {
      // Finance & Wallet
      case 'account_balance_wallet': return Icons.account_balance_wallet;
      case 'bank': return Icons.account_balance;
      case 'bitcoin': return Icons.currency_bitcoin;
      case 'credit_card': return Icons.credit_card;
      case 'copy': return Icons.copy;
      case 'copy_all': return Icons.copy_all;
      case 'sort_by_alpha': return Icons.sort_by_alpha;
      case 'push_pin': return Icons.push_pin_outlined;
      case 'delete': return Icons.delete_outline;
      case 'person': return Icons.person;
      case 'business_center': return Icons.business_center;
      case 'numbers': return Icons.numbers;
      case 'person_outline': return Icons.person_outline;
      case 'label': return Icons.label_outline;
      case 'location': return Icons.location_on_outlined;
      case 'keyboard_arrow_down': return Icons.keyboard_arrow_down;
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
      case 'info': return Icons.info_outline;
      case 'folder': return Icons.folder_open;
      case 'help': return Icons.help_outline;
      case 'restore': return Icons.restore;
      case 'file_download': return Icons.download;
      case 'file_upload': return Icons.upload_file;
      case 'send': return Icons.send;
      case 'search': return Icons.search;
      case 'filter': return Icons.filter_list;
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
      case 'kitesurfing': return Icons.kitesurfing;
      case 'surfing': return Icons.surfing;
      case 'palette': return Icons.palette;
      case 'brush': return Icons.brush;
      case 'piano': return Icons.piano;
      case 'mic': return Icons.mic;
      case 'headphones': return Icons.headphones;
      case 'chat_bubble': return Icons.chat_bubble_outline;
      case 'camera_alt': return Icons.camera_alt_outlined;
      case 'mic_outline': return Icons.mic_none_outlined;
      
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
      case 'casino': return Icons.casino;
      case 'receipt_long': return Icons.receipt_long;
      case 'handshake': return Icons.handshake;
      case 'category': return Icons.category;
      case 'sort': return Icons.sort_rounded;
      
      // System Category Aliases
      case 'debt': return Icons.handshake;
      case 'debts': return Icons.handshake;
      case 'bill': return Icons.receipt_long;
      case 'saving': return Icons.savings;
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
      
      // Menu Items (Specific Matching)
      case 'budget': return Icons.pie_chart_outline;
      case 'recurring': return Icons.repeat;
      case 'checklist': return Icons.checklist;
      case 'savings_outlined': return Icons.savings_outlined;
      case 'handshake_outlined': return Icons.handshake_outlined;
      case 'bills': return Icons.receipt_long;
      case 'wishlist': return Icons.card_giftcard;
      case 'cards': return Icons.credit_card;
      case 'reimburse': return Icons.currency_exchange;
      
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

      // Profile & Settings Unique Icons
      case 'download': return Icons.download;
      case 'grid_view': return Icons.grid_view;
      case 'color_lens': return Icons.color_lens;
      case 'widgets': return Icons.widgets;
      case 'update': return Icons.update;
      case 'cloud_sync': return Icons.cloud_sync;
      case 'auto_awesome': return Icons.auto_awesome;
      case 'feedback': return Icons.feedback;
      case 'file_download': return Icons.file_download;
      case 'file_upload': return Icons.file_upload;
      case 'chat_bubble_outline': return Icons.chat_bubble_outline;
      case 'bug_report': return Icons.bug_report;
      case 'info_outline': return Icons.info_outline;
      case 'history': return Icons.history;
      case 'delete_forever': return Icons.delete_forever;
      case 'logout': return Icons.logout;
      case 'rocket': return Icons.rocket_launch;
      case 'chevron_right': return Icons.chevron_right;
      case 'add': return Icons.add;
      
      // Navigation Icons
      case 'close': return Icons.close;
      case 'arrow_back': return Icons.arrow_back;
      case 'arrow_forward': return Icons.arrow_forward;
      case 'arrow_upward': return Icons.arrow_upward;
      case 'arrow_downward': return Icons.arrow_downward;
      
      // Status Icons
      case 'check': return Icons.check;
      case 'check_circle': return Icons.check_circle;
      case 'verified': return Icons.verified;
      case 'refresh': return Icons.refresh;
      
      // Language & Globe
      case 'language': return Icons.language;
      case 'globe': return Icons.language;
      
      // Premium/VIP Icons
      case 'workspace_premium': return Icons.workspace_premium;
      case 'code': return Icons.code;
      case 'analytics': return Icons.analytics;
      case 'document_scanner': return Icons.document_scanner;
      case 'support_agent': return Icons.support_agent;
      case 'all_inclusive': return Icons.all_inclusive;
      case 'scan': return Icons.document_scanner;

      default: return Icons.help_outline;
    }
  }
}
