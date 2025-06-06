import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:jobsy/service/profile_service.dart';
import 'package:jobsy/model/profile/free/freelancer_profile_dto.dart';
import 'package:jobsy/model/profile/free/freelancer_profile_basic_dto.dart';
import 'package:jobsy/model/profile/free/freelancer_profile_about_dto.dart';

import '../model/profile/free/freelancer_profile_contact_dto.dart';
import '../service/avatar_service.dart';
import 'auth_provider.dart';

class FreelancerProfileProvider extends ChangeNotifier {
  final ProfileService _service;
  final AvatarService _avatarService;
  late AuthProvider _auth;
  String _token;

  FreelancerProfile? profile;
  String? error;
  bool loading = false;
  bool uploading = false;

  FreelancerProfileProvider({
    required ProfileService service,
    required AuthProvider authProvider,
    required AvatarService avatarService,
    required String token,
  }) : _service = service,
       _avatarService = avatarService,
       _auth = authProvider,
       _token = token {
    loadProfile();
  }

  void updateAuth(AuthProvider authProvider, String token) {
    final hasTokenChanged = _token != token;
    _auth = authProvider;
    _token = token;

    if (hasTokenChanged && token.isNotEmpty) {
      loadProfile();
    }
  }

  Future<void> loadProfile() async {
    _setLoading(true);
    try {
      profile = await _service.fetchFreelancerProfile();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    _setLoading(false);
  }

  Future<bool> updateBasic(FreelancerProfileBasic dto) async {
    _setLoading(true);
    try {
      profile = await _service.updateFreelancerBasic(dto);
      error = null;
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateContact(FreelancerProfileContact dto) async {
    _setLoading(true);
    try {
      profile = await _service.updateFreelancerContact(dto);
      error = null;
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateAbout(FreelancerProfileAbout dto) async {
    _setLoading(true);
    try {
      profile = await _service.updateFreelancerAbout(dto);
      error = null;
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteAccount() async {
    _setLoading(true);
    try {
      await _service.deleteFreelancerAccount();
      error = null;
      await _auth.logout();
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addSkill(int skillId) async {
    _setLoading(true);
    try {
      profile = await _service.addFreelancerSkill(skillId);
      error = null;
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> removeSkill(int skillId) async {
    _setLoading(true);
    try {
      profile = await _service.removeFreelancerSkill(skillId);
      error = null;
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> uploadAvatar(File file) async {
    uploading = true;
    notifyListeners();
    try {
      final url = await _avatarService.uploadFreelancerAvatar(file: file);
      await loadProfile();
      error = null;
      return true;
    } catch (e) {
      error = 'Ошибка загрузки аватара: $e';
      return false;
    } finally {
      uploading = false;
      notifyListeners();
    }
  }

  Future<void> logout() => _auth.logout();

  void _setLoading(bool v) {
    loading = v;
    notifyListeners();
  }
}
