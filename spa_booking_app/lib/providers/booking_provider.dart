import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../data/mock_services.dart';
import '../models/appointment.dart';
import '../models/spa_service.dart';

class BookingProvider extends ChangeNotifier {
  final List<Appointment> _appointments = [
    Appointment(
      id: 'sample-1',
      service: mockServices.first,
      date: DateTime.now().add(const Duration(days: 1)),
      time: '10:00',
      customerName: 'Trần Trung Kiên',
      phone: '0901 234 567',
      note: 'Ưu tiên phòng yên tĩnh',
      status: AppointmentStatus.pending,
    ),
    Appointment(
      id: 'sample-2',
      service: mockServices[1],
      date: DateTime.now().subtract(const Duration(days: 2)),
      time: '15:00',
      customerName: 'Trần Trung Kiên',
      phone: '0901 234 567',
      note: '',
      status: AppointmentStatus.completed,
    ),
  ];

  int _currentTabIndex = 0;

  List<Appointment> get appointments => List.unmodifiable(_appointments);

  int get currentTabIndex => _currentTabIndex;

  void setCurrentTab(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void addAppointment({
    required SpaService service,
    required DateTime date,
    required String time,
    required String customerName,
    required String phone,
    required String note,
  }) {
    _appointments.insert(
      0,
      Appointment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        service: service,
        date: date,
        time: time,
        customerName: customerName,
        phone: phone,
        note: note,
        status: AppointmentStatus.pending,
      ),
    );
    notifyListeners();
  }

  void cancelAppointment(String id) {
    final index = _appointments.indexWhere(
      (appointment) => appointment.id == id,
    );
    if (index == -1) {
      return;
    }

    _appointments[index] = _appointments[index].copyWith(
      status: AppointmentStatus.cancelled,
    );
    notifyListeners();
  }
}

String formatMoney(int amount) {
  return '${NumberFormat('#,###', 'vi_VN').format(amount).replaceAll(',', '.')}đ';
}

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String statusText(AppointmentStatus status) {
  switch (status) {
    case AppointmentStatus.pending:
      return 'Chờ xác nhận';
    case AppointmentStatus.confirmed:
      return 'Đã xác nhận';
    case AppointmentStatus.completed:
      return 'Đã hoàn thành';
    case AppointmentStatus.cancelled:
      return 'Đã hủy';
  }
}
