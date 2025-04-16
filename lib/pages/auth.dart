import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeyRegister = GlobalKey<FormState>();

  bool isLogin = true;
  bool isPasswordVisible = false;
  bool agreeToTerms = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/logo.png', height: 50),
              const SizedBox(height: 30),
              _buildSwitcher(),
              const SizedBox(height: 24),
              isLogin ? _buildLoginForm() : _buildRegisterForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitcher() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildSwitchButton("Войти", true),
          _buildSwitchButton("Регистрация", false),
        ],
      ),
    );
  }

  Widget _buildSwitchButton(String label, bool login) {
    final selected = isLogin == login;
    return Expanded(
      child: TextButton(
        onPressed: () => setState(() => isLogin = login),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.black54,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Expanded(
      child: Form(
        key: _formKeyLogin,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            _buildTextField(
              label: "Почта",
              controller: emailController,
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: "Пароль",
              controller: passwordController,
              obscureText: !isPasswordVisible,
              icon: isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              onIconPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
              validator: _validatePassword,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Восстановление пока не реализовано")),
                  );
                },
                child: const Text('Забыли пароль?', style: TextStyle(color: Colors.blue)),
              ),
            ),
            const Spacer(),
            _buildActionButton('Войти', () {
              if (_formKeyLogin.currentState!.validate()) {
                Navigator.pushReplacementNamed(context, '/role');
              }
            }),
            _buildSwitchText("Нет аккаунта? Зарегистрироваться", false),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Expanded(
      child: Form(
        key: _formKeyRegister,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildTextField(label: "Имя")),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(label: "Фамилия")),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: "Почта",
              controller: emailController,
              icon: Icons.email_outlined,
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: "Номер телефона",
              controller: phoneController,
              keyboardType: TextInputType.phone,
              validator: _validatePhone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: "Дата рождения",
              icon: Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: "Пароль",
              controller: passwordController,
              obscureText: !isPasswordVisible,
              icon: isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              onIconPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
              validator: _validatePassword,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: agreeToTerms,
                  onChanged: (value) => setState(() => agreeToTerms = value ?? false),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'Я прочитал и согласен с ',
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Положениями и условиями',
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' и '),
                        TextSpan(
                          text: 'Политикой конфиденциальности',
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildActionButton('Зарегистрироваться', () {
              if (!agreeToTerms) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Надо принять условия и политику"),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              if (_formKeyRegister.currentState!.validate()) {
                Navigator.pushReplacementNamed(context, '/role');
              }
            }),
            _buildSwitchText("Уже есть аккаунт? Войти", true),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    IconData? icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onIconPressed,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: icon != null ? IconButton(icon: Icon(icon), onPressed: onIconPressed) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildSwitchText(String text, bool switchToLogin) {
    return TextButton(
      onPressed: () => setState(() => isLogin = switchToLogin),
      child: Text(text, style: const TextStyle(color: Colors.blue)),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Введите email';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) return 'Некорректный email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) return 'Минимум 6 символов';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Добавьте хотя бы одну цифру';
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) return 'Добавьте хотя бы одну букву';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Введите номер телефона';
    final phoneRegex = RegExp(r'^\+?[0-9\s\-]{10,15}$');
    if (!phoneRegex.hasMatch(value)) return 'Некорректный номер';
    return null;
  }
}
