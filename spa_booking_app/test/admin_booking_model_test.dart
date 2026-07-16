import 'package:flutter_test/flutter_test.dart';
import 'package:spa_booking_app/admin/models/admin_mock_data.dart';

void main() {
  test('AdminBooking parses the customer id returned by the backend', () {
    final booking = AdminBooking.fromJson({
      'id': 'booking-1',
      'user_id': 'customer-1',
      'customer_name': 'Khách hàng',
      'appointment_time': '2026-07-16T09:00:00.000Z',
      'total_price': 450000,
      'status': 'completed',
      'payment_status': 'paid',
    });

    expect(booking.customerId, 'customer-1');
    expect(booking.status, AdminBookingStatus.completed);
    expect(booking.paymentStatus, AdminPaymentStatus.paid);
  });

  test('copyWith keeps the customer id', () {
    final booking = AdminBooking(
      id: 'booking-1',
      customerId: 'customer-1',
      customerName: 'Khách hàng',
      phone: '',
      serviceName: 'Massage',
      dateTime: DateTime(2026, 7, 16),
      price: 450000,
      status: AdminBookingStatus.pending,
    );

    final updated = booking.copyWith(status: AdminBookingStatus.confirmed);

    expect(updated.customerId, 'customer-1');
  });
}
