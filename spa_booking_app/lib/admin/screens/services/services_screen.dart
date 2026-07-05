import 'package:flutter/material.dart';
import '../../core/constants/admin_colors.dart';
import '../../core/constants/admin_text_styles.dart';

/// TODO – HƯNG: Màn hình Quản lý Dịch vụ
///
/// Dựa theo file thiết kế: stitch_zen_luxury_spa_booking_app/qu_n_l_d_ch_v/screen.png
///
/// Các thành phần cần làm:
///   1. AppBar: icon menu + "Dịch vụ" + icon chuông
///   2. Search bar pill
///   3. Filter chips: Tất cả / Đang hoạt động / Tạm ẩn
///   4. List card dịch vụ (mỗi card):
///      - Ảnh full width bo góc
///      - Tên + icon đồng hồ + thời lượng
///      - Mô tả ngắn (2 dòng)
///      - Giá + Toggle (Hoạt động/Tạm ẩn) + nút ⋮
///   5. FAB "+" tím góc dưới phải
class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.spa_rounded, size: 64, color: AdminColors.primary.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text('Dịch vụ – Hưng làm', style: AdminTextStyles.headlineMd),
              const SizedBox(height: 8),
              Text(
                'Xem file thiết kế:\nqu_n_l_d_ch_v/screen.png',
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
