import 'package:flutter/material.dart';
import '../../core/constants/admin_colors.dart';
import '../../core/constants/admin_text_styles.dart';

/// TODO – HƯNG: Màn hình "Thêm" (More menu)
///
/// Dựa theo file thiết kế: stitch_zen_luxury_spa_booking_app/th_m/screen.png
///
/// Các thành phần cần làm:
///   1. AppBar: icon menu + "Lavender Spa" + icon chuông
///   2. Avatar admin tròn lớn (có dot xanh online)
///   3. Tên + email admin
///   4. 2 chip: "Quản trị viên" (tím) + "Online" (outline)
///   5. Card 2 cột: Khuyến mãi (icon ticket) + Doanh thu (icon chart)
///   6. Card list menu: Cài đặt spa / Thông báo (có dot đỏ) / Trợ giúp
///   7. Button "Đăng xuất" màu đỏ nhạt
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.more_horiz_rounded, size: 64, color: AdminColors.primary.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text('Thêm – Hưng làm', style: AdminTextStyles.headlineMd),
              const SizedBox(height: 8),
              Text(
                'Xem file thiết kế:\nth_m/screen.png',
                style: AdminTextStyles.bodyMd,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
