import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/section_title.dart';
import '../../models/spa_service.dart';
import '../../providers/booking_provider.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.service});

  final SpaService service;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedTime;

  final List<String> _times = const [
    '09:00',
    '10:00',
    '13:30',
    '15:00',
    '16:30',
    '18:00',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt lịch')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: [
            _SelectedService(service: widget.service),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Chọn ngày'),
            const SizedBox(height: 12),
            _CalendarSelector(
              selectedDate: _selectedDate,
              onDateChanged: (date) => setState(() => _selectedDate = date),
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Chọn giờ'),
            const SizedBox(height: 12),
            _TimeSelector(
              selectedTime: _selectedTime,
              suggestedTimes: _times,
              onTimeChanged: (time) => setState(() => _selectedTime = time),
            ),
            const SizedBox(height: 24),
            const SectionTitle(title: 'Thông tin khách hàng'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: 'Họ và tên',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập họ tên';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: 'Số điện thoại',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteController,
              minLines: 3,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Ghi chú thêm',
                prefixIcon: Icon(Icons.notes_outlined),
              ),
            ),
            const SizedBox(height: 22),
            _Summary(
              service: widget.service,
              selectedDate: _selectedDate,
              selectedTime: _selectedTime,
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              label: 'Xác nhận đặt lịch',
              icon: Icons.check_circle_outline,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_selectedDate == null) {
      _showError('Vui lòng chọn ngày');
      return;
    }
    if (_selectedTime == null) {
      _showError('Vui lòng chọn giờ');
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<BookingProvider>().addAppointment(
      service: widget.service,
      date: _selectedDate!,
      time: _selectedTime!,
      customerName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      note: _noteController.text.trim(),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đặt lịch thành công')));
    context.read<BookingProvider>().setCurrentTab(2);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _CalendarSelector extends StatelessWidget {
  const _CalendarSelector({
    required this.selectedDate,
    required this.onDateChanged,
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final firstDate = DateTime(today.year, today.month, today.day);
    final activeDate = selectedDate ?? firstDate;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppShadows.soft,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: AppColors.card,
            onSurface: AppColors.textDark,
          ),
        ),
        child: CalendarDatePicker(
          initialDate: activeDate,
          firstDate: firstDate,
          lastDate: firstDate.add(const Duration(days: 90)),
          onDateChanged: onDateChanged,
        ),
      ),
    );
  }
}

class _TimeSelector extends StatelessWidget {
  const _TimeSelector({
    required this.selectedTime,
    required this.suggestedTimes,
    required this.onTimeChanged,
  });

  final String? selectedTime;
  final List<String> suggestedTimes;
  final ValueChanged<String> onTimeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => _pickTime(context),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              boxShadow: AppShadows.soft,
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedTime ?? 'Bấm để chọn giờ trên đồng hồ',
                    style: TextStyle(
                      color: selectedTime == null
                          ? AppColors.textLight
                          : AppColors.textDark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textLight,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          itemCount: suggestedTimes.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.4,
          ),
          itemBuilder: (context, index) {
            final time = suggestedTimes[index];
            return CategoryChip(
              label: time,
              selected: selectedTime == time,
              onTap: () => onTimeChanged(time),
            );
          },
        ),
      ],
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final initialTime =
        _parseTime(selectedTime) ?? const TimeOfDay(hour: 9, minute: 0);
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              secondary: AppColors.secondary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) {
      return;
    }

    onTimeChanged(_formatTime(picked));
  }

  TimeOfDay? _parseTime(String? value) {
    if (value == null) {
      return null;
    }
    final parts = value.split(':');
    if (parts.length != 2) {
      return null;
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _SelectedService extends StatelessWidget {
  const _SelectedService({required this.service});

  final SpaService service;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              service.image,
              width: 82,
              height: 82,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 82,
                height: 82,
                color: AppColors.secondary,
                child: const Icon(Icons.spa, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đã chọn',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(service.name, style: AppTextStyles.sectionTitle),
                const SizedBox(height: 4),
                Text(
                  '${formatMoney(service.price)} • ${service.durationMinutes} phút',
                  style: AppTextStyles.muted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.service,
    required this.selectedDate,
    required this.selectedTime,
  });

  final SpaService service;
  final DateTime? selectedDate;
  final String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: .24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Dịch vụ', value: service.name),
          _SummaryRow(
            label: 'Ngày',
            value: selectedDate == null
                ? 'Chưa chọn'
                : formatDate(selectedDate!),
          ),
          _SummaryRow(label: 'Giờ', value: selectedTime ?? 'Chưa chọn'),
          _SummaryRow(label: 'Tổng tiền', value: formatMoney(service.price)),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.muted)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
