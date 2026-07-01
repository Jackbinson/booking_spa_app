import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const primary = Color(0xFF7C4D9E);
  static const secondary = Color(0xFFE8D8F2);
  static const background = Color(0xFFFCF9FF);
  static const card = Colors.white;
  static const input = Color(0xFFF3EEF7);
  static const border = Color(0xFFE4D8EA);
  static const textDark = Color(0xFF241735);
  static const textLight = Color(0xFF766C80);
  static const danger = Color(0xFFB3261E);
  static const warning = Color(0xFF9A6500);
  static const success = Color(0xFF2E7D32);
}

class AppShadows {
  const AppShadows._();

  static const soft = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];
}
