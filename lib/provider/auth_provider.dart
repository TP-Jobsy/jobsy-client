import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/auth/auth_request.dart';
import '../model/auth/registration_response.dart';
import '../model/user.dart';
import '../service/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _api;

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

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _role = prefs.getString('role');
    _token = prefs.getString('token');
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token != null && _role != null) {
      await prefs.setString('token', _token!);
      await prefs.setString('role',  _role!);
    }
  }

  Future<void> login(AuthRequest req) async {
    final resp = await _api.login(req);
    _token = resp.token;
    _user  = resp.user;
    _role  = resp.user.role;
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
