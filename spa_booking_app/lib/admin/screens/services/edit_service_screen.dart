import 'package:flutter/material.dart';
import '../../core/constants/admin_colors.dart';
import '../../core/constants/admin_text_styles.dart';

/// TODO – HƯNG: Màn hình Chỉnh sửa / Thêm Dịch vụ
///
/// Dựa theo file thiết kế: stitch_zen_luxury_spa_booking_app/th_m_d_ch_v/screen.png
///
/// Các thành phần cần làm:
///   1. AppBar: back + "Chỉnh sửa dịch vụ" + icon ⋮
///   2. Section UPLOAD ẢNH: card ảnh lớn + nút "Thay đổi ảnh"
///   3. Section THÔNG TIN CƠ BẢN:
///      - TextField: Tên dịch vụ
///      - Dropdown: Danh mục
///      - Row: TextField Giá + TextField Thời lượng (+ "Phút")
///   4. Section MÔ TẢ DỊCH VỤ:
///      - TextField: Mô tả ngắn
///      - TextField multiline: Mô tả chi tiết
///   5. Section CÀI ĐẶT: toggle "Trạng thái hoạt động"
///   6. Button "Lưu dịch vụ" pill tím full width
class EditServiceScreen extends StatelessWidget {
  const EditServiceScreen({super.key, this.serviceId});
  final String? serviceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit_rounded, size: 64, color: AdminColors.primary.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text('Chỉnh sửa dịch vụ – Hưng làm', style: AdminTextStyles.headlineMd),
            ],
          ),
        ),
      ),
    );
  }
}
