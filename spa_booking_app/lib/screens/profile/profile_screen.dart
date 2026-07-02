import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/info_row.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
      children: [
        Text(
          'Hồ sơ',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppShadows.soft,
          ),
          child: Column(
            children: [
              ClipOval(
                child: Image.network(
                  user.avatar,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 96,
                    height: 96,
                    color: AppColors.secondary,
                    child: const Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 46,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(user.fullName, style: AppTextStyles.sectionTitle),
              const SizedBox(height: 4),
              Text(user.email, style: AppTextStyles.muted),
              const SizedBox(height: 4),
              Text(user.phone, style: AppTextStyles.muted),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(22),
            boxShadow: AppShadows.soft,
          ),
          child: Column(
            children: [
              InfoRow(
                icon: Icons.person_outline,
                label: 'Họ và tên',
                value: user.fullName,
              ),
              const SizedBox(height: 14),
              InfoRow(
                icon: Icons.email_outlined,
                label: 'Email',
                value: user.email,
              ),
              const SizedBox(height: 14),
              InfoRow(
                icon: Icons.phone_outlined,
                label: 'Số điện thoại',
                value: user.phone,
              ),
              const SizedBox(height: 14),
              InfoRow(
                icon: Icons.cake_outlined,
                label: 'Ngày sinh',
                value: user.birthday,
              ),
              const SizedBox(height: 14),
              InfoRow(
                icon: Icons.wc_outlined,
                label: 'Giới tính',
                value: user.gender,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const _MenuTile(icon: Icons.edit_outlined, title: 'Chỉnh sửa hồ sơ'),
        const _MenuTile(icon: Icons.notifications_outlined, title: 'Thông báo'),
        const _MenuTile(icon: Icons.help_outline, title: 'Trợ giúp'),
        const _MenuTile(icon: Icons.settings_outlined, title: 'Cài đặt'),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () {
            context.read<AuthProvider>().logout();
          },
          icon: const Icon(Icons.logout),
          label: const Text('Đăng xuất'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            foregroundColor: AppColors.danger,
            side: BorderSide(color: AppColors.danger.withValues(alpha: .25)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textLight),
        ],
      ),
    );
  }
}
