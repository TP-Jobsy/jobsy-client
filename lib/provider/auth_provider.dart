import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/config.dart';
import '../model/user_dto.dart';
import '../model/auth_request.dart';

import '../service/i_api_service.dart';
import '../service/mock_api_service.dart' as mock;
import '../service/api_service.dart' as real;

class AuthProvider with ChangeNotifier {
  final IApiService _api = useMock ? mock.MockApiService() : real.ApiService();

  String? _token;
  UserDto? _user;

  String? get token => _token;
  UserDto? get user => _user;
  bool get isLoggedIn => _token != null;

  Future<void> login(AuthRequest request) async {
    final response = await _api.login(request);
    _token = response.token;
    _user = response.user;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);

    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    notifyListeners();
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final result = await _api.register(data);
    if (result.containsKey('token') && result.containsKey('user')) {
      _token = result['token'];
      _user = UserDto.fromJson(result['user']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      notifyListeners();
    }
    if (result.containsKey('message')) {
      debugPrint('Регистрация: ${result['message']}');
    }
    return result;
  }

  Future<void> confirmEmail(String email, String code) async {
    await _api.confirmEmail(email, code);
  }

  Future<void> updateUserRole(String userId, String role) async {
    if (_token == null) throw Exception('Нет токена');
    await _api.updateUserRole(userId: userId, role: role, token: _token!);
  }
}
