import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Управляет блокировкой приложения: PIN-код (хранится в secure storage,
/// не в обычных preferences) и предпочтение использовать биометрию.
///
/// PIN никогда не хранится в открытом виде дольше необходимого и не
/// логируется. flutter_secure_storage использует Keychain (iOS) /
/// EncryptedSharedPreferences (Android).
class SecurityProvider extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  static const _keyPin = 'security.pin';
  static const _keyAppLockEnabled = 'security.appLockEnabled';
  static const _keyBiometricEnabled = 'security.biometricEnabled';

  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _appLockEnabled = false;
  bool get appLockEnabled => _appLockEnabled;

  bool _biometricEnabled = false;
  bool get biometricEnabled => _biometricEnabled;

  bool _hasPin = false;
  bool get hasPin => _hasPin;

  bool _biometricAvailable = false;
  bool get biometricAvailable => _biometricAvailable;

  /// true, пока приложение заблокировано и ждёт ввода PIN/биометрии.
  bool _locked = false;
  bool get locked => _locked;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _appLockEnabled = prefs.getBool(_keyAppLockEnabled) ?? false;
    _biometricEnabled = prefs.getBool(_keyBiometricEnabled) ?? false;

    final storedPin = await _storage.read(key: _keyPin);
    _hasPin = storedPin != null && storedPin.isNotEmpty;

    try {
      _biometricAvailable =
          await _localAuth.canCheckBiometrics && await _localAuth.isDeviceSupported();
    } catch (_) {
      _biometricAvailable = false;
    }

    // При старте приложение блокируется, если защита включена и PIN задан.
    _locked = _appLockEnabled && _hasPin;
    notifyListeners();
  }

  Future<void> setPin(String pin) async {
    await _storage.write(key: _keyPin, value: pin);
    _hasPin = true;
    notifyListeners();
  }

  Future<bool> verifyPin(String pin) async {
    final stored = await _storage.read(key: _keyPin);
    return stored != null && stored == pin;
  }

  Future<void> clearPin() async {
    await _storage.delete(key: _keyPin);
    _hasPin = false;
    await setAppLockEnabled(false);
  }

  Future<void> setAppLockEnabled(bool value) async {
    _appLockEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAppLockEnabled, value);
  }

  Future<void> setBiometricEnabled(bool value) async {
    _biometricEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyBiometricEnabled, value);
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to unlock Inverter CRM',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  void unlock() {
    _locked = false;
    notifyListeners();
  }

  /// Вызывается, когда приложение уходит в фон и снова возвращается,
  /// чтобы повторно потребовать разблокировку.
  void relock() {
    if (_appLockEnabled && _hasPin) {
      _locked = true;
      notifyListeners();
    }
  }
}
