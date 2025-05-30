import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../component/error_snackbar.dart';
import '../../util/palette.dart';
import '../../util/routes.dart';
import '../../util/validators.dart';
import '../../viewmodels/auth_viewmodel.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeyRegister = GlobalKey<FormState>();

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
  final birthDateFormatter = MaskTextInputFormatter(
    mask: '##.##.####',
    filter: {"#": RegExp(r'\d')},
  );

  @override
  void initState() {
    super.initState();
    AppMetrica.reportEvent('AuthScreen_opened');
  }

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
    final vm = context.watch<AuthViewModel>();
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;
    final isSmall = screenH < 700;

    return Scaffold(
      backgroundColor: Palette.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (ctx, cons) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenW < 360 ? 24 : 39,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: cons.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: isSmall ? 20 : 30),
                            SvgPicture.asset(
                              'assets/logo.svg',
                              height: isSmall ? 40 : 50,
                            ),
                            SizedBox(height: isSmall ? 20 : 30),
                            _buildSwitcher(vm),
                            SizedBox(height: isSmall ? 20 : 30),
                            Expanded(
                              child:
                                  vm.isLogin
                                      ? _buildLoginForm(vm)
                                      : _buildRegisterForm(vm),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenW < 360 ? 24 : 39,
                    vertical: 10,
                  ),
                  child: _buildActionButton(vm),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSwitcher(AuthViewModel vm) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Palette.dotInactive,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          _buildSwitchButton("Войти", true, vm),
          _buildSwitchButton("Регистрация", false, vm),
        ],
      ),
    );
  }

  Widget _buildSwitchButton(String label, bool login, AuthViewModel vm) {
    final selected = vm.isLogin == login;
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: selected ? Palette.white : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextButton(
          onPressed: () => vm.switchMode(login),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Palette.black : Palette.thin,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(AuthViewModel vm) {
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
            obscureText: !vm.isPasswordVisible,
            svgSuffixIcon: SvgPicture.asset(
              vm.isPasswordVisible
                  ? 'assets/icons/EyeVisible.svg'
                  : 'assets/icons/EyeInvisible.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Palette.secondaryIcon,
                BlendMode.srcIn,
              ),
            ),
            onTapSuffix: vm.togglePasswordVisibility,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                final email = emailController.text.trim();
                final err = Validators.validateEmail(email);
                if (email.isEmpty || err != null) {
                  ErrorSnackbar.show(
                    context,
                    type: ErrorType.warning,
                    title: 'Внимание',
                    message: 'Введите корректный e-mail',
                  );
                  return;
                }
                vm.requestPasswordReset(context: context, email: email);
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

  Widget _buildRegisterForm(AuthViewModel vm) {
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
            keyboardType: TextInputType.number,
            inputFormatters: [birthDateFormatter],
            validator: Validators.validateBirthDate,
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
            obscureText: !vm.isPasswordVisible,
            svgSuffixIcon: SvgPicture.asset(
              vm.isPasswordVisible
                  ? 'assets/icons/EyeVisible.svg'
                  : 'assets/icons/EyeInvisible.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Palette.secondaryIcon,
                BlendMode.srcIn,
              ),
            ),
            onTapSuffix: vm.togglePasswordVisibility,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: vm.toggleAgree,
                child: SvgPicture.asset(
                  vm.agreeToTerms
                      ? 'assets/icons/checkTrue.svg'
                      : 'assets/icons/checkFalse.svg',
                  width: 20,
                  height: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'Я согласен с ',
                    style: const TextStyle(
                      color: Palette.grey2,
                      fontFamily: 'Inter',
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Положениями и условиями и Политикой конфиденциальности',
                        style: const TextStyle(
                          color: Palette.dotActive,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, Routes.politic);
                              },
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

  Widget _buildActionButton(AuthViewModel vm) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed:
            vm.isLoading
                ? null
                : () {
                  if (vm.isLogin) {
                    if (_formKeyLogin.currentState!.validate()) {
                      vm.login(
                        context: context,
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                    }
                  } else {
                    if (_formKeyRegister.currentState!.validate()) {
                      final phoneRaw = phoneFormatter.getUnmaskedText();
                      final phoneToSend = '7$phoneRaw';
                      final data = {
                        'firstName': firstNameController.text.trim(),
                        'lastName': lastNameController.text.trim(),
                        'email': emailController.text.trim(),
                        'password': passwordController.text.trim(),
                        'phone': phoneToSend,
                        'dateBirth': birthDateController.text.trim(),
                      };
                      vm.register(context: context, data: data);
                    }
                  }
                },
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child:
            vm.isLoading
                ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Palette.white),
                )
                : Text(
                  vm.isLogin ? 'Войти' : 'Зарегистрироваться',
                  style: const TextStyle(
                    color: Palette.white,
                    fontFamily: 'Inter',
                  ),
                ),
      ),
    );
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('ru', 'RU'),
      builder:
          (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              dialogBackgroundColor: Palette.white,
              colorScheme: const ColorScheme.light(
                primary: Palette.primary,
                onPrimary: Palette.white,
                onSurface: Palette.black,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) {
      final fmt =
          '${picked.day.toString().padLeft(2, '0')}.'
          '${picked.month.toString().padLeft(2, '0')}.'
          '${picked.year}';
      birthDateController.text = fmt;
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
          borderSide: const BorderSide(color: Palette.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Palette.red, width: 1.5),
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
}
