import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../service/api_service.dart';
import '../../util/pallete.dart';
import '../../util/routes.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final _controllers = List.generate(4, (_) => TextEditingController());
  bool _isLoading = false;
  bool _isResending = false;

  Future<void> _onSubmit(String email) async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Введите 4-значный код"), backgroundColor: Palette.red),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final ApiService api = ApiService();
      await api.confirmEmail(email, code);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Почта успешно подтверждена")),
      );
      Navigator.pushReplacementNamed(context, Routes.auth);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка подтверждения: $e"), backgroundColor: Palette.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onResend(String email) async {
    setState(() {
      _isResending = true;
    });
    try {
      final ApiService api = ApiService();
      await api.resendConfirmation(email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Код выслан повторно")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Не удалось отправить: $e"), backgroundColor: Palette.red),
      );
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  Widget _buildCodeField(int i) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Palette.dotActive),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _controllers[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        decoration: const InputDecoration(counterText: '', border: InputBorder.none),
        onChanged: (v) {
          if (v.isNotEmpty && i < 3) FocusScope.of(context).nextFocus();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Palette.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 30),
              SvgPicture.asset('assets/logo.svg', height: 50),
              const SizedBox(height: 32),
              const Text('Введите код подтверждения', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Код отправлен на $email', style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 32),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(4, _buildCodeField)),
              const SizedBox(height: 24),

              _isResending
                  ? const CircularProgressIndicator()
                  : TextButton(
                onPressed: () => _onResend(email),
                child: const Text('Отправить ещё раз код'),
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _onSubmit(email),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2842F7),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white))
                      : const Text('Продолжить', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
