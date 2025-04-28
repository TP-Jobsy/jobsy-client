import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../service/i_api_service.dart';
import '../../service/mock_api_service.dart' as mock;
import '../../service/api_service.dart' as real;
import '../../config/config.dart';
import '../../util/pallete.dart';
import '../../util/routes.dart';


class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({super.key});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  bool isLoading = false;

  void _onSubmit(String email) async {
    final code = _controllers.map((c) => c.text.trim()).join();

    if (code.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Введите 4-значный код"),
          backgroundColor: Palette.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final IApiService api = useMock ? mock.MockApiService() : real.ApiService();
      await api.confirmEmail(email, code);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Почта успешно подтверждена")),
      );
      Navigator.pushNamed(context, Routes.auth);
      // Navigator.pushReplacementNamed(context, '/auth');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ошибка подтверждения: $e"),
          backgroundColor: Palette.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildCodeField(int index) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Palette.dotActive),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _controllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 30),
              SvgPicture.asset('assets/logo.svg', height: 50),
              const SizedBox(height: 32),
              const Text(
                'Введите код подтверждения',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Код отправлен на $email',
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) => _buildCodeField(i))
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  // TODO: реализовать повторную отправку кода
                },
                child: const Text(
                  'Отправить еще раз код',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => _onSubmit(email),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2842F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                          : const Text(
                            'Продолжить',
                            style: TextStyle(color: Colors.white),
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
