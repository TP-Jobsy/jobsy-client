import 'package:flutter/foundation.dart';
import 'package:jobsy/service/profile_service.dart';
import 'package:jobsy/model/client_profile.dart';
import 'package:jobsy/model/client_profile_basic_dto.dart';
import 'package:jobsy/model/client_profile_contact_dto.dart';
import 'package:jobsy/model/client_profile_field_dto.dart';
import 'package:jobsy/provider/auth_provider.dart';

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
  }) : _service = service ?? ProfileService(),
       _auth = authProvider,
       _token = token;

  ClientProfileDto? get profile => _profile;

  bool get loading => _loading;

  String? get error => _error;

  void updateAuth(AuthProvider authProvider, String token) {
    if (_token != token) {
      _token = token;
      loadProfile();
    }
  }

  Future<void> loadProfile() async {
    _setLoading(true);
    try {
      _profile = await _service.fetchClientProfile(_token);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> saveBasic(ClientProfileBasicDto dto) async {
    _setLoading(true);
    try {
      _profile = await _service.updateClientBasic(_token, dto);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> saveContact(ClientProfileContactDto dto) async {
    _setLoading(true);
    try {
      _profile = await _service.updateClientContact(_token, dto);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> saveField(ClientProfileFieldDto dto) async {
    _setLoading(true);
    try {
      _profile = await _service.updateClientField(_token, dto);
      _error = null;
    } catch (e) {
      _error = e.toString();
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
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> logout() => _auth.logout();

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
