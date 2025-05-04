import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/palette.dart';

enum AdminSection { users, projects, portfolio }

class Sidebar extends StatelessWidget {
  final AdminSection current;
  const Sidebar({Key? key, this.current = AdminSection.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget navButton({
      required String label,
      required String iconAsset,
      required String route,
      bool active = false,
      Color? textColor,
      Color? iconColor,
    }) {
      final fgText = active ? Colors.white : (textColor ?? Palette.black);
      final fgIcon = active ? Colors.white : (iconColor ?? Palette.black);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => Navigator.pushReplacementNamed(context, route),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: active ? Palette.primary : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: active ? null : Border.all(color: Palette.grey7),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    iconAsset,
                    width: 20,
                    height: 20,
                    color: fgIcon,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      color: fgText,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: 198,
      height: double.infinity,
      padding: const EdgeInsets.fromLTRB(19, 50, 19, 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(2, 0)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/logo.svg',
              width: 180,
              height: 70,
            ),
          ),
          const SizedBox(height: 32),
          navButton(
            label: 'Пользователи',
            iconAsset: 'assets/icons/user.svg',
            route: '/admin/users',
            active: current == AdminSection.users,
          ),
          navButton(
            label: 'Проекты',
            iconAsset: 'assets/icons/projects.svg',
            route: '/admin/projects',
            active: current == AdminSection.projects,
          ),
          navButton(
            label: 'Портфолио',
            iconAsset: 'assets/icons/portfolio.svg',
            route: '/admin/portfolio',
            active: current == AdminSection.portfolio,
          ),
          const Spacer(),
          navButton(
            label: 'Выйти',
            iconAsset: 'assets/icons/logout.svg',
            route: '/admin/login',
            textColor: Palette.red,
            iconColor: Palette.red,
          ),
        ],
      ),
    );
  }
}