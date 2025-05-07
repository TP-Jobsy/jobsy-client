import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../component/custom_bottom_nav_bar.dart';
import '../../util/palette.dart';
import '../../util/routes.dart';
import '../../provider/client_profile_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'delete_account_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _bottomNavIndex = 3; // Current bottom nav index

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ClientProfileProvider>();
    final profile = prov.profile;

    if (prov.loading && profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (profile == null) {
      return Scaffold(
        body: Center(
          child: Text(prov.error ?? 'Профиль не загружен'),
        ),
      );
    }

    final basic = profile.basic;
    final user = profile.user;

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: const Text(
          'Профиль',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        ),
        centerTitle: true,
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar of the user
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
            // User name (first name and last name)
            Text(
              '${user.firstName} ${user.lastName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 4),
            // User position
            Text(
              basic.position ?? '',
              style: const TextStyle(
                color: Palette.dotInactive,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 32),

            // Sections for profile editing
            _buildSection(context, 'Основные данные', Routes.basicData),
            _buildSection(context, 'Сфера деятельности', Routes.activityField),
            _buildSection(context, 'Контактные данные', Routes.contactInfo),
            _buildSection(context, 'Компания', Routes.companyInfo),
            _buildSection(context, 'Удалить аккаунт', null, isDestructive: true),

            const SizedBox(height: 1),

            // Logout button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutConfirmation(context),
                icon: SvgPicture.asset('assets/icons/logout.svg', color: Palette.red),
                label: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Выйти из аккаунта', style: TextStyle(color: Palette.red, fontSize: 16, fontFamily: 'Inter')),
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
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) => _handleNavigationTap(i, context),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String? route, {bool isDestructive = false}) {
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
            fontFamily: 'Inter',
          ),
        ),
        trailing: SvgPicture.asset('assets/icons/ArrowRight.svg', width: 12, height: 12, color: Palette.navbar),
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DeleteAccountConfirmationScreen(),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Palette.white,
        title: const Text('Выход из аккаунта'),
        content: const Text('Вы действительно хотите выйти?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена', style: TextStyle(color: Palette.black, fontFamily: 'Inter'))),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = context.read<ClientProfileProvider>();
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

  void _handleNavigationTap(int index, BuildContext context) async {
    if (index == _bottomNavIndex) return;

    if (index == 0) {
      setState(() => _bottomNavIndex = 0);
      await Navigator.pushNamed(context, Routes.projects);
    } else if (index == 1) {
      setState(() => _bottomNavIndex = 1);
      await Navigator.pushNamed(context, Routes.projects); // поменять на поиск фрилансеров
    } else if (index == 3) {
      await Navigator.pushNamed(context, Routes.profile);
      setState(() => _bottomNavIndex = 3);
    }else if (index == 2) {
      await Navigator.pushNamed(context, Routes.projects); // добавить избранное
      setState(() => _bottomNavIndex = 2);
    }
  }
}
