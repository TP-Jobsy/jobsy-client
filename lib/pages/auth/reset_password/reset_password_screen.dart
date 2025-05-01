import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../component/error_snackbar.dart';
import '../../../provider/auth_provider.dart';
import '../../../util/palette.dart';
import '../../../util/routes.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

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

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final email = args['email']!;
    final resetCode = args['resetCode']!;
    final newPass = _newPwdController.text.trim();
    setState(() => _isLoading = true);
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .resetPassword(email, resetCode, newPass);

      ErrorSnackbar.show(
        context,
        type: ErrorType.success,
        title: 'Успех',
        message: 'Пароль успешно изменён',
      );

      Navigator.pushReplacementNamed(context, Routes.auth);
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: e.toString(),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        backgroundColor: Palette.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Palette.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              SvgPicture.asset('assets/logo.svg', height: 40),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: SvgPicture.asset(
                    'assets/DrawKit Vector Illustration Team Work (3).svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _newPwdController,
                      obscureText: _newObscure,
                      validator: _validatePwd,
                      decoration: InputDecoration(
                        hintText: 'Новый пароль',
                        suffixIcon: IconButton(
                          icon: SvgPicture.asset(
                            _newObscure
                                ? 'assets/icons/Eye Invisible.svg'
                                : 'assets/icons/Eye Visible.svg',
                            width: 24,
                            height: 24,
                          ),
                          onPressed:
                              () => setState(() => _newObscure = !_newObscure),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
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
                                ? 'assets/icons/Eye Invisible.svg'
                                : 'assets/icons/Eye Visible.svg',
                            width: 24,
                            height: 24,
                          ),
                          onPressed:
                              () => setState(
                                () => _confirmObscure = !_confirmObscure,
                              ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _save,
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
                                    Colors.white,
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
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
