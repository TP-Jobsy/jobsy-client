import 'package:flutter/foundation.dart';
import 'package:jobsy/service/profile_service.dart';
import 'package:jobsy/model/freelancer_profile_dto.dart';
import 'package:jobsy/model/freelancer_profile_basic_dto.dart';
import 'package:jobsy/model/freelancer_profile_contact_dto.dart';
import 'package:jobsy/model/freelancer_profile_about_dto.dart';
import 'package:jobsy/provider/auth_provider.dart';

class FreelancerProfileProvider extends ChangeNotifier {
  final ProfileService _service;
  final AuthProvider _auth;
  String _token;

  FreelancerProfileDto? profile;
  String? error;
  bool loading = false;

  FreelancerProfileProvider({
    required ProfileService service,
    required AuthProvider authProvider,
    required String token,
  }) : _service = service,
       _auth = authProvider,
       _token = token {
    loadProfile();
  }

  void updateAuth(AuthProvider authProvider, String token) {
    if (_token != token || _auth != authProvider) {}
  }

  Future<void> loadProfile() async {
    _setLoading(true);
    try {
      profile = await _service.fetchFreelancerProfile(_token);
      error = null;
    } catch (e) {
      error = e.toString();
    }
    _setLoading(false);
  }

  Future<bool> updateBasic(FreelancerProfileBasicDto dto) async {
    _setLoading(true);
    try {
      profile = await _service.updateFreelancerBasic(_token, dto);
      error = null;
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateContact(FreelancerProfileContactDto dto) async {
    _setLoading(true);
    try {
      profile = await _service.updateFreelancerContact(_token, dto);
      error = null;
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateAbout(FreelancerProfileAboutDto dto) async {
    _setLoading(true);
    try {
      profile = await _service.updateFreelancerAbout(_token, dto);
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
      await _service.deleteFreelancerAccount(_token);
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

  Future<void> logout() => _auth.logout();

  void _setLoading(bool v) {
    loading = v;
    notifyListeners();
  }
}
