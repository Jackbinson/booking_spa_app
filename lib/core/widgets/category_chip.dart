// Thư viện Material cung cấp InkWell, Icon và Container cho chip.
import 'package:flutter/material.dart';

// Import màu và shadow dùng để thể hiện trạng thái selected.
import '../constants/app_colors.dart';

// StatelessWidget vì mọi trạng thái được truyền từ widget cha qua selected/onTap.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key, // tham chiếu đến lớp cha
    required this.label, // từ khóa dùng để yêu cầu bắt buộc khi gọi hàm hoặc khởi tạo widget
    required this.selected,
    required this.onTap,
    this.icon,
  });

  // Chữ hiển thị trên chip, ví dụ: Massage, Nail, Combo.
  final String label;
  // true nếu chip đang được chọn.
  final bool selected;
  // Hàm gọi khi người dùng bấm vào chip.
  final VoidCallback onTap;
  // Icon có thể có hoặc không, nên dùng kiểu nullable IconData?.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
          boxShadow: selected ? AppShadows.soft : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? Colors.white : AppColors.primary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
