import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/appointment_card.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/section_title.dart';
import '../../data/mock_services.dart';
import '../../models/spa_service.dart';
import '../../providers/booking_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenService});

  final ValueChanged<SpaService> onOpenService;

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final upcomingAppointments = bookingProvider.upcomingAppointments;
    final popularServices = mockServices
        .where((service) => service.isPopular)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
      children: [
        const Text(
          'Lavender Spa',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Book a relaxing appointment in a few taps.',
          style: AppTextStyles.muted,
        ),
        const SizedBox(height: 20),
        const SectionTitle(title: 'Popular services'),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: popularServices.length,
            separatorBuilder: (_, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final service = popularServices[index];
              return _ServiceTile(
                service: service,
                onTap: () => onOpenService(service),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle(title: 'Upcoming appointments'),
        const SizedBox(height: 12),
        if (upcomingAppointments.isEmpty)
          const _EmptyState()
        else
          for (final appointment in upcomingAppointments.take(2)) ...[
            AppointmentCard(
              appointment: appointment,
              onCancel: () => bookingProvider.cancelAppointment(appointment.id),
            ),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.service, required this.onTap});

  final SpaService service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 210,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryChip(
              label: service.category,
              selected: true,
              onTap: onTap,
              icon: Icons.spa_outlined,
            ),
            const Spacer(),
            Text(service.name, style: AppTextStyles.sectionTitle),
            const SizedBox(height: 6),
            Text(
              '${formatMoney(service.price)} - ${service.durationMinutes} min',
              style: AppTextStyles.muted,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text('No upcoming appointments yet.', style: AppTextStyles.muted),
    );
  }
}
