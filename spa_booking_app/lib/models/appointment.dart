import 'spa_service.dart';

enum AppointmentStatus { pending, confirmed, completed, cancelled }

class Appointment {
  const Appointment({
    required this.id,
    required this.service,
    required this.date,
    required this.time,
    required this.customerName,
    required this.phone,
    required this.note,
    required this.status,
  });

  final String id;
  final SpaService service;
  final DateTime date;
  final String time;
  final String customerName;
  final String phone;
  final String note;
  final AppointmentStatus status;

  Appointment copyWith({AppointmentStatus? status}) {
    return Appointment(
      id: id,
      service: service,
      date: date,
      time: time,
      customerName: customerName,
      phone: phone,
      note: note,
      status: status ?? this.status,
    );
  }
}
