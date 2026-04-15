import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Global logger instance.
///
/// Usage:
///   appLogger.d('debug message');
///   appLogger.i('info message');
///   appLogger.w('warning message');
///   appLogger.e('error message', error: e, stackTrace: st);
final appLogger = AppLogger._instance;

class AppLogger {
  AppLogger._();

  static final AppLogger _instance = AppLogger._();

  late final Logger _logger = Logger(
    level: kDebugMode ? Level.trace : Level.warning,
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: false,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    output: kDebugMode ? ConsoleOutput() : _ProductionOutput(),
  );

  void t(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.t(message, error: error, stackTrace: stackTrace);

  void d(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.d(message, error: error, stackTrace: stackTrace);

  void i(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.i(message, error: error, stackTrace: stackTrace);

  void w(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.w(message, error: error, stackTrace: stackTrace);

  void e(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.e(message, error: error, stackTrace: stackTrace);

  void f(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.f(message, error: error, stackTrace: stackTrace);
}

/// In production only emit warning-level and above to avoid leaking
/// sensitive data through verbose logs.
class _ProductionOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    if (event.level.index >= Level.warning.index) {
      // ignore: avoid_print
      event.lines.forEach(print);
    }
  }
}
