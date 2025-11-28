import 'package:flutter/material.dart';
import '../../transactions/domain/transaction.dart';

class MockData {
  static final List<Transaction> recentActivity = [];


  static final List<Contact> recentContacts = [
    Contact(name: 'Agus', imageUrl: ''),
    Contact(name: 'Siti', imageUrl: ''),
    Contact(name: 'Udin', imageUrl: ''),
    Contact(name: 'Tina', imageUrl: ''),
  ];
}
