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

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child:
                avatarUrl.isNotEmpty
                    ? Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(avatarUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                    : SvgPicture.asset('assets/icons/avatar.svg', width: 120, height: 120),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  position,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Palette.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTag(
                      icon: 'assets/icons/location.svg',
                      label: location,
                    ),
                    const SizedBox(width: 20),
                    _buildTag(
                      icon: 'assets/icons/StarFilled.svg',
                      label: rating.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'О себе:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            description.isNotEmpty
                ? description
                : 'Пользователь не заполнил данную информацию',
            style: const TextStyle(fontSize: 14, color: Palette.black),
          ),
          const SizedBox(height: 16),
          _infoRow('Опыт:', _localizeExperience(experience)),
          _infoRow('Страна:', country),
          const SizedBox(height: 16),
          const Text(
            'Навыки:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          skills.isNotEmpty
              ? Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    skills
                        .map(
                          (skill) => Chip(
                            label: Text(
                              skill,
                              style: const TextStyle(color: Palette.black),
                            ),
                            backgroundColor: Palette.white,
                            side: const BorderSide(color: Palette.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        )
                        .toList(),
              )
              : const Text(
                'Пользователь не заполнил данную информацию',
                style: TextStyle(fontSize: 14, color: Palette.black),
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
