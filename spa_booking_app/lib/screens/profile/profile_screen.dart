import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    required this.authProvider,
    this.onEditProfile,
    this.onAppointments,
    this.onNotifications,
    this.onPrivacy,
    this.onHelp,
    super.key,
  });

  final AuthProvider authProvider;
  final VoidCallback? onEditProfile;
  final VoidCallback? onAppointments;
  final VoidCallback? onNotifications;
  final VoidCallback? onPrivacy;
  final VoidCallback? onHelp;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: authProvider,
      builder: (context, _) {
        final user = authProvider.user;

        return Scaffold(
          backgroundColor: const Color(0xFFFCF9FF),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF241735),
            elevation: 0,
            title: const Text(
              'Hồ sơ',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          body: SafeArea(
            child: user == null
                ? const _SignedOutView()
                : _ProfileContent(
                    user: user,
                    authProvider: authProvider,
                    onEditProfile: onEditProfile,
                    onAppointments: onAppointments,
                    onNotifications: onNotifications,
                    onPrivacy: onPrivacy,
                    onHelp: onHelp,
                  ),
          ),
        );
      },
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.user,
    required this.authProvider,
    this.onEditProfile,
    this.onAppointments,
    this.onNotifications,
    this.onPrivacy,
    this.onHelp,
  });

  final UserProfile user;
  final AuthProvider authProvider;
  final VoidCallback? onEditProfile;
  final VoidCallback? onAppointments;
  final VoidCallback? onNotifications;
  final VoidCallback? onPrivacy;
  final VoidCallback? onHelp;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        _ProfileHeader(user: user, onEditProfile: onEditProfile),
        const SizedBox(height: 24),
        const _SectionTitle('Tài khoản'),
        const SizedBox(height: 10),
        _SettingsCard(
          children: [
            _SettingsTile(
              key: const Key('profile_appointments_tile'),
              icon: Icons.calendar_month_outlined,
              title: 'Lịch hẹn của tôi',
              onTap: onAppointments,
            ),
            _SettingsTile(
              key: const Key('profile_notifications_tile'),
              icon: Icons.notifications_none_rounded,
              title: 'Thông báo',
              onTap: onNotifications,
            ),
          ],
        ),
        const SizedBox(height: 24),
        const _SectionTitle('Cài đặt và hỗ trợ'),
        const SizedBox(height: 10),
        _SettingsCard(
          children: [
            _SettingsTile(
              key: const Key('profile_privacy_tile'),
              icon: Icons.shield_outlined,
              title: 'Quyền riêng tư',
              onTap: onPrivacy,
            ),
            _SettingsTile(
              key: const Key('profile_help_tile'),
              icon: Icons.help_outline_rounded,
              title: 'Trợ giúp và hỗ trợ',
              onTap: onHelp,
            ),
          ],
        ),
        if (authProvider.errorMessage case final message?) ...[
          const SizedBox(height: 18),
          Text(
            message,
            key: const Key('profile_error_message'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFB3261E),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 24),
        OutlinedButton.icon(
          key: const Key('profile_logout_button'),
          onPressed: authProvider.isLoading
              ? null
              : () => _confirmSignOut(context),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            foregroundColor: const Color(0xFFB3261E),
            side: const BorderSide(color: Color(0xFFE7B9B6)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: authProvider.isLoading
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    key: Key('profile_logout_progress_indicator'),
                    strokeWidth: 2.2,
                    color: Color(0xFFB3261E),
                  ),
                )
              : const Icon(Icons.logout_rounded),
          label: Text(
            authProvider.isLoading ? 'Đang đăng xuất...' : 'Đăng xuất',
          ),
        ),
      ],
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    authProvider.clearError();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Đăng xuất?'),
        content: const Text(
          'Bạn có chắc muốn đăng xuất khỏi tài khoản hiện tại không?',
        ),
        actions: [
          TextButton(
            key: const Key('profile_cancel_logout_button'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            key: const Key('profile_confirm_logout_button'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB3261E),
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await authProvider.signOut();
    }
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user, this.onEditProfile});

  final UserProfile user;
  final VoidCallback? onEditProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8D8F2), Color(0xFFFFF1F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          _ProfileAvatar(user: user),
          const SizedBox(height: 14),
          Text(
            user.fullName,
            key: const Key('profile_full_name'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF241735),
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            key: const Key('profile_email'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF766C80)),
          ),
          if (user.phoneNumber case final phone?) ...[
            const SizedBox(height: 4),
            Text(
              phone,
              key: const Key('profile_phone_number'),
              style: const TextStyle(color: Color(0xFF766C80)),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            key: const Key('profile_edit_button'),
            onPressed: onEditProfile,
            style: FilledButton.styleFrom(
              foregroundColor: const Color(0xFF6E3F91),
              backgroundColor: Colors.white.withValues(alpha: 0.82),
            ),
            icon: const Icon(Icons.edit_outlined, size: 19),
            label: const Text('Chỉnh sửa hồ sơ'),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = user.avatarUrl?.trim();

    return CircleAvatar(
      key: const Key('profile_avatar'),
      radius: 45,
      backgroundColor: Colors.white,
      foregroundImage: avatarUrl == null || avatarUrl.isEmpty
          ? null
          : NetworkImage(avatarUrl),
      child: avatarUrl == null || avatarUrl.isEmpty
          ? Text(
              _initials(user.fullName),
              style: const TextStyle(
                color: Color(0xFF7C4D9E),
                fontSize: 27,
                fontWeight: FontWeight.w800,
              ),
            )
          : null,
    );
  }

  String _initials(String fullName) {
    final words = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF241735),
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < children.length; index++) ...[
            children[index],
            if (index < children.length - 1)
              const Divider(height: 1, indent: 58),
          ],
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: const Color(0xFF7C4D9E)),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF241735),
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Color(0xFF9A90A2),
      ),
    );
  }
}

class _SignedOutView extends StatelessWidget {
  const _SignedOutView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_off_outlined, size: 64, color: Color(0xFF9A90A2)),
            SizedBox(height: 16),
            Text(
              'Bạn chưa đăng nhập.',
              key: Key('profile_signed_out_message'),
              style: TextStyle(
                color: Color(0xFF241735),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
