import 'package:flutter/material.dart';

import '../../../util/palette.dart';
import '../../../util/routes.dart';



class ProfileScreenFree extends StatelessWidget {
  const ProfileScreenFree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Профиль',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Palette.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage('assets/avatar.jpg'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Анастасия Иванова',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Веб-дизайнер',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),

            _buildSection(context, 'Основные данные', Routes.basicDataFree),
            _buildSection(context, 'О себе', Routes.activityFieldFree),
            _buildSection(context, 'Контактные данные', Routes.contactInfoFree),
            _buildSection(context, 'Портфолио', Routes.portfolio),
            _buildSection(context, 'Удалить аккаунт', null, isDestructive: true),

            const SizedBox(height: 1),

            // Кнопка выхода
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutConfirmation(context),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Выйти из аккаунта',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Palette.grey3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String? route,
      {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Palette.grey3),
        color: Colors.white,
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.black : Colors.black,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (route != null) {
            Navigator.of(context).pushNamed(route);
          } else {
            _showDeleteConfirmation(context);
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить аккаунт'),
        content: const Text('Вы уверены, что хотите удалить аккаунт? Это действие необратимо.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Здесь можно добавить реальную логику удаления аккаунта
            },
            child: const Text(
              'Удалить',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Выход из аккаунта'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Здесь можно добавить реальную логику выхода
              // Например: очистить токен и перенаправить на экран авторизации
            },
            child: const Text(
              'Выйти',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
