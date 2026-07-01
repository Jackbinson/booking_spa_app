import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const sectionTitle = TextStyle(
    color: AppColors.textDark,
    fontSize: 17,
    fontWeight: FontWeight.w900,
  );

  static const muted = TextStyle(
    color: AppColors.textLight,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );
}
