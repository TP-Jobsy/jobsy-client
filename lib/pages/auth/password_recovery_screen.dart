import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../component/error_snackbar.dart';
import '../../service/api_service.dart';
import '../../util/pallete.dart';
import '../../util/routes.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _recoverPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Неверная почта',
        message: 'Введите корректный e-mail',
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      await ApiService().requestPasswordReset(email);
      Navigator.pushReplacementNamed(context, Routes.verify, arguments: email);
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: e.toString(),
      );
    } finally {
      setState(() => isLoading = false);
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              SvgPicture.asset('assets/logo.svg', height: 40),
              const SizedBox(height: 24),
              SvgPicture.asset('assets/onboarding4.svg', height: 200),
              const SizedBox(height: 24),
              const Text(
                'Восстановление пароля',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Введите вашу почту, чтобы получить\nкод для восстановления пароля',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Почта',
                  suffixIcon: const Icon(
                    Icons.mail_outline,
                    color: Colors.grey,
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
                  onPressed: isLoading ? null : _recoverPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
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
