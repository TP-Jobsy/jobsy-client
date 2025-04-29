import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../component/error_snackbar.dart';
import '../../model/auth_request.dart';
import '../../provider/auth_provider.dart';
import '../../util/pallete.dart';
import '../../util/routes.dart';
import '../../util/validators.dart';

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

  final phoneFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'\d')},
  );

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
                final email = emailController.text.trim();
                final validationError = Validators.validateEmail(email);
                if (email.isEmpty || validationError != null) {
                  ErrorSnackbar.show(
                    context,
                    type: ErrorType.warning,
                    title: 'Внимание',
                    message: 'Введите корректный e-mail для восстановления',
                  );
                  return;
                }
                Provider.of<AuthProvider>(context, listen: false)
                    .requestPasswordReset(email)
                    .then((_) {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.verify,
                    arguments: {'email': email, 'action': 'PASSWORD_RESET'},
                  );
                }).catchError((e) {
                  ErrorSnackbar.show(
                    context,
                    type: ErrorType.error,
                    title: 'Ошибка',
                    message: 'Ошибка запроса кода: $e',
                  );
                });
              },
              child: const Text('Забыли пароль?', style: TextStyle(color: Palette.dotActive, fontFamily: 'Inter')),
            ),
          ),
          const SizedBox(height: 24),
          _buildActionButton('Войти', _login),
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
                  validator: Validators.validateRequired,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  label: "Фамилия",
                  controller: lastNameController,
                  validator: Validators.validateRequired,
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
            inputFormatters: [phoneFormatter],
            validator: Validators.validatePhone,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: "Дата рождения",
            controller: birthDateController,
            keyboardType: TextInputType.datetime,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'\d+|\.')),
              LengthLimitingTextInputFormatter(10),
            ],
            icon: Icons.calendar_today_outlined,
            onIconPressed: _selectBirthDate,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Заполните поле';
              final regex = RegExp(r'^\d{2}\.\d{2}\.\d{4}$');
              if (!regex.hasMatch(value)) return 'Введите в формате дд.мм.гггг';
              return null;
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
                        style: TextStyle(color: Palette.dotActive, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' и '),
                      TextSpan(
                        text: 'Политикой конфиденциальности',
                        style: TextStyle(color: Palette.dotActive, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildActionButton('Зарегистрироваться', _register),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (_formKeyLogin.currentState!.validate()) {
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.login(
          AuthRequest(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          ),
        );
        final user = authProvider.user;
        if (user?.role == 'CLIENT') {
          Navigator.pushReplacementNamed(context, Routes.projects);
        } else if (user?.role == 'FREELANCER') {
          Navigator.pushReplacementNamed(context, Routes.projectsFree);
        } else {
          ErrorSnackbar.show(
            context,
            type: ErrorType.error,
            title: 'Ваша роль не поддерживается',
            message: 'Обратитесь в поддержку.',
          );
        }
      } catch (e) {
        ErrorSnackbar.show(
          context,
          type: ErrorType.error,
          title: 'Ошибка входа',
          message: e.toString(),
        );
      }
    }
  }

  Future<void> _register() async {
    if (!agreeToTerms) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Внимание',
        message: 'Надо принять условия и политику',
      );
      return;
    }

    if (_formKeyRegister.currentState!.validate()) {
      final registrationData = {
        "firstName": firstNameController.text.trim(),
        "lastName": lastNameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "phone": phoneFormatter.getUnmaskedText(),
        "dateBirth": birthDateController.text.trim(),
      };

      Navigator.pushNamed(
        context,
        Routes.verify,
        arguments: {
          'email': registrationData['email'],
          'action': 'REGISTRATION',
        },
      );
    }
  }

  Future<void> _selectBirthDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('ru', 'RU'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Palette.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}."
          "${pickedDate.month.toString().padLeft(2, '0')}."
          "${pickedDate.year}";
      setState(() {
        birthDateController.text = formattedDate;
      });
    }
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
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: icon != null
            ? IconButton(
          icon: Icon(icon),
          onPressed: onIconPressed ?? onTap,
        )
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Palette.white, fontFamily: 'Inter'),
        ),
      ),
    );
  }
}
