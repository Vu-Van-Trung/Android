import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();

  factory SettingsService() {
    return _instance;
  }

  SettingsService._internal();

  late SharedPreferences _prefs;

  bool _darkMode = true;
  bool _messageNotification = true;
  bool _soundNotification = true;
  bool _vibration = true;
  bool _fingerprintLogin = false;
  bool _twoFactorAuth = true;

  bool get darkMode => _darkMode;
  bool get messageNotification => _messageNotification;
  bool get soundNotification => _soundNotification;
  bool get vibration => _vibration;
  bool get fingerprintLogin => _fingerprintLogin;
  bool get twoFactorAuth => _twoFactorAuth;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _darkMode = _prefs.getBool('darkMode') ?? true;
    _messageNotification = _prefs.getBool('messageNotification') ?? true;
    _soundNotification = _prefs.getBool('soundNotification') ?? true;
    _vibration = _prefs.getBool('vibration') ?? true;
    _fingerprintLogin = _prefs.getBool('fingerprintLogin') ?? false;
    _twoFactorAuth = _prefs.getBool('twoFactorAuth') ?? true;
    notifyListeners();
  }

  Future<void> updateDarkMode(bool value) async {
    _darkMode = value;
    await _prefs.setBool('darkMode', value);
    notifyListeners();
  }

  Future<void> updateMessageNotification(bool value) async {
    _messageNotification = value;
    await _prefs.setBool('messageNotification', value);
    notifyListeners();
  }

  Future<void> updateSoundNotification(bool value) async {
    _soundNotification = value;
    await _prefs.setBool('soundNotification', value);
    notifyListeners();
  }

  Future<void> updateVibration(bool value) async {
    _vibration = value;
    await _prefs.setBool('vibration', value);
    notifyListeners();
  }

  Future<void> updateFingerprintLogin(bool value) async {
    _fingerprintLogin = value;
    await _prefs.setBool('fingerprintLogin', value);
    notifyListeners();
  }

  Future<void> updateTwoFactorAuth(bool value) async {
    _twoFactorAuth = value;
    await _prefs.setBool('twoFactorAuth', value);
    notifyListeners();
  }
}
