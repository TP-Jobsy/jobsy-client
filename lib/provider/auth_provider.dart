import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_dto.dart';
import '../model/auth_request.dart';
import '../model/auth_response.dart';
import '../service/api_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  UserDto? _user;

  String? get token => _token;
  UserDto? get user => _user;
  bool get isLoggedIn => _token != null;

  Future<void> login(AuthRequest request) async {
    final response = await ApiService.login(request);
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

  Future<void> register(Map<String, dynamic> data) async {
    final result = await ApiService.register(data);
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
  }

}
