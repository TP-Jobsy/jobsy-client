import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../component/error_snackbar.dart';
import '../../../provider/auth_provider.dart';
import '../../../util/pallete.dart';
import '../../../util/routes.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final _controllers = List.generate(4, (_) => TextEditingController());
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _onSubmit(String email, String action) async {
    final code = _controllers.map((c) => c.text.trim()).join();
    if (code.length != 4) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.warning,
        title: 'Внимание',
        message: 'Введите 4-значный код',
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (action == 'REGISTRATION') {
        await Provider.of<AuthProvider>(
          context,
          listen: false,
        ).confirmEmail(email, code, action: action);

        ErrorSnackbar.show(
          context,
          type: ErrorType.success,
          title: 'Успех',
          message: 'E-mail успешно подтверждён',
        );
        Navigator.pushReplacementNamed(context, Routes.auth);
      } else {
        Navigator.pushReplacementNamed(
          context,
          Routes.resetPassword,
          arguments: {'email': email, 'resetCode': code},
        );
      }
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onResend(String email, String action) async {
    setState(() => _isResending = true);
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (action == 'REGISTRATION') {
        await auth.resendConfirmation(email);
      } else {
        await auth.requestPasswordReset(email);
      }
      ErrorSnackbar.show(
        context,
        type: ErrorType.info,
        title: 'Отправлено',
        message: 'Код отправлен повторно на $email',
      );
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      setState(() => _isResending = false);
    }
  }

  Widget _buildCodeField(int idx) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Palette.dotActive),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _controllers[idx],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (v) {
          if (v.isNotEmpty && idx < 3) FocusScope.of(context).nextFocus();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final email = rawArgs['email']?.toString() ?? '';
    final action = rawArgs['action']?.toString() ?? '';

    return Scaffold(
      backgroundColor: Palette.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 30),
              SvgPicture.asset('assets/logo.svg', height: 50),
              const SizedBox(height: 32),
              const Text(
                'Введите код подтверждения',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Код отправлен на $email',
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, _buildCodeField),
              ),
              const SizedBox(height: 16),
              _isResending
                  ? const CircularProgressIndicator()
                  : TextButton(
                    onPressed: () => _onResend(email, action),
                    child: const Text(
                      'Отправить ещё раз код',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _onSubmit(email, action),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Palette.white,
                            ),
                          )
                          : const Text(
                            'Продолжить',
                            style: TextStyle(
                              color: Palette.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
