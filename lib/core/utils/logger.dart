import 'dart:developer' as developer;

class Logger {
  static void d(String message, {String tag = 'APP_DEBUG'}) {
    developer.log(message, name: tag, level: 500);
  }

  static void e(String message, {String tag = 'APP_ERROR', Object? error}) {
    developer.log(message, name: tag, level: 1000, error: error);
  }

  static void i(String message, {String tag = 'APP_INFO'}) {
    developer.log(message, name: tag, level: 800);
  }
}