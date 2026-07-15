import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// OAuth client IDs can be overridden at build time and otherwise come from
/// the bundled local .env file.
class GoogleAuthConfig {
  GoogleAuthConfig._();

  static const _definedWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );
  static const _definedAndroidClientId = String.fromEnvironment(
    'GOOGLE_ANDROID_CLIENT_ID',
  );
  static const _definedIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
  );
  static const _definedServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );
  static Map<String, String> _environment = const {};

  static Future<void> initialize() async {
    try {
      _environment = _parseEnvironment(await rootBundle.loadString('.env'));
    } on FlutterError {
      _environment = const {};
    }
  }

  static String get webClientId =>
      _configuredValue(_definedWebClientId, 'GOOGLE_WEB_CLIENT_ID');

  static String get androidClientId =>
      _configuredValue(_definedAndroidClientId, 'GOOGLE_ANDROID_CLIENT_ID');

  static String get iosClientId =>
      _configuredValue(_definedIosClientId, 'GOOGLE_IOS_CLIENT_ID');

  static String get serverClientId {
    final configured = _configuredValue(
      _definedServerClientId,
      'GOOGLE_SERVER_CLIENT_ID',
    );
    return configured.isNotEmpty ? configured : webClientId;
  }

  static bool get isSupportedOnCurrentPlatform {
    if (kIsWeb) {
      return true;
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.macOS => true,
      _ => false,
    };
  }

  static bool get isConfiguredForCurrentPlatform {
    if (kIsWeb) {
      return webClientId.isNotEmpty;
    }

    return switch (defaultTargetPlatform) {
      // Android needs the Web/server OAuth client id at build time.
      TargetPlatform.android => serverClientId.isNotEmpty,
      TargetPlatform.iOS || TargetPlatform.macOS =>
        iosClientId.isNotEmpty && serverClientId.isNotEmpty,
      _ => false,
    };
  }

  static String? get clientId {
    if (kIsWeb) {
      return _emptyToNull(webClientId);
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS || TargetPlatform.macOS => _emptyToNull(iosClientId),
      _ => null,
    };
  }

  static String? get backendClientId => _emptyToNull(serverClientId);

  static String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String _configuredValue(String buildValue, String environmentKey) {
    final defined = buildValue.trim();
    return defined.isNotEmpty
        ? defined
        : (_environment[environmentKey] ?? '').trim();
  }

  static Map<String, String> _parseEnvironment(String source) {
    final values = <String, String>{};

    for (final rawLine in source.split(RegExp(r'\r?\n'))) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) {
        continue;
      }

      final separator = line.indexOf('=');
      if (separator <= 0) {
        continue;
      }

      final key = line.substring(0, separator).trim();
      var value = line.substring(separator + 1).trim();
      if (value.length >= 2 &&
          ((value.startsWith('"') && value.endsWith('"')) ||
              (value.startsWith("'") && value.endsWith("'")))) {
        value = value.substring(1, value.length - 1);
      }
      values[key] = value;
    }

    return values;
  }
}
