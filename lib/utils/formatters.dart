import 'package:flutter/material.dart';

/// Maps backend category icon names (from `GET /categories`) to Flutter icons.
IconData categoryIcon(String? iconName) {
  switch (iconName) {
    case 'laptop':
      return Icons.laptop;
    case 'shirt':
      return Icons.checkroom;
    case 'bike':
      return Icons.directions_bike;
    case 'book':
      return Icons.menu_book;
    case 'home':
      return Icons.home;
    case 'dumbbell':
      return Icons.fitness_center;
    case 'package':
      return Icons.inventory_2_outlined;
    default:
      return Icons.category_outlined;
  }
}

/// Formats a number as Indonesian Rupiah, e.g. 8500000 -> "Rp8.500.000".
String formatRupiah(num value) {
  final formatted = value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
  return 'Rp$formatted';
}
