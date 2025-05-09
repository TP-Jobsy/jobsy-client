import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../util/palette.dart';
import '../../../util/routes.dart';
import '../../component/custom_bottom_nav_bar.dart';
import '../../provider/freelancer_profile_provider.dart';
import 'delete_account_screen_free.dart';



class ProfileScreenFree extends StatefulWidget {
  const ProfileScreenFree({super.key});

  @override
  _ProfileScreenFreeState createState() => _ProfileScreenFreeState();
}

class _ProfileScreenFreeState extends State<ProfileScreenFree> {
  int _bottomNavIndex = 3;

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
        leading: const SizedBox(),
        title: const Text(
          'Профиль',
          style: TextStyle(fontSize: 20, fontFamily: 'Inter', fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
      ),
      body: _buildFavoritesContent(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) => _handleNavigationTap(i, context),
      ),
    );
  }

  Widget _buildFavoritesContent() {
    final prov = context.watch<FreelancerProfileProvider>();
    final profile = prov.profile;
    final basic = profile?.basic;
    final user = profile?.user;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.transparent,
            child: profile?.avatarUrl != null && profile!.avatarUrl!.isNotEmpty
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 4),
          const Text(
            'Веб-дизайнер',
            style: TextStyle(color: Palette.thin, fontSize: 14, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 32),
          _buildSection(context, 'Основные данные', Routes.basicDataFree),
          _buildSection(context, 'О себе', Routes.activityFieldFree),
          _buildSection(context, 'Контактные данные', Routes.contactInfoFree),
          _buildSection(context, 'Портфолио', Routes.portfolio),
          _buildSection(context, 'Удалить аккаунт', null, isDestructive: true),
          const SizedBox(height: 1),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutConfirmation(context),
              icon: SvgPicture.asset('assets/icons/logout.svg', color: Palette.red),
              label: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Выйти из аккаунта',
                  style: TextStyle(color: Palette.red, fontSize: 16, fontFamily: 'Inter'),
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
          style: TextStyle(color: isDestructive ? Palette.black : Palette.black,
              fontFamily: 'Inter'),
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
        builder: (context) => const DeleteAccountConfirmationScreenFree(),
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

  void _handleNavigationTap(int index, BuildContext context) async {
    if (index == _bottomNavIndex) return;

    if (index == 0) {
      setState(() => _bottomNavIndex = 0);
      await Navigator.pushNamed(context, Routes.projectsFree);
    } else if (index == 1) {
      setState(() => _bottomNavIndex = 1);
      await Navigator.pushNamed(context, Routes.searchProject);
    } else if (index == 3) {
      await Navigator.pushNamed(context, Routes.profileFree);
      setState(() => _bottomNavIndex = 3);
    }else if (index == 2) {
      await Navigator.pushNamed(context, Routes.favorites);
      setState(() => _bottomNavIndex = 2);
    }
  }
}
