// Thư viện Material cung cấp hàm runApp và hệ widget Flutter.
import 'package:flutter/material.dart';

// Import widget gốc của ứng dụng.
import 'app.dart';
import 'core/config/google_auth_config.dart';

// Hàm main là điểm bắt đầu chạy app Flutter.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleAuthConfig.initialize();
  runApp(const MyApp());
}
