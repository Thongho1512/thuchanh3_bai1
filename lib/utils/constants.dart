import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color accentColor = Color(0xFF03DAC6);
  static const Color errorColor = Color(0xFFB00020);

  // Categories
  static const List<String> categories = [
    'Ăn uống',
    'Di chuyển',
    'Mua sắm',
    'Giải trí',
    'Sức khỏe',
    'Giáo dục',
    'Hóa đơn',
    'Khác',
  ];

  // Category Colors
  static const Map<String, Color> categoryColors = {
    'Ăn uống': Colors.orange,
    'Di chuyển': Colors.blue,
    'Mua sắm': Colors.pink,
    'Giải trí': Colors.purple,
    'Sức khỏe': Colors.red,
    'Giáo dục': Colors.green,
    'Hóa đơn': Colors.brown,
    'Khác': Colors.grey,
  };
}
