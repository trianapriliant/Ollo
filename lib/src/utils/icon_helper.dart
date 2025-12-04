import 'package:flutter/material.dart';

class IconHelper {
  static IconData getIcon(String iconName) {
    switch (iconName) {
      // Finance & Wallet
      case 'account_balance_wallet': return Icons.account_balance_wallet;
      case 'account_balance': return Icons.account_balance;
      case 'credit_card': return Icons.credit_card;
      case 'payments': return Icons.payments;
      case 'savings': return Icons.savings;
      case 'monetization_on': return Icons.monetization_on;
      case 'wallet': return Icons.wallet;
      case 'currency_exchange': return Icons.currency_exchange;
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
      
      // Family & People
      case 'person': return Icons.person;
      case 'people': return Icons.people;
      case 'groups': return Icons.groups;
      case 'child_friendly': return Icons.child_friendly;
      case 'baby_changing_station': return Icons.baby_changing_station;
      case 'family_restroom': return Icons.family_restroom;
      case 'face': return Icons.face;
      case 'mood': return Icons.mood;
      
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
      
      default: return Icons.help_outline;
    }
  }
}
