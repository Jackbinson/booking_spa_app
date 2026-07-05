// foundation cung cấp ChangeNotifier để phát tín hiệu rebuild cho UI.
import 'package:flutter/foundation.dart';

// Import ApiClient để lưu token và AuthApiService để gọi backend thật.
import '../core/network/api_client.dart';
import '../data/api/auth_api_service.dart';
import '../data/mock_user.dart';
import '../models/user_profile.dart';

// Provider quản lý trạng thái đăng nhập, user hiện tại và token phiên làm việc.
class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthApiService? apiService})
    : _apiService = apiService ?? AuthApiService();

  final AuthApiService _apiService;

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;
  UserProfile _currentUser = mockUser;
  String? _accessToken;
  String? _refreshToken;

  // Các getter chỉ đọc giúp UI lấy state mà không sửa trực tiếp biến private.
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserProfile get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  // Đăng nhập qua backend, luôn tắt loading trong finally để UI không bị kẹt.
  Future<bool> login({
    required String account,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final session = await _apiService.login(
        email: account.trim(),
        password: password,
      );
      _applySession(session);
      return true;
    } catch (error) {
      _errorMessage = _messageFrom(error, 'Đăng nhập thất bại.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Đăng ký tài khoản mới qua backend và tự đăng nhập bằng session trả về.
  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final session = await _apiService.register(
        fullName: fullName.trim(),
        email: email.trim(),
        phone: phone.trim(),
        password: password,
      );
      _applySession(session);
      return true;
    } catch (error) {
      _errorMessage = _messageFrom(error, 'Đăng ký thất bại.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Xóa lỗi hiện tại để form có thể ẩn thông báo cũ.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Đăng xuất bằng cách xóa trạng thái xác thực và token.
  void logout() {
    _isAuthenticated = false;
    _accessToken = null;
    _refreshToken = null;
    ApiClient.instance.setAccessToken(null);
    notifyListeners();
  }

  // Gán user/token thật từ backend rồi lưu access token cho các API tiếp theo.
  void _applySession(AuthSession session) {
    _currentUser = session.user;
    _accessToken = session.accessToken;
    _refreshToken = session.refreshToken;
    _isAuthenticated = session.accessToken.isNotEmpty;
    _errorMessage = null;
    ApiClient.instance.setAccessToken(session.accessToken);
    notifyListeners();
  }

  // Cập nhật trạng thái loading và dọn lỗi cũ khi bắt đầu request mới.
  void _setLoading(bool value) {
    _isLoading = value;
    if (value) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  // Chuẩn hóa exception thành message thân thiện cho SnackBar/form.
  String _messageFrom(Object error, String fallback) {
    final message = error.toString().trim();
    return message.isEmpty ? fallback : message;
  }
}
