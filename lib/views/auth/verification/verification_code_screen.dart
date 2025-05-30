import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../component/error_snackbar.dart';
import '../../../util/palette.dart';
import '../../../util/routes.dart';
import '../../../viewmodels/verification_code_viewmodel.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final _controllers = List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _buildCodeField(int idx) {
    return Container(
      width: 60,
      height: 90,
      margin: EdgeInsets.only(left: idx == 0 ? 0 : 12),
      child: TextField(
        controller: _controllers[idx],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Palette.grey3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Palette.primary, width: 2),
          ),
        ),
        onChanged: (v) {
          if (v.isNotEmpty && idx < 3) FocusScope.of(context).nextFocus();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VerificationCodeViewModel>();
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
                style: const TextStyle(
                  color: Palette.thin,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, _buildCodeField),
              ),
              const SizedBox(height: 16),
              vm.isResending
                  ? const CircularProgressIndicator()
                  : TextButton(
                    onPressed: () async {
                      final ok = await vm.resendCode(
                        email: email,
                        action: action,
                      );
                      if (ok) {
                        ErrorSnackbar.show(
                          context,
                          type: ErrorType.info,
                          title: 'Отправлено',
                          message: 'Код отправлен повторно на $email',
                        );
                      } else {
                        ErrorSnackbar.show(
                          context,
                          type: ErrorType.error,
                          title: 'Ошибка',
                          message: vm.errorMessage!,
                        );
                      }
                    },
                    child: const Text(
                      'Отправить код повторно',
                      style: TextStyle(
                        color: Palette.dotActive,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      vm.isLoading
                          ? null
                          : () async {
                            final code =
                                _controllers.map((c) => c.text.trim()).join();
                            if (code.length != 4) {
                              ErrorSnackbar.show(
                                context,
                                type: ErrorType.warning,
                                title: 'Внимание',
                                message: 'Введите 4х-значный код',
                              );
                              return;
                            }
                            final ok = await vm.confirmCode(
                              email: email,
                              action: action,
                              code: code,
                            );
                            if (!ok) {
                              ErrorSnackbar.show(
                                context,
                                type: ErrorType.error,
                                title: 'Ошибка',
                                message: vm.errorMessage!,
                              );
                              return;
                            }
                            if (action == 'REGISTRATION') {
                              ErrorSnackbar.show(
                                context,
                                type: ErrorType.success,
                                title: 'Готово',
                                message: 'E-mail успешно подтверждён',
                              );
                              await Future.delayed(
                                const Duration(milliseconds: 500),
                              );
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                Routes.auth,
                                (_) => false,
                              );
                            } else {
                              Navigator.of(context).pushNamed(
                                Routes.resetPassword,
                                arguments: {'email': email, 'resetCode': code},
                              );
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child:
                      vm.isLoading
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
