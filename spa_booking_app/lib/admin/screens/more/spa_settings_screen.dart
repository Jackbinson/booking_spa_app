import 'package:flutter/material.dart';
import '../../core/constants/admin_colors.dart';
import '../../core/constants/admin_text_styles.dart';

/// TODO – HƯNG: Màn hình Cài đặt Spa
///
/// Dựa theo file thiết kế: stitch_zen_luxury_spa_booking_app/c_i_t_spa/screen.png
///
/// Các thành phần cần làm:
///   1. AppBar: back + "Cài đặt Spa" + icon chuông
///   2. Section "Thông tin tiệm" (icon store):
///      - TextField: Tên Spa
///      - TextField: Địa chỉ
///      - TextField: Hotline
///      - TextField: Email
///   3. Section "Giờ hoạt động" (icon clock):
///      - Mỗi ngày trong tuần: tên ngày + "09:00 – 21:00" + Toggle
///      - Thứ 7 và CN: chữ tím
///   4. Section "Chính sách đặt lịch" (icon shield):
///      - Row: "Hủy lịch trước (giờ)" + TextField số nhỏ (default 2)
///   5. Button "Lưu thay đổi" pill tím full width
class SpaSettingsScreen extends StatelessWidget {
  const SpaSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.settings_rounded, size: 64, color: AdminColors.primary.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text('Cài đặt Spa – Hưng làm', style: AdminTextStyles.headlineMd),
            ],
          ),
        ),
      ),
    );
  }
}
