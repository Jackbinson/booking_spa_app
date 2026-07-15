import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/info_row.dart';
import '../../models/user_profile.dart';
import '../../providers/auth_provider.dart';
import 'profile_edit_screen.dart';
import 'profile_notification_settings_screen.dart';

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
              _ProfileAvatar(user: user, size: 96),
              const SizedBox(height: 14),
              Text(user.fullName, style: AppTextStyles.sectionTitle),
              const SizedBox(height: 4),
              Text(user.email, style: AppTextStyles.muted),
              if (user.phone.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(user.phone, style: AppTextStyles.muted),
              ],
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
                value: _valueOrMissing(user.phone),
              ),
              const SizedBox(height: 14),
              InfoRow(
                icon: Icons.cake_outlined,
                label: 'Ngày sinh',
                value: _valueOrMissing(user.birthday),
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
        _MenuTile(
          icon: Icons.edit_outlined,
          title: 'Chỉnh sửa hồ sơ',
          onTap: () => _open(context, const ProfileEditScreen()),
        ),
        _MenuTile(
          icon: Icons.notifications_outlined,
          title: 'Thông báo',
          onTap: () =>
              _open(context, const ProfileNotificationSettingsScreen()),
        ),
        _MenuTile(
          icon: Icons.help_outline,
          title: 'Trợ giúp',
          onTap: () => _showHelp(context),
        ),
        _MenuTile(
          icon: Icons.settings_outlined,
          title: 'Cài đặt',
          onTap: () => _showSettings(context),
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => context.read<AuthProvider>().logout(),
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

  static void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  static void _showHelp(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Trợ giúp'),
        content: const Text(
          'Nếu cần hỗ trợ đặt lịch hoặc tài khoản, vui lòng liên hệ Lavender Spa qua email support@lavenderspa.vn.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đã hiểu'),
          ),
        ],
      ),
    );
  }

  static void _showSettings(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: const Text('Cài đặt thông báo'),
          subtitle: const Text('Lịch hẹn, ưu đãi và tin tức spa'),
          onTap: () {
            Navigator.of(sheetContext).pop();
            _open(context, const ProfileNotificationSettingsScreen());
          },
        ),
      ),
    );
  }

  static String _valueOrMissing(String value) {
    return value.trim().isEmpty ? 'Chưa cập nhật' : value;
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.user, required this.size});

  final UserProfile user;
  final double size;

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.avatar.trim();
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.secondary,
        shape: BoxShape.circle,
      ),
      child: imageUrl.isEmpty
          ? Icon(
              Icons.person_outline,
              color: AppColors.primary,
              size: size * .48,
            )
          : Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Icon(
                Icons.person_outline,
                color: AppColors.primary,
                size: size * .48,
              ),
            ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.soft,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
          ),
        ),
      ),
    );
  }
}
