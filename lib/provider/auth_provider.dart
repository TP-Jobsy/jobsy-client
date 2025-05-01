import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/auth_request.dart';
import '../model/registration_response.dart';
import '../model/user.dart';
import '../service/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _api;

  String? _token;
  UserDto? _user;

  AuthProvider({ApiService? apiService}) : _api = apiService ?? ApiService() {
    _loadFromPrefs();
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('token');
    if (saved != null) {
      _token = saved;
      notifyListeners();
    }
  }

  String? get token => _token;
  UserDto? get user => _user;
  bool get isLoggedIn => _token != null;

  Future<void> login(AuthRequest req) async {
    final resp = await _api.login(req);
    _token = resp.token;
    _user = resp.user;
    await _saveToken(_token!);
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  Future<RegistrationResponse> register(Map<String, dynamic> data) async {
    final resp = await _api.register(data);
    return resp;
  }

  Future<void> requestPasswordReset(String email) =>
      _api.requestPasswordReset(email);

  Future<void> resendConfirmation(String email) =>
      _api.resendConfirmation(email);

  Future<void> confirmEmail(
      String email,
      String code, {
        required String action,
      }) =>
      _api.confirmEmail(email, code, action: action);

  Future<void> resetPassword(
      String email,
      String resetCode,
      String newPassword,
      ) =>
      _api.confirmPasswordReset(email, resetCode, newPassword);

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('token');
    if (saved != null) {
      _token = saved;
      notifyListeners();
    }
  }

  Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
}