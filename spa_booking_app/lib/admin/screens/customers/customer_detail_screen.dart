import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/admin_booking_provider.dart';
import '../../core/constants/admin_colors.dart';
import '../../core/constants/admin_text_styles.dart';
import '../../models/admin_mock_data.dart';
import '../bookings/booking_detail_screen.dart';

class CustomerDetailScreen extends StatefulWidget {
  const CustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final provider = context.read<AdminBookingProvider>();
      provider.loadBookings(refresh: true);
      provider.loadBookingFormOptions(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminBookingProvider>();
    AdminCustomer? customer;
    for (final item in provider.customers) {
      if (item.id == widget.customerId) {
        customer = item;
        break;
      }
    }

    if (customer == null) {
      return Scaffold(
        backgroundColor: AdminColors.background,
        appBar: AppBar(
          backgroundColor: AdminColors.background,
          elevation: 0,
          title: Text('Hồ sơ khách hàng', style: AdminTextStyles.titleLg),
        ),
        body: Center(
          child: provider.isLoadingFormOptions
              ? const CircularProgressIndicator()
              : const Text('Không tìm thấy dữ liệu khách hàng.'),
        ),
      );
    }

    final history =
        provider.bookings
            .where((booking) => booking.customerId == widget.customerId)
            .toList()
          ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return Scaffold(
      backgroundColor: AdminColors.background,
      appBar: AppBar(
        backgroundColor: AdminColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AdminColors.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Hồ sơ khách hàng', style: AdminTextStyles.titleLg),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: AdminColors.secondaryFixed,
              child: Text(
                customer.name.isEmpty ? '?' : customer.name[0],
                style: AdminTextStyles.headlineMd.copyWith(
                  color: AdminColors.primary,
                  fontSize: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(customer.name, style: AdminTextStyles.headlineSm),
          const SizedBox(height: 4),
          Text(
            customer.phone,
            style: AdminTextStyles.bodyMd.copyWith(color: AdminColors.outline),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatCol(title: 'Tổng lịch', value: '${customer.totalBookings}'),
              Container(
                width: 1,
                height: 40,
                color: AdminColors.surfaceContainerHigh,
              ),
              _StatCol(
                title: 'Tổng chi',
                value: formatAdminMoney(customer.totalSpent),
              ),
              Container(
                width: 1,
                height: 40,
                color: AdminColors.surfaceContainerHigh,
              ),
              _StatCol(title: 'Yêu thích', value: _favoriteService(history)),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: AdminColors.primary,
                    unselectedLabelColor: AdminColors.outline,
                    indicatorColor: AdminColors.primary,
                    tabs: [
                      Tab(text: 'Lịch sử'),
                      Tab(text: 'Ghi chú'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _HistoryTab(
                          bookings: history,
                          isLoading: provider.isLoading,
                          errorMessage: provider.errorMessage,
                          onRefresh: () => provider.loadBookings(refresh: true),
                        ),
                        const Center(child: Text('Chưa có ghi chú nào.')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _favoriteService(List<AdminBooking> bookings) {
    final counts = <String, int>{};
    for (final booking in bookings) {
      if (booking.status != AdminBookingStatus.cancelled) {
        counts.update(
          booking.serviceName,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }
    }
    if (counts.isEmpty) {
      return '—';
    }
    final favorite = counts.entries.reduce(
      (best, item) => item.value > best.value ? item : best,
    );
    return favorite.key;
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({
    required this.bookings,
    required this.isLoading,
    required this.errorMessage,
    required this.onRefresh,
  });

  final List<AdminBooking> bookings;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (isLoading && bookings.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (bookings.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 100),
            Icon(
              errorMessage == null
                  ? Icons.event_note_rounded
                  : Icons.cloud_off_rounded,
              size: 48,
              color: AdminColors.outline,
            ),
            const SizedBox(height: 14),
            Text(
              errorMessage ?? 'Khách hàng chưa có lịch hẹn nào.',
              textAlign: TextAlign.center,
              style: AdminTextStyles.bodyMd.copyWith(
                color: AdminColors.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kéo xuống để tải lại',
              textAlign: TextAlign.center,
              style: AdminTextStyles.labelSm.copyWith(
                color: AdminColors.primary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: bookings.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _HistoryCard(
          booking: bookings[index],
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => BookingDetailScreen(booking: bookings[index]),
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.booking, required this.onTap});

  final AdminBooking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(booking.status);
    final isPaid = booking.paymentStatus == AdminPaymentStatus.paid;
    return Material(
      color: AdminColors.surfaceWhite,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border(left: BorderSide(color: statusColor, width: 4)),
            boxShadow: AdminColors.ambientShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      booking.serviceName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AdminTextStyles.titleMd,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _StatusBadge(
                    label: _statusLabel(booking.status),
                    color: statusColor,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 18,
                    color: AdminColors.outline,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatAdminDateTime(booking.dateTime),
                    style: AdminTextStyles.bodyMd,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    formatAdminMoney(booking.price),
                    style: AdminTextStyles.price,
                  ),
                  const Spacer(),
                  Icon(
                    isPaid
                        ? Icons.check_circle_rounded
                        : Icons.pending_outlined,
                    size: 17,
                    color: isPaid
                        ? AdminColors.statusCompleted
                        : AdminColors.outline,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    isPaid ? 'Đã thanh toán' : 'Chưa thanh toán',
                    style: AdminTextStyles.labelSm.copyWith(
                      color: isPaid
                          ? AdminColors.statusCompleted
                          : AdminColors.outline,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AdminColors.outline,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: AdminTextStyles.labelSm.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatCol extends StatelessWidget {
  const _StatCol({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AdminTextStyles.titleLg,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AdminTextStyles.bodyMd.copyWith(
                color: AdminColors.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _statusColor(AdminBookingStatus status) {
  switch (status) {
    case AdminBookingStatus.pending:
      return AdminColors.statusPending;
    case AdminBookingStatus.confirmed:
      return AdminColors.statusConfirmed;
    case AdminBookingStatus.completed:
      return AdminColors.statusCompleted;
    case AdminBookingStatus.cancelled:
      return AdminColors.statusCancelled;
  }
}

String _statusLabel(AdminBookingStatus status) {
  switch (status) {
    case AdminBookingStatus.pending:
      return 'Chờ xác nhận';
    case AdminBookingStatus.confirmed:
      return 'Đã xác nhận';
    case AdminBookingStatus.completed:
      return 'Hoàn thành';
    case AdminBookingStatus.cancelled:
      return 'Đã hủy';
  }
}
