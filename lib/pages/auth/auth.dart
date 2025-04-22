import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:jobsy/provider/auth_provider.dart';
import 'package:jobsy/model/auth_request.dart';
import '../../component/auth_switch_text.dart';
import '../../util/validators.dart';
import '../../component/custom_text_field.dart';
import '../../component/primary_button.dart';

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

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final birthDateController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              SvgPicture.asset('assets/logo.svg', height: 50),
              const SizedBox(height: 30),
              _buildSwitcher(),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: isLogin ? _buildLoginForm() : _buildRegisterForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitcher() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEEF4),
        borderRadius: BorderRadius.circular(32),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
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
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKeyLogin,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          CustomTextField(
            label: "Почта",
            controller: emailController,
            validator: validateEmail,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: "Пароль",
            controller: passwordController,
            obscureText: !isPasswordVisible,
            icon: isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            onIconPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
            validator: validatePassword,
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
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Войти',
            onPressed: () async {
              if (_formKeyLogin.currentState!.validate()) {
                try {
                  final authProvider = Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  );

                  await authProvider.login(
                    AuthRequest(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    ),
                  );

                  final token = authProvider.token;
                  final user = authProvider.user;

                  print("Токен: $token");
                  print("Пользователь: ${user?.email}");

                  Navigator.pushReplacementNamed(context, '/projects');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Ошибка входа: $e")),
                  );
                }
              }
            },
          ),
          AuthSwitchText(
            text: "Нет аккаунта? Зарегистрироваться",
            onTap: () => setState(() => isLogin = false),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _formKeyRegister,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: "Имя",
                  controller: firstNameController,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Введите имя' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextField(
                  label: "Фамилия",
                  controller: lastNameController,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Введите фамилию' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: "Почта",
            controller: emailController,
            validator: validateEmail,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: "Номер телефона",
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: validatePhone,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: "Дата рождения",
            controller: birthDateController,
            icon: Icons.calendar_today_outlined,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: "Пароль",
            controller: passwordController,
            obscureText: !isPasswordVisible,
            icon: isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            onIconPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
            validator: validatePassword,
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
                  text: const TextSpan(
                    text: 'Я прочитал и согласен с ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Положениями и условиями',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' и '),
                      TextSpan(
                        text: 'Политикой конфиденциальности',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Зарегистрироваться',
            onPressed: () {
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
                final registrationData = {
                  "firstName": firstNameController.text.trim(),
                  "lastName": lastNameController.text.trim(),
                  "email": emailController.text.trim(),
                  "password": passwordController.text.trim(),
                  "phone": phoneController.text.trim(),
                  "dateBirth": birthDateController.text.trim(),
                };

                Navigator.pushNamed(context, '/role', arguments: registrationData);
              }
            },
          ),
          AuthSwitchText(
            text: "Уже есть аккаунт? Войти",
            onTap: () => setState(() => isLogin = true),
          ),
        ],
      ),
    );
  }
}
