import 'package:intl/intl.dart';

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Models
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

enum AdminBookingStatus { pending, confirmed, completed, cancelled }

class AdminBooking {
  const AdminBooking({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.serviceName,
    required this.dateTime,
    required this.price,
    required this.status,
    this.note = '',
    this.room = '',
  });

  final String id;
  final String customerName;
  final String phone;
  final String serviceName;
  final DateTime dateTime;
  final int price;
  final AdminBookingStatus status;
  final String note;
  final String room;
}

class AdminCustomer {
  const AdminCustomer({
    required this.id,
    required this.name,
    required this.phone,
    required this.totalBookings,
    required this.totalSpent,
    required this.tag,
    this.avatarUrl = '',
  });

  final String id;
  final String name;
  final String phone;
  final int totalBookings;
  final int totalSpent;
  final String tag; // 'VIP', 'Má»›i', 'ThÃ¢n thiáº¿t'
  final String avatarUrl;
}

class AdminService {
  const AdminService({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.durationMinutes,
    required this.description,
    required this.isActive,
    this.imageUrl = '',
  });

  final String id;
  final String name;
  final String category;
  final int price;
  final int durationMinutes;
  final String description;
  final bool isActive;
  final String imageUrl;
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Mock Data
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

final List<AdminBooking> mockAdminBookings = [
  AdminBooking(
    id: 'SP001',
    customerName: 'Nguyá»…n Minh Anh',
    phone: '090 123 4567',
    serviceName: 'Massage thÆ° giÃ£n (Body)',
    dateTime: DateTime(2023, 10, 15, 10, 0),
    price: 450000,
    status: AdminBookingStatus.completed,
    note: 'TÃ´i muá»‘n massage nháº¹ vÃ¹ng vai gÃ¡y',
    room: 'PhÃ²ng 02',
  ),
  AdminBooking(
    id: 'SP002',
    customerName: 'Tráº§n Thá»‹ BÃ­ch Ngá»c',
    phone: '091 888 9999',
    serviceName: 'ChÄƒm sÃ³c da máº·t chuyÃªn sÃ¢u',
    dateTime: DateTime(2023, 10, 16, 14, 30),
    price: 720000,
    status: AdminBookingStatus.pending,
    room: 'PhÃ²ng 01',
  ),
  AdminBooking(
    id: 'SP003',
    customerName: 'LÃª VÄƒn HÃ¹ng',
    phone: '098 765 4321',
    serviceName: 'Massage chÃ¢n tháº£o dÆ°á»£c',
    dateTime: DateTime(2023, 10, 17, 9, 15),
    price: 380000,
    status: AdminBookingStatus.confirmed,
    room: 'PhÃ²ng 04',
  ),
  AdminBooking(
    id: 'SP004',
    customerName: 'Pháº¡m Thá»‹ Lan',
    phone: '097 111 2222',
    serviceName: 'Gá»™i Ä‘áº§u dÆ°á»¡ng sinh',
    dateTime: DateTime(2023, 10, 18, 11, 0),
    price: 250000,
    status: AdminBookingStatus.pending,
    room: 'PhÃ²ng 03',
  ),
  AdminBooking(
    id: 'SP005',
    customerName: 'VÃµ Minh Tuáº¥n',
    phone: '093 444 5555',
    serviceName: 'Massage Ä‘Ã¡ nÃ³ng',
    dateTime: DateTime(2023, 10, 18, 15, 0),
    price: 850000,
    status: AdminBookingStatus.confirmed,
    room: 'PhÃ²ng 05',
  ),
];

final List<AdminCustomer> mockAdminCustomers = [
  const AdminCustomer(
    id: 'C001',
    name: 'Tráº§n Thanh HÃ ',
    phone: '0912 345 678',
    totalBookings: 12,
    totalSpent: 5800000,
    tag: 'VIP',
    avatarUrl: 'https://i.pravatar.cc/150?img=47',
  ),
  const AdminCustomer(
    id: 'C002',
    name: 'Nguyá»…n Minh Anh',
    phone: '0988 776 554',
    totalBookings: 2,
    totalSpent: 1200000,
    tag: 'Má»›i',
    avatarUrl: 'https://i.pravatar.cc/150?img=48',
  ),
  const AdminCustomer(
    id: 'C003',
    name: 'LÃª Thá»‹ Mai',
    phone: '0345 123 999',
    totalBookings: 28,
    totalSpent: 12400000,
    tag: 'ThÃ¢n thiáº¿t',
    avatarUrl: 'https://i.pravatar.cc/150?img=49',
  ),
];

final List<AdminService> mockAdminServices = [
  const AdminService(
    id: 'SV001',
    name: 'Massage thÆ° giÃ£n',
    category: 'Massage',
    price: 450000,
    durationMinutes: 60,
    description: 'Liá»‡u phÃ¡p massage toÃ n thÃ¢n káº¿t há»£p tinh dáº§u Lavender giÃºp giáº£m cÄƒng tháº³ng.',
    isActive: true,
    imageUrl: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=400',
  ),
  const AdminService(
    id: 'SV002',
    name: 'ChÄƒm sÃ³c da máº·t',
    category: 'Facial',
    price: 550000,
    durationMinutes: 75,
    description: 'Liá»‡u trÃ¬nh lÃ m sáº¡ch sÃ¢u, cáº¥p áº©m vÃ  tráº» hÃ³a lÃ n da vá»›i sáº£n pháº©m cao cáº¥p.',
    isActive: true,
    imageUrl: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=400',
  ),
  const AdminService(
    id: 'SV003',
    name: 'Gá»™i Ä‘áº§u dÆ°á»¡ng sinh',
    category: 'TÃ³c',
    price: 250000,
    durationMinutes: 45,
    description: 'Gá»™i Ä‘áº§u báº±ng tháº£o má»™c káº¿t há»£p massage áº¥n huyá»‡t vÃ¹ng Ä‘áº§u, cá»•, vai.',
    isActive: false,
    imageUrl: 'https://images.unsplash.com/photo-1595476108010-b4d1f102b1b1?w=400',
  ),
];

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Helpers
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

String formatAdminMoney(int amount) {
  final formatted = NumberFormat('#,###', 'vi_VN').format(amount).replaceAll(',', '.');
  return '$formatted\u0111';
}

String formatAdminDate(DateTime dt) => DateFormat('dd/MM/yyyy').format(dt);
String formatAdminTime(DateTime dt) => DateFormat('HH:mm').format(dt);
String formatAdminDateTime(DateTime dt) => '${formatAdminTime(dt)} - ${formatAdminDate(dt)}';
