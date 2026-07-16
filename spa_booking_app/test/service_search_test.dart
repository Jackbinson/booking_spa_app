import 'package:flutter_test/flutter_test.dart';
import 'package:spa_booking_app/data/mock_services.dart';

void main() {
  test('tìm dịch vụ tiếng Việt không cần nhập dấu', () {
    final skinCare = filterServices(
      category: allServicesCategory,
      keyword: 'cham soc da',
    );
    final hairWash = filterServices(
      category: allServicesCategory,
      keyword: 'goi dau',
    );
    final acneCare = filterServices(
      category: allServicesCategory,
      keyword: 'mun',
    );

    expect(
      skinCare.any((service) => service.name.contains('Chăm sóc da')),
      true,
    );
    expect(hairWash.any((service) => service.name.contains('Gội đầu')), true);
    expect(acneCare.any((service) => service.name.contains('mụn')), true);
  });

  test('tìm kiếm vẫn tôn trọng danh mục đang chọn', () {
    final results = filterServices(category: 'Massage', keyword: 'da');

    expect(results, isNotEmpty);
    expect(results.every((service) => service.category == 'Massage'), true);
  });
}
