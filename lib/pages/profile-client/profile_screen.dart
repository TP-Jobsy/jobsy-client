import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../component/custom_bottom_nav_bar.dart';
import '../../component/custom_nav_bar.dart';
import '../../component/error_snackbar.dart';
import '../../provider/auth_provider.dart';
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
  int _bottomNavIndex = 3;
  final ImagePicker _picker = ImagePicker();
  bool _uploading = false;

  Future<void> _pickAndUploadAvatar() async {
    final clientProv = context.read<ClientProfileProvider>();
    final token = context.read<AuthProvider>().token;
    if (token == null || token.isEmpty) return;

    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _uploading = true);
    try {
      await clientProv.uploadAvatar(File(picked.path));
      ErrorSnackbar.show(
        context,
        type: ErrorType.success,
        title: 'Успех',
        message: 'Аватар обновлён',
      );
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка загрузки',
        message: '$e',
      );
    } finally {
      setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallScreen = screenHeight < 600;

    final prov = context.watch<ClientProfileProvider>();
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
          ),
        ),
      );
    }

    final basic = profile.basic;
    final user = profile.user;

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
      body: SafeArea(
        child: SingleChildScrollView(
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
                  child: prov.loading || _uploading
                      ? const CircularProgressIndicator()
                      : (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
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
                  )),
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
                basic.position ?? '',
                style: TextStyle(
                  color: Palette.dotInactive,
                  fontSize: isSmallScreen ? 12 : 14,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: isSmallScreen ? 24 : 32),

              _buildSection(context, 'Основные данные', Routes.basicData,
                  isSmallScreen: isSmallScreen),
              _buildSection(context, 'Сфера деятельности', Routes.activityField,
                  isSmallScreen: isSmallScreen),
              _buildSection(context, 'Контактные данные', Routes.contactInfo,
                  isSmallScreen: isSmallScreen),
              _buildSection(context, 'Компания', Routes.companyInfo,
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
        builder: (context) => const DeleteAccountConfirmationScreen(),
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
          'Вы действительно хотите выйти?',
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
              final provider = context.read<ClientProfileProvider>();
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
      await Navigator.pushNamed(context, Routes.projects);
    } else if (index == 1) {
      setState(() => _bottomNavIndex = 1);
      await Navigator.pushNamed(context, Routes.freelancerSearch);
    } else if (index == 3) {
      await Navigator.pushNamed(context, Routes.profile);
      setState(() => _bottomNavIndex = 3);
    } else if (index == 2) {
      await Navigator.pushNamed(context, Routes.favoritesFreelancers);
      setState(() => _bottomNavIndex = 2);
    }
  }
}