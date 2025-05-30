import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../../component/error_snackbar.dart';
import '../../../util/palette.dart';
import '../../../util/routes.dart';
import '../../../viewmodels/reset_password_viewmodel.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  bool _newObscure = true;
  bool _confirmObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _newPwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  String? _validatePwd(String? v) {
    if (v == null || v.length < 8) {
      return 'Минимум 8 символов';
    }
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v != _newPwdController.text) {
      return 'Пароли не совпадают';
    }
    return null;
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final email = args['email']!;
    final code = args['resetCode']!;
    final newPass = _newPwdController.text.trim();

    final vm = context.read<ResetPasswordViewModel>();
    await vm.resetPassword(email: email, resetCode: code, newPassword: newPass);

    if (vm.errorMessage != null) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: vm.errorMessage!,
      );
    } else {
      ErrorSnackbar.show(
        context,
        type: ErrorType.success,
        title: 'Успех',
        message: 'Пароль успешно изменён',
      );
      Navigator.pushReplacementNamed(context, Routes.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ResetPasswordViewModel>();
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(title: ''),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            SvgPicture.asset('assets/logo.svg', height: 40),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _newPwdController,
                      obscureText: _newObscure,
                      validator: _validatePwd,
                      decoration: InputDecoration(
                        hintText: 'Новый пароль',
                        suffixIcon: IconButton(
                          icon: SvgPicture.asset(
                            _newObscure
                                ? 'assets/icons/EyeInvisible.svg'
                                : 'assets/icons/EyeVisible.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Palette.secondaryIcon,
                              BlendMode.srcIn,
                            ),
                          ),
                          onPressed:
                              () => setState(() => _newObscure = !_newObscure),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Palette.grey3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Palette.grey3,
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Palette.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Palette.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPwdController,
                      obscureText: _confirmObscure,
                      validator: _validateConfirm,
                      decoration: InputDecoration(
                        hintText: 'Повторите пароль',
                        suffixIcon: IconButton(
                          icon: SvgPicture.asset(
                            _confirmObscure
                                ? 'assets/icons/EyeInvisible.svg'
                                : 'assets/icons/EyeVisible.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Palette.secondaryIcon,
                              BlendMode.srcIn,
                            ),
                          ),
                          onPressed:
                              () => setState(
                                () => _confirmObscure = !_confirmObscure,
                              ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Palette.grey3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Palette.grey3,
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Palette.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Palette.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: vm.isLoading ? null : _onSubmit,
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
                            'Сохранить',
                            style: TextStyle(
                              color: Palette.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
