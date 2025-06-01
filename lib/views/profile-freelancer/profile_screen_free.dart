import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../../util/palette.dart';
import '../../../util/routes.dart';
import '../../component/custom_bottom_nav_bar.dart';
import '../../component/error_snackbar.dart';
import '../../viewmodels/freelancer_profile_provider.dart';
import 'delete_account_screen_free.dart';

class ProfileScreenFree extends StatefulWidget {
  const ProfileScreenFree({super.key});

  @override
  _ProfileScreenFreeState createState() => _ProfileScreenFreeState();
}

class _ProfileScreenFreeState extends State<ProfileScreenFree> {
  final ImagePicker _picker = ImagePicker();
  int _bottomNavIndex = 3;
  bool _uploading = false;

  Future<void> _pickAndUploadAvatar() async {
    final profProv = context.read<FreelancerProfileProvider>();

    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _uploading = true);
    try {
      final ok = await profProv.uploadAvatar(File(picked.path));
      if (ok) {
        ErrorSnackbar.show(
          context,
          type: ErrorType.success,
          title: 'Успех',
          message: 'Аватар обновлён',
        );
      } else {
        ErrorSnackbar.show(
          context,
          type: ErrorType.error,
          title: 'Ошибка загрузки',
          message: profProv.error ?? 'Неизвестная ошибка',
        );
      }
    } finally {
      setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

    final prov = context.watch<FreelancerProfileProvider>();
    final profile = prov.profile;

    if (prov.loading && profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (profile == null) {
      return Scaffold(
        body: Center(
            child: Text(
              prov.error ?? 'Профиль не загружен',
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            )),
      );
    }

    final user = profile.user;
    final about = profile.about;

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        leading: SizedBox(width: isSmallScreen ? 12 : 15),
        title: 'Профиль',
        titleStyle: TextStyle(
          fontSize: isSmallScreen ? 20 : 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
        trailing: const SizedBox(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 24,
          vertical: isSmallScreen ? 16 : 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _uploading ? null : _pickAndUploadAvatar,
              child: CircleAvatar(
                radius: isSmallScreen ? 40 : 45,
                backgroundColor: Colors.transparent,
                child: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                    ? ClipOval(
                  child: Image.network(
                    profile.avatarUrl!,
                    width: isSmallScreen ? 80 : 90,
                    height: isSmallScreen ? 80 : 90,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return SvgPicture.asset(
                        'assets/icons/avatar.svg',
                        width: isSmallScreen ? 80 : 90,
                        height: isSmallScreen ? 80 : 90,
                      );
                    },
                    errorBuilder: (_, __, ___) => SvgPicture.asset(
                      'assets/icons/avatar.svg',
                      width: isSmallScreen ? 80 : 90,
                      height: isSmallScreen ? 80 : 90,
                    ),
                  ),
                )
                    : SvgPicture.asset(
                  'assets/icons/avatar.svg',
                  width: isSmallScreen ? 80 : 90,
                  height: isSmallScreen ? 80 : 90,
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 8 : 12),
            Text(
              '${user.firstName} ${user.lastName}',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: isSmallScreen ? 2 : 4),
            Text(
              about.categoryName ?? '—',
              style: TextStyle(
                color: Palette.black1,
                fontSize: isSmallScreen ? 12 : 14,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),
            _buildSection(context, 'Основные данные', Routes.basicDataFree,
                isSmallScreen: isSmallScreen),
            _buildSection(context, 'О себе', Routes.activityFieldFree,
                isSmallScreen: isSmallScreen),
            _buildSection(context, 'Контактные данные', Routes.contactInfoFree,
                isSmallScreen: isSmallScreen),
            _buildSection(context, 'Портфолио', Routes.portfolio,
                isSmallScreen: isSmallScreen),
            _buildSection(
              context,
              'Удалить аккаунт',
              null,
              isSmallScreen: isSmallScreen,
              isDestructive: true,
            ),
            SizedBox(height: isSmallScreen ? 0 : 1),
            SizedBox(
              width: double.infinity,
              height: isSmallScreen ? 45 : 50,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutConfirmation(context, isSmallScreen),
                icon: SvgPicture.asset(
                  'assets/icons/logout.svg',
                  color: Palette.red,
                  width: isSmallScreen ? 16 : 20,
                  height: isSmallScreen ? 16 : 20,
                ),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Выйти из аккаунта',
                    style: TextStyle(
                      color: Palette.red,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: isSmallScreen ? 12 : 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Palette.grey3),
                  ),
                ).copyWith(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) => _handleNavigationTap(i, context),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context,
      String title,
      String? route, {
        bool isSmallScreen = false,
        bool isDestructive = false,
      }) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 16 : 20),
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
            fontSize: isSmallScreen ? 14 : 16,
          ),
        ),
        trailing: SvgPicture.asset(
          'assets/icons/ArrowRight.svg',
          width: isSmallScreen ? 10 : 12,
          height: isSmallScreen ? 10 : 12,
          color: Palette.navbar,
        ),
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

  void _showLogoutConfirmation(BuildContext context, bool isSmallScreen) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Palette.white,
        title: Text(
          'Выход из аккаунта',
          style: TextStyle(fontSize: isSmallScreen ? 18 : 20),
        ),
        content: Text(
          'Вы уверены, что хотите выйти?',
          style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Отмена',
              style: TextStyle(
                color: Palette.black,
                fontFamily: 'Inter',
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            style: TextButton.styleFrom().copyWith(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
          ),
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
            child: Text(
              'Выйти',
              style: TextStyle(
                color: Palette.red,
                fontFamily: 'Inter',
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            style: TextButton.styleFrom().copyWith(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
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
    } else if (index == 2) {
      await Navigator.pushNamed(context, Routes.favorites);
      setState(() => _bottomNavIndex = 2);
    }
  }
}