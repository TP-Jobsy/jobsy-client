import 'package:flutter/material.dart';
import '../viewmodels/auth_provider.dart';

class VerificationCodeViewModel extends ChangeNotifier {
  final AuthProvider _auth;
  bool _isLoading = false;
  bool _isResending = false;
  String? errorMessage;

  VerificationCodeViewModel(this._auth);

  bool get isLoading => _isLoading;

  bool get isResending => _isResending;

  Future<bool> confirmCode({
    required String email,
    required String action,
    required String code,
  }) async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (action == 'REGISTRATION') {
        await _auth.confirmEmail(email, code, action: action);
      } else {}
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resendCode({
    required String email,
    required String action,
  }) async {
    _isResending = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (action == 'REGISTRATION') {
        await _auth.resendConfirmation(email);
      } else {
        await _auth.requestPasswordReset(email);
      }
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isResending = false;
      notifyListeners();
    }
  }
}
