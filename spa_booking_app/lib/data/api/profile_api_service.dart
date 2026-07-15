import 'dart:typed_data';

import '../../core/network/api_client.dart';

class ProfileApiService {
  ProfileApiService({ApiClient? client})
    : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? phone,
    String? birthDate,
    String? gender,
    String? address,
    Map<String, dynamic>? preferences,
  }) {
    final body = <String, dynamic>{};
    if (fullName != null) {
      body['fullName'] = fullName;
    }
    if (phone != null) {
      body['phone'] = phone;
    }
    if (birthDate != null) {
      body['birthDate'] = birthDate;
    }
    if (gender != null) {
      body['gender'] = gender;
    }
    if (address != null) {
      body['address'] = address;
    }
    if (preferences != null) {
      body['preferences'] = preferences;
    }
    return _client.put<Map<String, dynamic>>('/profiles/me', body: body);
  }

  Future<Map<String, dynamic>> uploadAvatar({
    required Uint8List bytes,
    required String contentType,
  }) {
    return _client.postBinary<Map<String, dynamic>>(
      '/profiles/me/avatar',
      bytes: bytes,
      contentType: contentType,
    );
  }
}
