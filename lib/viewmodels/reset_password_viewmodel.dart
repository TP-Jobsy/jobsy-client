import 'package:flutter/material.dart';

import 'auth_provider.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final AuthProvider _auth;
  bool _isLoading = false;
  String? _errorMessage;

  ResetPasswordViewModel(this._auth);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> resetPassword({
    required String email,
    required String resetCode,
    required String newPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _auth.resetPassword(email, resetCode, newPassword);
    } on Exception catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
