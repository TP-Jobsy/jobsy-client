import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../util/palette.dart';

class ConfirmScreen extends StatefulWidget {
  final String email;
  const ConfirmScreen({super.key, required this.email});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  final List<TextEditingController> _codeCtrls =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 4; i++) {
      _codeCtrls[i].addListener(() {
        if (_codeCtrls[i].text.length == 1 && i < 3) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var c in _codeCtrls) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Widget _buildDigitField(int index) {
    return SizedBox(
      width: 75,
      height: 75,
      child: TextField(
        controller: _codeCtrls[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Palette.grey3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Palette.primary, width: 2),
          ),
        ),
      ),
    );
  }

  void _goToUsers() {
    Navigator.of(context).pushReplacementNamed('/admin/users');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          final maxWidth = constraints.maxWidth > 600 ? 600.0 : constraints.maxWidth;
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/logo.svg',
                            height: 130,
                            width: 234,
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Введите код подтверждения',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'На ваш адрес ${widget.email} отправлен 4-значный код',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Palette.grey1,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (i) {
                              return Padding(
                                padding: EdgeInsets.only(left: i == 0 ? 0 : 12),
                                child: _buildDigitField(i),
                              );
                            }),
                          ),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: () {
                              for (var c in _codeCtrls) {
                                c.clear();
                              }
                              _focusNodes[0].requestFocus();
                            },
                            child: const Text(
                              'Отправить ещё раз код',
                              style: TextStyle(
                                color: Palette.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: _goToUsers,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Palette.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text(
                                'Далее',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Palette.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}