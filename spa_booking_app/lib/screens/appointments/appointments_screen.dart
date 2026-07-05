// Thư viện Material cung cấp layout, tab chip và SnackBar.
import 'package:flutter/material.dart';
// Provider dùng để đọc danh sách lịch hẹn từ BookingProvider.
import 'package:provider/provider.dart';

// Import style, widget dùng chung, model và provider lịch hẹn.
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/appointment_card.dart';
import '../../core/widgets/category_chip.dart';
import '../../models/appointment.dart';
import '../../providers/booking_provider.dart';

// Màn hình hiển thị lịch hẹn theo ba tab: sắp tới, hoàn thành và đã hủy.
class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = const ['Sắp tới', 'Đã hoàn thành', 'Đã hủy'];

  @override
  // Sau frame đầu, yêu cầu provider nạp danh sách lịch hẹn.
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<BookingProvider>().loadAppointments();
    });
  }

  @override
  // build dựng phần giao diện của widget trong màn lịch hẹn.
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, _) {
        final appointments = _filterAppointments(provider.appointments);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (provider.isLoading) const LinearProgressIndicator(minHeight: 3),
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
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
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
            Expanded(child: _buildAppointmentsBody(provider, appointments)),
          ],
        );
      },
    );
  }

  // Dựng phần body theo trạng thái loading/error/empty/data của lịch hẹn.
  Widget _buildAppointmentsBody(
    BookingProvider provider,
    List<Appointment> appointments,
  ) {
    if (provider.errorMessage != null && provider.appointments.isEmpty) {
      return _AppointmentsErrorState(
        message: provider.errorMessage!,
        onRetry: () => provider.loadAppointments(refresh: true),
      );
    }

    if ((provider.isLoading || !provider.hasLoaded) &&
        provider.appointments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (appointments.isEmpty) {
      return const _EmptyAppointments();
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
      itemCount: appointments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return AppointmentCard(
          appointment: appointment,
          onCancel: provider.isLoading
              ? null
              : () => _cancelAppointment(provider, appointment.id),
        );
      },
    );
  }

  // Gọi provider hủy lịch rồi thông báo kết quả bằng SnackBar.
  Future<void> _cancelAppointment(BookingProvider provider, String id) async {
    final success = await provider.cancelAppointment(id);
    if (!mounted) {
      return;
    }

    final message = success
        ? 'Đã hủy lịch hẹn'
        : provider.errorMessage ?? 'Không thể hủy lịch hẹn. Vui lòng thử lại.';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Lọc lịch hẹn dựa theo tab đang chọn.
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

// Màn hình lỗi khi backend không tải được danh sách lịch hẹn.
class _AppointmentsErrorState extends StatelessWidget {
  const _AppointmentsErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 70, color: AppColors.danger),
            const SizedBox(height: 16),
            const Text(
              'Không thể tải lịch hẹn',
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.muted,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

// Empty state hiển thị khi tab hiện tại không có lịch hẹn nào.
class _EmptyAppointments extends StatelessWidget {
  const _EmptyAppointments();

  @override
  // build dựng phần giao diện của widget trong màn lịch hẹn.
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
