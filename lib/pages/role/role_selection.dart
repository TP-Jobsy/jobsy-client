import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsy/util/pallete.dart';
import 'package:provider/provider.dart';
import '../../component/error_snackbar.dart';
import '../../provider/auth_provider.dart';
import '../../util/routes.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final registrationData =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: Palette.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 30),
              SvgPicture.asset('assets/logo.svg', height: 50),
              const SizedBox(height: 20),
              const Text(
                'Рады видеть вас!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Выберите, кем вы хотите быть на нашей платформе',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Palette.thin, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 32),

              _buildRoleCard(
                label: 'Я клиент, нанимаю сотрудников для проекта',
                value: 'CLIENT',
              ),
              const SizedBox(height: 20),
              _buildRoleCard(
                label: 'Я фрилансер, ищу работу',
                value: 'FREELANCER',
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: selectedRole == null || isLoading
                      ? null
                      : () async {
                    setState(() => isLoading = true);
                    try {
                      final auth = Provider.of<AuthProvider>(context, listen: false);
                      registrationData['role'] = selectedRole;
                      await auth.register(registrationData);
                      Navigator.pushNamed(
                        context,
                        Routes.verify,
                        arguments: {
                          'email': registrationData['email'],
                          'action': 'REGISTRATION',
                        },
                      );
                    } catch (e) {
                      ErrorSnackbar.show (
                        context,
                        type: ErrorType.error,
                        title: 'Ошибка регистрации',
                        message: e.toString().replaceFirst('Exception: ', ''),
                      );
                    } finally {
                      setState(() => isLoading = false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Palette.white),
                  )
                      : const Text(
                    'Продолжить',
                    style: TextStyle(color: Palette.white, fontFamily: 'Inter'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({required String label, required String value}) {
    final selected = selectedRole == value;
    return GestureDetector(
      onTap: () => setState(() => selectedRole = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Palette.primary : Palette.grey3,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            Checkbox(
              value: selected,
              onChanged: (_) => setState(() => selectedRole = value),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              activeColor: Palette.primary
            ),
          ],
        ),
      ),
    );
  }
}
