import 'package:flutter/foundation.dart';
import '../service/profile_service.dart';
import '../model/client_profile.dart';
import '../model/client_profile_basic_dto.dart';
import '../model/client_profile_contact_dto.dart';
import '../model/client_profile_field_dto.dart';
import 'auth_provider.dart';

class ClientProfileProvider extends ChangeNotifier {
  final ProfileService _service;
  final AuthProvider _auth;
  String _token;

  ClientProfileDto? _profile;
  bool _loading = false;
  String? _error;

  ClientProfileProvider({
    required AuthProvider authProvider,
    required String token,
    ProfileService? service,
  })  : _service = service ?? ProfileService(),
        _auth = authProvider,
        _token = token;

  ClientProfileDto? get profile => _profile;
  bool get loading => _loading;
  String? get error => _error;

  void updateAuth(AuthProvider authProvider, String token) {
    _token = token;
    loadProfile();
  }

  Future<void> loadProfile() async {
    _setLoading(true);
    try {
      _profile = await _service.fetchClientProfile(_token);
      _error = null;
    } catch (e) {
      _error = 'Ошибка загрузки профиля: $e';
    }
    _setLoading(false);
  }

  Future<void> saveBasic(ClientProfileBasicDto dto) async {
    _setLoading(true);
    try {
      _profile = await _service.updateClientBasic(_token, dto);
      _error = null;
    } catch (e) {
      _error = 'Ошибка сохранения данных: $e';
    }
    _setLoading(false);
  }

  Future<void> saveContact(ClientProfileContactDto dto) async {
    _setLoading(true);
    try {
      _profile = await _service.updateClientContact(_token, dto);
      _error = null;
    } catch (e) {
      _error = 'Ошибка при сохранении контактов: $e';
    }
    _setLoading(false);
  }

  Future<void> saveField(ClientProfileFieldDto dto) async {
    _setLoading(true);
    try {
      _profile = await _service.updateClientField(_token, dto);
      _error = null;
    } catch (e) {
      _error = 'Ошибка при сохранении сферы деятельности: $e';
    }
    _setLoading(false);
  }

  Future<void> deleteAccount() async {
    _setLoading(true);
    try {
      await _service.deleteClientAccount(_token);
      _error = null;
      await _auth.logout();
    } catch (e) {
      _error = 'Ошибка при удалении аккаунта: $e';
    }
    _setLoading(false);
  }

  Future<void> logout() async {
    await _auth.logout();
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
