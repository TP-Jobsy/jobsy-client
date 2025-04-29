import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/auth_request.dart';
import '../model/auth_response.dart';
import '../model/user_dto.dart';
import '../service/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _api;

  String? _token;
  UserDto? _user;

  AuthProvider({ApiService? apiService}) : _api = apiService ?? ApiService() {
    _loadFromPrefs();
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

  Future<AuthResponse> register(Map<String, dynamic> data) async {
    final respMap = await _api.register(data);
    return AuthResponse.fromJson(respMap);
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