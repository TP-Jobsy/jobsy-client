import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/pallete.dart';
import '../../util/routes.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final emailController = TextEditingController();
  bool showError = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _recoverPassword() {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => showError = true);
    } else {
      //TODO: реальная логика восстановления
      Navigator.pushReplacementNamed(context, Routes.verify);
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
          // по макету слева/справа — 24, сверху — 16
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              SvgPicture.asset('assets/logo.svg', height: 40),
              const SizedBox(height: 24),

              // вот тут заменили png на ваш SVG-иллюстрацию
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
              // Блок ошибки
              if (showError)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Palette.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Palette.red,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Неверная почта',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Пользователь с такой почтой не найден',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Inter',
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => showError = false),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black45,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Поле ввода с иконкой справа
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Почта',
                  // убрали prefixIcon, добавили в suffixIcon
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
                  onPressed: _recoverPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Продолжить',
                    style: TextStyle(color: Palette.white, fontFamily: 'Inter'),
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
