import 'package:flutter/material.dart';

class IconHelper {
  static IconData getIcon(String iconName) {
    switch (iconName) {
      // General
      case 'help': return Icons.help_outline;
      case 'more_horiz': return Icons.more_horiz;
      
      // Food
      case 'fastfood': return Icons.fastfood;
      case 'bakery_dining': return Icons.bakery_dining;
      case 'lunch_dining': return Icons.lunch_dining;
      case 'dinner_dining': return Icons.dinner_dining;
      case 'icecream': return Icons.icecream;
      case 'coffee': return Icons.coffee;
      case 'cake': return Icons.cake;
      
      // Transport
      case 'directions_bus': return Icons.directions_bus;
      case 'train': return Icons.train;
      case 'local_taxi': return Icons.local_taxi;
      case 'local_gas_station': return Icons.local_gas_station;
      
      // Shopping
      case 'shopping_bag': return Icons.shopping_bag;
      case 'checkroom': return Icons.checkroom;
      case 'devices': return Icons.devices;
      case 'local_grocery_store': return Icons.local_grocery_store;
      
      // Entertainment
      case 'movie': return Icons.movie;
      case 'sports_esports': return Icons.sports_esports;
      case 'live_tv': return Icons.live_tv;
      case 'event': return Icons.event;
      case 'celebration': return Icons.celebration;
      
      // Health
      case 'medical_services': return Icons.medical_services;
      case 'local_pharmacy': return Icons.local_pharmacy;
      case 'fitness_center': return Icons.fitness_center;
      
      // Education
      case 'school': return Icons.school;
      case 'menu_book': return Icons.menu_book;
      
      // Bills
      case 'receipt': return Icons.receipt;
      case 'lightbulb': return Icons.lightbulb;
      case 'water_drop': return Icons.water_drop;
      case 'wifi': return Icons.wifi;
      case 'home': return Icons.home;
      
      // Income
      case 'attach_money': return Icons.attach_money;
      case 'calendar_today': return Icons.calendar_today;
      case 'star': return Icons.star;
      case 'store': return Icons.store;
      case 'sell': return Icons.sell;
      case 'design_services': return Icons.design_services;
      case 'card_giftcard': return Icons.card_giftcard;
      case 'trending_up': return Icons.trending_up;
      case 'pie_chart': return Icons.pie_chart;
      case 'currency_bitcoin': return Icons.currency_bitcoin;
      case 'replay': return Icons.replay;
      case 'volunteer_activism': return Icons.volunteer_activism;
      
      // Wallet
      case 'money': return Icons.money;
      
      default: return Icons.help_outline;
    }
  }
}
