import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../component/error_snackbar.dart';
import '../../model/auth_request.dart';
import '../../provider/auth_provider.dart';
import '../../util/palette.dart';
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 39),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  SvgPicture.asset('assets/logo.svg', height: 50),
                  const SizedBox(height: 30),
                  _buildSwitcher(),
                  const SizedBox(height: 30),
                  Expanded(
                    child: SingleChildScrollView(
                      child: isLogin ? _buildLoginForm() : _buildRegisterForm(),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 39,
              right: 39,
              child: _buildActionButton(
                isLogin ? 'Войти' : 'Зарегистрироваться',
                isLogin ? _login : _register,
              ),
            ),
          ],
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
        duration: const Duration(milliseconds: 2),
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
            svgSuffixIcon: SvgPicture.asset(
              'assets/icons/Inbox.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Palette.secondaryIcon,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Пароль",
            controller: passwordController,
            validator: Validators.validatePassword,
            obscureText: !isPasswordVisible,
            svgSuffixIcon: SvgPicture.asset(
              isPasswordVisible
                  ? 'assets/icons/EyeVisible.svg'
                  : 'assets/icons/EyeInvisible.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Palette.secondaryIcon,
                BlendMode.srcIn,
              ),
            ),
            onTapSuffix:
                () => setState(() => isPasswordVisible = !isPasswordVisible),
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
                    })
                    .catchError((e) {
                      ErrorSnackbar.show(
                        context,
                        type: ErrorType.error,
                        title: 'Ошибка',
                        message: 'Ошибка запроса кода: $e',
                      );
                    });
              },
              child: const Text(
                'Забыли пароль?',
                style: TextStyle(color: Palette.dotActive, fontFamily: 'Inter'),
              ),
            ),
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
          const SizedBox(height: 12),
          _buildTextField(
            label: "Почта",
            controller: emailController,
            validator: Validators.validateEmail,
            svgSuffixIcon: SvgPicture.asset(
              'assets/icons/Inbox.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Palette.secondaryIcon,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Номер телефона",
            controller: phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [phoneFormatter],
            validator: Validators.validatePhone,
            svgSuffixIcon: SvgPicture.asset(
              'assets/icons/solar_phone-bold.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Palette.secondaryIcon,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Дата рождения",
            controller: birthDateController,
            keyboardType: TextInputType.datetime,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'\d+|\.')),
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (v) {
              if (v == null || v.isEmpty) return 'Заполните поле';
              if (!RegExp(r'^\d{2}\.\d{2}\.\d{4}$').hasMatch(v)) {
                return 'дд.мм.гггг';
              }
              return null;
            },
            svgSuffixIcon: SvgPicture.asset(
              'assets/icons/calendar.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Palette.secondaryIcon,
                BlendMode.srcIn,
              ),
            ),
            onTapSuffix: _selectBirthDate,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: "Пароль",
            controller: passwordController,
            validator: Validators.validatePassword,
            obscureText: !isPasswordVisible,
            svgSuffixIcon: SvgPicture.asset(
              isPasswordVisible
                  ? 'assets/icons/EyeVisible.svg'
                  : 'assets/icons/EyeInvisible.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Palette.secondaryIcon,
                BlendMode.srcIn,
              ),
            ),
            onTapSuffix:
                () => setState(() => isPasswordVisible = !isPasswordVisible),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => setState(() => agreeToTerms = !agreeToTerms),
                child: SvgPicture.asset(
                  agreeToTerms
                      ? 'assets/icons/checkTrue.svg'
                      : 'assets/icons/checkFalse.svg',
                  width: 20,
                  height: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    text: 'Я прочитал и согласен с ',
                    style: TextStyle(
                      color: Palette.grey2,
                      fontFamily: 'Inter',
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: 'Положениями и условиями',
                        style: TextStyle(
                          color: Palette.dotActive,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'Inter'
                        ),
                      ),
                      TextSpan(text: ' и '),
                      TextSpan(
                        text: 'Политикой конфиденциальности',
                        style: TextStyle(
                          color: Palette.dotActive,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'Inter'
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (_formKeyLogin.currentState!.validate()) {
      try {
        final authProvider = context.read<AuthProvider>();
        await authProvider.login(
          AuthRequest(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          ),
        );
        if (authProvider.role == 'CLIENT') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.projects,
            (route) => false,
          );
        } else if (authProvider.role == 'FREELANCER') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.projectsFree,
            (route) => false,
          );
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
      final rawPhone = phoneFormatter.getUnmaskedText();
      final phoneToSend = '7$rawPhone';
      final registrationData = {
        "firstName": firstNameController.text.trim(),
        "lastName": lastNameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "phone": phoneToSend,
        "dateBirth": birthDateController.text.trim(),
      };

      Navigator.pushNamed(context, Routes.role, arguments: registrationData);
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
            dialogBackgroundColor: Palette.white,
            colorScheme: const ColorScheme.light(
              primary: Palette.primary,
              onPrimary: Palette.white,
              onSurface: Palette.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final formattedDate =
          "${pickedDate.day.toString().padLeft(2, '0')}."
          "${pickedDate.month.toString().padLeft(2, '0')}."
          "${pickedDate.year}";
      setState(() {
        birthDateController.text = formattedDate;
      });
    }
  }

  Widget _buildTextField({
    required String label,
    Widget? svgSuffixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onTapSuffix,
    TextEditingController? controller,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        helperText: ' ',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Palette.grey3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Palette.grey3, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Palette.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Palette.red, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon:
            svgSuffixIcon != null
                ? GestureDetector(
                  onTap: onTapSuffix,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: svgSuffixIcon,
                    ),
                  ),
                )
                : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 20,
          minHeight: 20,
        ),
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
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Palette.white, fontFamily: 'Inter'),
        ),
      ),
    );
  }
}
