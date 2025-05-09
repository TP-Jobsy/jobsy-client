import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model/profile/free/freelancer_profile_dto.dart';
import '../util/palette.dart';

class FavoritesCardFreelancer extends StatelessWidget {
  final FreelancerProfile freelancer;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onTap;

  const FavoritesCardFreelancer({
    Key? key,
    required this.freelancer,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = '${freelancer.basic.firstName} ${freelancer.basic.lastName}';
    final position = freelancer.basic.position ?? '';
    final location = [
      freelancer.basic.city,
      freelancer.basic.country
    ].where((s) => s != null && s!.isNotEmpty).join(', ');
    final avatarUrl = freelancer.avatarUrl ?? '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: Palette.white,
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Аватар
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: avatarUrl.isEmpty
                    ? Container(
                  width: 60,
                  height: 60,
                  color: Palette.grey3,
                )
                    : Image.network(avatarUrl, width: 60, height: 60, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              // Инфо
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(position,
                        style: const TextStyle(
                            fontSize: 14, color: Palette.thin)),
                    if (location.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/location.svg',
                              width: 16, height: 16, color: Palette.thin),
                          const SizedBox(width: 4),
                          Text(location,
                              style: const TextStyle(
                                  fontSize: 13, color: Palette.thin)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              InkWell(
                onTap: onFavoriteToggle,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    isFavorite
                        ? 'assets/icons/Heart Filled.svg'
                        : 'assets/icons/Heart Outlined.svg',
                    width: 20,
                    height: 20,
                    color: Palette.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}