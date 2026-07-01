import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/appointment_card.dart';
import '../../core/widgets/category_chip.dart';
import '../../models/appointment.dart';
import '../../providers/booking_provider.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = const ['Sắp tới', 'Đã hoàn thành', 'Đã hủy'];

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, _) {
        final appointments = _filterAppointments(provider.appointments);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lịch hẹn của tôi',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _tabs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        return CategoryChip(
                          label: _tabs[index],
                          selected: _selectedTab == index,
                          onTap: () => setState(() => _selectedTab = index),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: appointments.isEmpty
                  ? const _EmptyAppointments()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                      itemCount: appointments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];
                        return AppointmentCard(
                          appointment: appointment,
                          onCancel: () {
                            provider.cancelAppointment(appointment.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Đã hủy lịch hẹn')),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  List<Appointment> _filterAppointments(List<Appointment> appointments) {
    switch (_selectedTab) {
      case 0:
        return appointments
            .where(
              (appointment) =>
                  appointment.status == AppointmentStatus.pending ||
                  appointment.status == AppointmentStatus.confirmed,
            )
            .toList();
      case 1:
        return appointments
            .where(
              (appointment) =>
                  appointment.status == AppointmentStatus.completed,
            )
            .toList();
      default:
        return appointments
            .where(
              (appointment) =>
                  appointment.status == AppointmentStatus.cancelled,
            )
            .toList();
    }
  }
}

class _EmptyAppointments extends StatelessWidget {
  const _EmptyAppointments();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.event_busy_outlined, size: 70, color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              'Bạn chưa có lịch hẹn nào',
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle,
            ),
            SizedBox(height: 8),
            Text(
              'Hãy chọn dịch vụ và đặt lịch để bắt đầu thư giãn',
              textAlign: TextAlign.center,
              style: AppTextStyles.muted,
            ),
          ],
        ),
      ),
    );
  }
}
