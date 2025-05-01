import 'package:flutter/material.dart';
import '../service/profile_service.dart';
import '../model/client_profile_basic_dto.dart';
import '../model/client_profile_contact_dto.dart';
import '../model/client_profile_field_dto.dart';
import '../model/client_profile.dart';
import 'auth_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _service;
  final AuthProvider authProvider;
  final String token;

  ClientProfileDto? _profile;
  bool _loading = false;
  String? _error;

  ProfileProvider({
    required this.authProvider,
    required this.token,
    ProfileService? service,
  }) : _service = service ?? ProfileService();

  ClientProfileDto? get profile => _profile;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadProfile() async {
    _setLoading(true);
    try {
      _profile = await _service.fetchProfile(token);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> saveBasic(ClientProfileBasicDto dto) async {
    _setLoading(true);
    try {
      _profile = await _service.updateBasic(token, dto);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> saveContact(ClientProfileContactDto dto) async {
    _setLoading(true);
    try {
      _profile = await _service.updateContact(token, dto);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> saveField(ClientProfileFieldDto dto) async {
    _setLoading(true);
    try {
      _profile = await _service.updateField(token, dto);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> deleteAccount() async {
    _setLoading(true);
    try {
      await _service.deleteAccount(token);
      _error = null;
      await authProvider.logout();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> logout() => authProvider.logout();

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}