// Model hồ sơ người dùng đang đăng nhập.
class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.birthday,
    required this.gender,
    required this.avatar,
  });

  // Họ tên hiển thị trên trang chủ và hồ sơ.
  final String fullName;
  // Email đăng nhập/liên hệ của người dùng.
  final String email;
  // Số điện thoại dùng khi đặt lịch.
  final String phone;
  // Ngày sinh dạng chuỗi hiển thị, có fallback nếu API chưa có.
  final String birthday;
  // Giới tính đã được chuyển sang nhãn tiếng Việt.
  final String gender;
  // URL ảnh đại diện; rỗng thì UI dùng avatar mặc định.
  final String avatar;

  // Chuyển JSON user/profile từ backend thành UserProfile an toàn cho UI.
  factory UserProfile.fromApiJson(Map<String, dynamic> json) {
    final profile = json['profile'];
    final profileMap = profile is Map<String, dynamic>
        ? profile
        : const <String, dynamic>{};

    return UserProfile(
      fullName:
          json['fullName']?.toString() ??
          json['full_name']?.toString() ??
          'Khách hàng',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      birthday:
          profileMap['birthDate']?.toString() ??
          profileMap['birth_date']?.toString() ??
          'Chưa cập nhật',
      gender: _genderLabel(profileMap['gender']?.toString()),
      avatar:
          profileMap['avatarUrl']?.toString() ??
          profileMap['avatar_url']?.toString() ??
          '',
    );
  }

  // Chuẩn hóa giá trị gender từ API sang nhãn tiếng Việt.
  static String _genderLabel(String? value) {
    switch (value) {
      case 'male':
        return 'Nam';
      case 'female':
        return 'Nữ';
      case 'other':
        return 'Khác';
      default:
        return 'Chưa cập nhật';
    }
  }
}
