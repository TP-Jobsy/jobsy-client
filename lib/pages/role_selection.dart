import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole; // "client" или "freelancer"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 19),
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

              // Вариант 1: Клиент
              _buildRoleCard(
                label: 'Я клиент, нанимаю сотрудников для проекта',
                value: 'client',
              ),

              const SizedBox(height: 16),

              // Вариант 2: Фрилансер
              _buildRoleCard(
                label: 'Я фрилансер, ищу работу',
                value: 'freelancer',
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: selectedRole == null
                      ? null
                      : () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:   const Color(0xFF2842F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Продолжить',
                    style: TextStyle(color: Colors.white), // ✅ белый текст
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: selected ? Color(0xFF2842F7) : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            Checkbox(
              value: selected,
              onChanged: (_) => setState(() => selectedRole = value),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              activeColor: Color(0xFF2842F7),
            ),
          ],
        ),
      ),
    );
  }
}
