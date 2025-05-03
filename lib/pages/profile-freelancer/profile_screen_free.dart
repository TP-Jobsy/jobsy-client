import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../util/palette.dart';
import '../../../util/routes.dart';
import '../../provider/freelancer_profile_provider.dart';
import '../../widgets/avatar.dart';



class ProfileScreenFree extends StatelessWidget {
  const ProfileScreenFree({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<FreelancerProfileProvider>();

    if (prov.loading && prov.profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final profile = prov.profile;
    if (profile == null) {
      return Scaffold(
        body: Center(child: Text(prov.error ?? 'Профиль не загружен')),
      );
    }

    final basic = profile.basic;
    final user = profile.user;

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: const Text('Профиль',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        ),
        centerTitle: true,
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.transparent,
              child: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                  ? ClipOval(
                child: Image.network(
                  profile.avatarUrl!,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return SvgPicture.asset(
                      'assets/icons/avatar.svg',
                      width: 90,
                      height: 90,
                    );
                  },
                  errorBuilder: (_, __, ___) => SvgPicture.asset(
                    'assets/icons/avatar.svg',
                    width: 90,
                    height: 90,
                  ),
                ),
              )
                  : SvgPicture.asset(
                'assets/icons/avatar.svg',
                width: 90,
                height: 90,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Анастасия Иванова',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Веб-дизайнер',
              style: TextStyle(
                color: Palette.thin,
                fontSize: 14,
                fontFamily: 'Inter',
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
                icon: const Icon(Icons.logout, color: Palette.red),
                label: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Выйти из аккаунта',
                    style: TextStyle(color: Palette.red, fontFamily: 'Inter'),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.white,
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
        color: Palette.white,
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Palette.black : Palette.black,
            fontFamily: 'Inter'
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
        backgroundColor: Palette.white,
        title: const Text('Удалить аккаунт'),
        content: const Text(
            'Вы уверены, что хотите удалить аккаунт? Это действие необратимо.'
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена', style: TextStyle(color: Palette.black, fontFamily: 'Inter'))),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = context.read<FreelancerProfileProvider>();
              await provider.deleteAccount();
              await provider.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.auth,
                    (route) => false,
              );
            },
            child: const Text('Удалить', style: TextStyle(color: Palette.red, fontFamily: 'Inter')),
          ),
        ],
      ),
    );
  }


  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Palette.white,
        title: const Text('Выход из аккаунта'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена', style: TextStyle(color: Palette.black, fontFamily: 'Inter'))),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = context.read<FreelancerProfileProvider>();
              await provider.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.auth,
                    (route) => false,
              );
            },
            child: const Text('Выйти', style: TextStyle(color: Palette.red, fontFamily: 'Inter')),
          ),
        ],
      ),
    );
  }
}
