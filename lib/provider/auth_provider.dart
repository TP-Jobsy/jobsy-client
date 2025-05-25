import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/auth/auth_request.dart';
import '../model/auth/registration_response.dart';
import '../model/auth/token_refresh_request.dart';
import '../model/user.dart';
import '../service/auth_service.dart';

class AuthProvider with ChangeNotifier {
  late final AuthService _api;
  bool _isLoaded = false;

  String? _token;
  String? _role;
  String? _refreshToken;
  DateTime? _refreshExpiry;
  UserDto? _user;

  AuthProvider({AuthService? apiService}) {
    _api = apiService ?? AuthService(
      getToken: () async {
        await ensureLoaded();
        return _token;
      },
      refreshToken: () async {
        await refreshTokens();
      },
    );
    loadFromPrefs();
  }

  String? get token => _token;

  String? get role => _role;

  String? get refreshToken => _refreshToken;

  DateTime? get refreshTokenExpiry => _refreshExpiry;

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
    _refreshToken = prefs.getString('refreshToken');
    final expiryStr = prefs.getString('refreshTokenExpiry');
    if (expiryStr != null) {
      _refreshExpiry = DateTime.parse(expiryStr);
    }
    final userJson = prefs.getString('user');
    if (userJson != null) {
      _user = UserDto.fromJson(jsonDecode(userJson));
    }
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token != null &&
        _refreshToken != null &&
        _refreshExpiry != null &&
        _role != null &&
        _user != null) {
      await prefs.setString('token', _token!);
      await prefs.setString('refreshToken', _refreshToken!);
      await prefs.setString('role', _role!);
      await prefs.setString(
        'refreshTokenExpiry',
        _refreshExpiry!.toUtc().toIso8601String(),
      );
      await prefs.setString('user', jsonEncode(_user!.toJson()));
    }
  }

  Future<void> login(AuthRequest req) async {
    final resp = await _api.login(req);
    _token = resp.accessToken;
    _refreshToken = resp.refreshToken;
    _refreshExpiry = resp.refreshTokenExpiry;
    _user = resp.user;
    _role = resp.user.role;
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> refreshTokens() async {
    if (_refreshToken == null) throw Exception("No refresh token");
    final req = TokenRefreshRequest(refreshToken: _refreshToken!);
    final resp = await _api.refresh(req);
    _token = resp.accessToken;
    _refreshToken = resp.refreshToken;
    _refreshExpiry = resp.refreshTokenExpiry;
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _refreshToken = null;
    _refreshExpiry = null;
    _user = null;
    _role = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refreshToken');
    await prefs.remove('refreshTokenExpiry');
    await prefs.remove('user');
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
