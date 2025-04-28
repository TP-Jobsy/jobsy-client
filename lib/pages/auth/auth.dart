import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsy/service/api_service.dart';
import 'package:jobsy/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/auth_request.dart';
import '../../util/pallete.dart';
import '../../util/validators.dart' as Validators;

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
      backgroundColor: Palette.white,
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
        color: Palette.dotInactive,
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
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: selected ? Palette.white : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextButton(
          onPressed: () => setState(() => isLogin = login),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Palette.black : Palette.thin,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
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
          _buildTextField(
            label: "Почта",
            controller: emailController,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: "Пароль",
            controller: passwordController,
            obscureText: !isPasswordVisible,
            icon: isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            onIconPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Восстановление пока не реализовано"),
                  ),
                );
              },
              child: const Text(
                'Забыли пароль?',
                style: TextStyle(color: Palette.dotActive, fontFamily: 'Inter'),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildActionButton('Войти', () async {
            if (_formKeyLogin.currentState!.validate()) {
              try {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);

                await authProvider.login(
                  AuthRequest(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  ),
                );

                final token = authProvider.token;
                final user = authProvider.user;

                if (user?.role == 'CLIENT') {
                  Navigator.pushReplacementNamed(context, '/projects');
                } else if (user?.role == 'FREELANCER') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Интерфейс фрилансера пока в разработке'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ваша роль не поддерживается'),
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Ошибка входа: $e")),
                );
              }
            }
          }),
          _buildSwitchText("Нет аккаунта? Зарегистрироваться", false),
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
                child: _buildTextField(
                  label: "Имя",
                  controller: firstNameController,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Введите имя' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  label: "Фамилия",
                  controller: lastNameController,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Введите фамилию' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: "Почта",
            controller: emailController,
            icon: Icons.email_outlined,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: "Номер телефона",
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: Validators.validatePhone,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: "Дата рождения",
            controller: birthDateController,
            icon: Icons.calendar_today_outlined,
            readOnly: true,
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                locale: const Locale('ru', 'RU'),
              );
              if (pickedDate != null) {
                final formattedDate = "${pickedDate.day.toString().padLeft(2, '0')} "
                    "${_getRussianMonth(pickedDate.month)} "
                    "${pickedDate.year}";
                setState(() {
                  birthDateController.text = formattedDate;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: "Пароль",
            controller: passwordController,
            obscureText: !isPasswordVisible,
            icon: isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            onIconPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
            validator: Validators.validatePassword,
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
                    style: TextStyle(color: Palette.black, fontFamily: 'Inter'),
                    children: [
                      TextSpan(
                        text: 'Положениями и условиями',
                        style: TextStyle(color: Palette.dotActive, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                      ),
                      TextSpan(text: ' и '),
                      TextSpan(
                        text: 'Политикой конфиденциальности',
                        style: TextStyle(color: Palette.dotActive, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildActionButton('Зарегистрироваться', () async {
            if (!agreeToTerms) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Надо принять условия и политику"),
                  backgroundColor: Palette.red,
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

              Navigator.pushNamed(
                context,
                '/role',
                arguments: registrationData,
              );
            }
          }),
          _buildSwitchText("Уже есть аккаунт? Войти", true),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    IconData? icon,
    bool obscureText = false,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onIconPressed,
    VoidCallback? onTap,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: icon != null
            ? IconButton(icon: Icon(icon), onPressed: onIconPressed)
            : null,
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
          backgroundColor: Palette.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(text, style: const TextStyle(color: Palette.white, fontFamily: 'Inter')),
      ),
    );
  }

  Widget _buildSwitchText(String text, bool switchToLogin) {
    return TextButton(
      onPressed: () => setState(() => isLogin = switchToLogin),
      child: Text(text, style: const TextStyle(color: Palette.dotActive, fontFamily: 'Inter')),
    );
  }

  String _getRussianMonth(int month) {
    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return months[month - 1];
  }
}
