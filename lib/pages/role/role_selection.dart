import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

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
      backgroundColor: Colors.white,
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Выберите, кем вы хотите быть на нашей платформе',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
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
                      final authProvider = Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      );

                      registrationData['role'] = selectedRole;

                      final result = await authProvider.register(registrationData);

                      if (result['success'] == true || result['message'] != null) {
                        Navigator.pushNamed(
                          context,
                          '/verify',
                          arguments: registrationData['email'],
                        );
                      } else {
                        throw Exception(result["error"] ?? 'Неизвестная ошибка');
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Ошибка регистрации: $e"),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    } finally {
                      setState(() => isLoading = false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2842F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : const Text(
                    'Продолжить',
                    style: TextStyle(color: Colors.white),
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
            color: selected ? const Color(0xFF2842F7) : const Color(0xFF8F9098),
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
              activeColor: const Color(0xFF2842F7),
            ),
          ],
        ),
      ),
    );
  }
}
