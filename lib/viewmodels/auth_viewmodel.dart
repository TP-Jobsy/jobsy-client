import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import '../model/auth/auth_request.dart';
import '../util/routes.dart';
import '../viewmodels/auth_provider.dart';
import '../component/error_snackbar.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthProvider _auth;

  bool isLogin = true;
  bool isPasswordVisible = false;
  bool agreeToTerms = false;
  bool isLoading = false;

  AuthViewModel(this._auth);

  void switchMode(bool login) {
    isLogin = login;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleAgree() {
    agreeToTerms = !agreeToTerms;
    notifyListeners();
  }

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      await _auth.login(AuthRequest(email: email, password: password));
      AppMetrica.reportEvent('App_opened_logged_in');
      switch (_auth.role) {
        case 'CLIENT':
          Navigator.pushReplacementNamed(context, Routes.projects);
          break;
        case 'FREELANCER':
          Navigator.pushReplacementNamed(context, Routes.projectsFree);
          break;
        default:
          ErrorSnackbar.show(
            context,
            type: ErrorType.error,
            title: 'Ваша роль не поддерживается',
            message: 'Обратитесь в поддержку.',
          );
      }
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка входа',
        message: e.toString(),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void register({
    required BuildContext context,
    required Map<String, String> data,
  }) {
    if (!agreeToTerms) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Внимание',
        message: 'Надо принять условия и политику',
      );
      return;
    }
    Navigator.pushNamed(context, Routes.role, arguments: data);
  }

  void requestPasswordReset({
    required BuildContext context,
    required String email,
  }) {
    _auth
        .requestPasswordReset(email)
        .then((_) {
          Navigator.pushReplacementNamed(
            context,
            Routes.verify,
            arguments: {'email': email, 'action': 'PASSWORD_RESET'},
          );
        })
        .catchError((e) {
          ErrorSnackbar.show(
            context,
            type: ErrorType.error,
            title: 'Ошибка',
            message: e.toString(),
          );
        });
  }
}
