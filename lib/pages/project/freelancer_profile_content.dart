import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../model/profile/free/freelancer_profile_dto.dart';
import '../../util/palette.dart';

class FreelancerProfileContent extends StatelessWidget {
  final FreelancerProfile freelancer;

  const FreelancerProfileContent({super.key, required this.freelancer});

  @override
  Widget build(BuildContext context) {
    final name = '${freelancer.basic.firstName} ${freelancer.basic.lastName}';
    final position = freelancer.about.categoryName ?? '';
    final location = freelancer.basic.city ?? '';
    final avatarUrl = freelancer.avatarUrl ?? '';
    final rating = freelancer.averageRating ?? 0.0;
    final description = freelancer.about.aboutMe ?? '';
    final skills = freelancer.about.skills?.map((s) => s.name).toList() ?? [];
    final experience = freelancer.about.experienceLevel ?? '';
    final country = freelancer.basic.country ?? '';

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isSmallScreen = screenWidth < 600;

    final double avatarSize = isSmallScreen ? 100 : 120;
    final double fontSizeTitle = isSmallScreen ? 20 : 24;
    final double fontSizeSubTitle = isSmallScreen ? 14 : 16;
    final double fontSizeNormal = isSmallScreen ? 13 : 14;

    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: avatarUrl.isNotEmpty
                ? Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(avatarUrl),
                  fit: BoxFit.cover,
                ),
              ),
            )
                : SvgPicture.asset('assets/icons/avatar.svg',
                width: avatarSize, height: avatarSize),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Center(
            child: Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: fontSizeTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 6 : 8),
                Text(
                  position,
                  style: TextStyle(
                    fontSize: fontSizeSubTitle,
                    color: Palette.secondary,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 6 : 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTag(
                      icon: 'assets/icons/location.svg',
                      label: location,
                    ),
                    SizedBox(width: isSmallScreen ? 16 : 20),
                    _buildTag(
                      icon: 'assets/icons/StarFilled.svg',
                      label: rating.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: isSmallScreen ? 20 : 24),
          Text(
            'О себе:',
            style: TextStyle(
              fontSize: fontSizeSubTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            description.isNotEmpty
                ? description
                : 'Пользователь не заполнил данную информацию',
            style: TextStyle(
              fontSize: fontSizeNormal,
              color: Palette.black,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          _infoRow('Опыт:', _localizeExperience(experience)),
          _infoRow('Страна:', country),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            'Навыки:',
            style: TextStyle(
              fontSize: fontSizeSubTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          skills.isNotEmpty
              ? Wrap(
            spacing: isSmallScreen ? 6 : 8,
            runSpacing: isSmallScreen ? 6 : 8,
            children: skills.map((skill) => Chip(
              label: Text(
                skill,
                style: TextStyle(
                  fontSize: fontSizeNormal,
                  color: Palette.black,
                ),
              ),
              backgroundColor: Palette.white,
              side: BorderSide(color: Palette.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            )).toList(),
          )
              : Text(
            'Пользователь не заполнил данную информацию',
            style: TextStyle(
              fontSize: fontSizeNormal,
              color: Palette.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag({required String icon, required String label}) {
    if (label.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Palette.grey3),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 20,
            height: 20,
            color: Palette.secondaryIcon,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Palette.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    final displayValue = value.trim().isNotEmpty
        ? value
        : 'Пользователь не заполнил данную информацию';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              style: const TextStyle(fontFamily: 'Inter'),
            ),
          ),
        ],
      ),
    );
  }
}

String _localizeExperience(String raw) {
  switch (raw) {
    case 'BEGINNER':
      return 'Начинающий';
    case 'MIDDLE':
      return 'Средний уровень';
    case 'EXPERT':
      return 'Эксперт';
    default:
      return raw;
  }
}