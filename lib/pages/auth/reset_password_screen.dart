import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/pallete.dart';

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

  @override
  void dispose() {
    _newPwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  void _toggleNew() {
    setState(() => _newObscure = !_newObscure);
  }

  void _toggleConfirm() {
    setState(() => _confirmObscure = !_confirmObscure);
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: вызвать API для сохранения пароля
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Пароль изменён успешно')));
      Navigator.pop(context);
    }
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
              // Логотип
              SvgPicture.asset('assets/logo.svg', height: 40),
              const SizedBox(height: 24),
              // Иллюстрация
              Expanded(
                child: Center(
                  child: SvgPicture.asset(
                    'assets/DrawKit Vector Illustration Team Work (3).svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Форма
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Нов. пароль
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
                          onPressed: _toggleNew,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Повторить пароль
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
                          onPressed: _toggleConfirm,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Кнопка Сохранить
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
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
