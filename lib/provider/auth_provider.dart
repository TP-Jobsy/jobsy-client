import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/auth/auth_request.dart';
import '../model/auth/registration_response.dart';
import '../model/user.dart';
import '../service/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _api;
  bool _isLoaded = false;

  String? _token;
  String? _role;
  UserDto? _user;

  AuthProvider({AuthService? apiService}) : _api = apiService ?? AuthService() {
    loadFromPrefs();
  }

  String? get token => _token;

  String? get role => _role;

  UserDto? get user => _user;

  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  Future<void> ensureLoaded() async {
    if (!_isLoaded) {
      await loadFromPrefs();
      _isLoaded = true;
    }
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _role = prefs.getString('role');
    _token = prefs.getString('token');
    final userJson = prefs.getString('user');
    if (userJson != null) {
      try {
        final map = jsonDecode(userJson) as Map<String, dynamic>;
        _user = UserDto.fromJson(map);
        print('✅ Loaded user: ${_user?.id}');
      } catch (e) {
        print('⚠️ Failed to decode user: $e');
        _user = null;
      }
    }
      notifyListeners();
  }


  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    print('📦 Saved user JSON: ${prefs.getString('user')}');
    if (_token != null && _role != null && _user != null) {
      await prefs.setString('token', _token!);
      await prefs.setString('role',  _role!);
      await prefs.setString('user', jsonEncode(_user!.toJson()));
    }
  }

  Future<void> login(AuthRequest req) async {
    final resp = await _api.login(req);
    _token = resp.token;
    _user  = resp.user;
    _role  = resp.user.role;
    print('✅ Login response user id: ${_user?.id}');
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _user  = null;
    _role  = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    notifyListeners();
  }

  Future<RegistrationResponse> register(Map<String, dynamic> data) =>
      _api.register(data);

  Future<void> requestPasswordReset(String email) =>
      _api.requestPasswordReset(email);

  Future<void> resendConfirmation(String email) =>
      _api.resendConfirmation(email);

  Future<void> confirmEmail(
    String email,
    String code, {
    required String action,
  }) => _api.confirmEmail(email, code, action: action);

  Future<void> resetPassword(
    String email,
    String resetCode,
    String newPassword,
  ) => _api.confirmPasswordReset(email, resetCode, newPassword);
}
