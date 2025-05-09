import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../model/category/category.dart';
import '../model/profile/free/freelancer_profile_dto.dart';
import '../service/category_service.dart';
import '../util/palette.dart';
import '../widgets/avatar.dart';
import '../provider/auth_provider.dart';

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
    final cityRaw = freelancer.basic.city;
    final city = (cityRaw != null && cityRaw.isNotEmpty) ? cityRaw : null;
    const rating = '4.9';
    final avatarUrl = freelancer.avatarUrl;
    final catId = freelancer.about.categoryId;

    // Todo: покажи делаем запрос в карточке, но позже исправлю буду парсить и сразу название категории получать
    final token = context.read<AuthProvider>().token ?? '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: Palette.white,
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Avatar(
                url: avatarUrl,
                size: 60,
                placeholderAsset: 'assets/icons/avatar.svg',
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Имя
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                        color: Palette.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (catId > 0) ...[
                      const SizedBox(height: 4),
                      FutureBuilder<Category>(
                        future: CategoryService().getCategoryById(catId, token),
                        builder: (ctx, snap) {
                          if (snap.connectionState != ConnectionState.done) {
                            return const SizedBox(
                              height: 14,
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Palette.thin,
                                ),
                              ),
                            );
                          }
                          if (!snap.hasData) return const SizedBox.shrink();
                          return Text(
                            snap.data!.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Inter',
                              color: Palette.thin,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                    ],

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        if (city != null) ...[
                          _buildTag(
                            iconAsset: 'assets/icons/location.svg',
                            label: city,
                          ),
                          const SizedBox(width: 8),
                        ],
                        _buildTag(
                          iconAsset: 'assets/icons/star.svg',
                          label: rating,
                        ),
                      ],
                    ),
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
                    width: 24,
                    height: 24,
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

  Widget _buildTag({
    required String iconAsset,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Palette.grey3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 18,
            height: 18,
            color: Palette.thin,
          ),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
              color: Palette.black,
            ),
          ),
        ],
      ),
    );
  }
}