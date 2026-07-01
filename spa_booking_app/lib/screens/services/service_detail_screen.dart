import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/info_row.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/section_title.dart';
import '../../models/spa_service.dart';
import '../../providers/booking_provider.dart';
import '../booking/booking_screen.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key, required this.service});

  final SpaService service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(service.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.spa, size: 72, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          Text(
            service.name,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(service.description, style: AppTextStyles.muted),
          const SizedBox(height: 18),
          InfoRow(
            icon: Icons.payments_outlined,
            label: 'Price',
            value: formatMoney(service.price),
          ),
          const SizedBox(height: 12),
          InfoRow(
            icon: Icons.schedule,
            label: 'Duration',
            value: '${service.durationMinutes} min',
          ),
          const SizedBox(height: 22),
          const SectionTitle(title: 'Benefits'),
          const SizedBox(height: 10),
          ...service.benefits.map(
            (benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('- $benefit', style: AppTextStyles.muted),
            ),
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label: 'Book now',
            icon: Icons.calendar_month_outlined,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => BookingScreen(service: service),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
