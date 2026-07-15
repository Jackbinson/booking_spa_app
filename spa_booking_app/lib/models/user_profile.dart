class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.birthday,
    required this.gender,
    required this.avatar,
    this.role = 'customer',
    this.id = '',
    this.address = '',
    this.bookingUpdatesEnabled = true,
    this.promotionsEnabled = true,
  });

  final String fullName;
  final String email;
  final String phone;
  final String birthday;
  final String gender;
  final String avatar;
  final String role;
  final String id;
  final String address;
  final bool bookingUpdatesEnabled;
  final bool promotionsEnabled;

  bool get isAdmin => role.toLowerCase() == 'admin';

  factory UserProfile.fromApiJson(Map<String, dynamic> json) {
    final profile = json['profile'];
    final profileMap = profile is Map<String, dynamic>
        ? profile
        : const <String, dynamic>{};
    final preferences = profileMap['preferences'];
    final preferenceMap = preferences is Map<String, dynamic>
        ? preferences
        : const <String, dynamic>{};
    final notifications = preferenceMap['notifications'];
    final notificationMap = notifications is Map<String, dynamic>
        ? notifications
        : const <String, dynamic>{};

    return UserProfile(
      id: json['id']?.toString() ?? '',
      fullName:
          json['fullName']?.toString() ??
          json['full_name']?.toString() ??
          'Khách hàng',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      birthday:
          profileMap['birthDate']?.toString() ??
          profileMap['birth_date']?.toString() ??
          '',
      gender: _genderLabel(profileMap['gender']?.toString()),
      avatar:
          profileMap['avatarUrl']?.toString() ??
          profileMap['avatar_url']?.toString() ??
          '',
      role: json['role']?.toString() ?? 'customer',
      address: profileMap['address']?.toString() ?? '',
      bookingUpdatesEnabled: notificationMap['bookingUpdates'] as bool? ?? true,
      promotionsEnabled: notificationMap['promotions'] as bool? ?? true,
    );
  }

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
