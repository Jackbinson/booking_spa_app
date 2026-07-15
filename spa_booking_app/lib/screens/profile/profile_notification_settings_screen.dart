import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';

class ProfileNotificationSettingsScreen extends StatefulWidget {
  const ProfileNotificationSettingsScreen({super.key});

  @override
  State<ProfileNotificationSettingsScreen> createState() =>
      _ProfileNotificationSettingsScreenState();
}

class _ProfileNotificationSettingsScreenState
    extends State<ProfileNotificationSettingsScreen> {
  late bool _bookingUpdates;
  late bool _promotions;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _bookingUpdates = user.bookingUpdatesEnabled;
    _promotions = user.promotionsEnabled;
  }

  Future<void> _save({bool? bookingUpdates, bool? promotions}) async {
    final previousBookingUpdates = _bookingUpdates;
    final previousPromotions = _promotions;
    setState(() {
      _bookingUpdates = bookingUpdates ?? _bookingUpdates;
      _promotions = promotions ?? _promotions;
      _saving = true;
    });

    final success = await context
        .read<AuthProvider>()
        .updateNotificationPreferences(
          bookingUpdates: _bookingUpdates,
          promotions: _promotions,
        );
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    if (success) {
      return;
    }
    setState(() {
      _bookingUpdates = previousBookingUpdates;
      _promotions = previousPromotions;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.read<AuthProvider>().errorMessage!),
        backgroundColor: AppColors.danger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            'Chọn thông báo bạn muốn nhận từ Lavender Spa.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textLight),
          ),
          const SizedBox(height: 18),
          _SettingsCard(
            child: SwitchListTile.adaptive(
              value: _bookingUpdates,
              onChanged: _saving
                  ? null
                  : (value) => _save(bookingUpdates: value),
              title: const Text('Lịch hẹn'),
              subtitle: const Text('Xác nhận, nhắc lịch và cập nhật đặt lịch.'),
              secondary: const Icon(Icons.calendar_month_outlined),
              activeThumbColor: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            child: SwitchListTile.adaptive(
              value: _promotions,
              onChanged: _saving ? null : (value) => _save(promotions: value),
              title: const Text('Ưu đãi'),
              subtitle: const Text('Khuyến mãi và dịch vụ mới của spa.'),
              secondary: const Icon(Icons.local_offer_outlined),
              activeThumbColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: child,
      ),
    );
  }
}
