import 'dart:io';
import 'package:flutter/foundation.dart';
import '../model/profile/client/client_profile_contact_dto.dart';
import '../service/avatar_service.dart';
import '../service/profile_service.dart';
import '../model/profile/client/client_profile.dart';
import '../model/profile/client/client_profile_basic_dto.dart';
import '../model/profile/client/client_profile_field_dto.dart';
import 'auth_provider.dart';

class ClientProfileProvider extends ChangeNotifier {
  late AuthProvider _auth;
  late final ProfileService _service;
  late final AvatarService _avatarService;

  ClientProfile? _profile;
  bool _loading = false;
  String? _error;

  ClientProfileProvider({
    required AuthProvider authProvider,
    ProfileService? service,
    AvatarService? avatarService,
  }) {
    updateAuth(authProvider, authProvider.token ?? '');
  }

  ClientProfile? get profile => _profile;

  bool get loading => _loading;

  String? get error => _error;

  void updateAuth(AuthProvider authProvider, String token) {
    _auth = authProvider;

    _service = ProfileService(
      getToken: () async {
        await _auth.ensureLoaded();
        return _auth.token;
      },
      refreshToken: () async => _auth.refreshTokens(),
    );

    _avatarService = AvatarService(
      getToken: () async {
        await _auth.ensureLoaded();
        return _auth.token;
      },
      refreshToken: () async => _auth.refreshTokens(),
    );
  }

  Future<void> loadProfile() async {
    _setLoading(true);
    try {
      _profile = await _service.fetchClientProfile();
      _error = null;
    } catch (e) {
      _error = 'Ошибка загрузки профиля: $e';
    }
    _setLoading(false);
  }

  Future<void> saveBasic(ClientProfileBasic dto) async {
    _setLoading(true);
    try {
      _profile = await _service.updateClientBasic(dto);
      _error = null;
    } catch (e) {
      _error = 'Ошибка сохранения данных: $e';
    }
    _setLoading(false);
  }

  Future<void> saveContact(ClientProfileContact dto) async {
    _setLoading(true);
    try {
      _profile = await _service.updateClientContact(dto);
      _error = null;
    } catch (e) {
      _error = 'Ошибка при сохранении контактов: $e';
    }
    _setLoading(false);
  }

  Future<void> saveField(ClientProfileField dto) async {
    _setLoading(true);
    try {
      _profile = await _service.updateClientField(dto);
      _error = null;
    } catch (e) {
      _error = 'Ошибка при сохранении сферы деятельности: $e';
    }
    _setLoading(false);
  }

  Future<void> deleteAccount() async {
    _setLoading(true);
    try {
      await _service.deleteClientAccount();
      _error = null;
      await _auth.logout();
    } catch (e) {
      _error = 'Ошибка при удалении аккаунта: $e';
    }
    _setLoading(false);
  }

  Future<void> uploadAvatar(File file) async {
    _setLoading(true);
    try {
      await _avatarService.uploadClientAvatar(file: file);
      await loadProfile();
      _error = null;
    } catch (e) {
      _error = 'Ошибка загрузки аватара: $e';
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
