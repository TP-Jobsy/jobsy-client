import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model/profile/free/freelancer_list_item.dart';
import '../util/palette.dart';
import '../widgets/avatar.dart';

class FavoritesCardFreelancer extends StatelessWidget {
  final FreelancerListItem freelancerItem;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onTap;

  const FavoritesCardFreelancer({
    Key? key,
    required this.freelancerItem,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = '${freelancerItem.firstName} ${freelancerItem.lastName}';
    final cityRaw = freelancerItem.city ?? '';
    final city = cityRaw.isNotEmpty ? cityRaw : null;
    final rating = freelancerItem.averageRating ?? 0.0;
    final ratingStr = rating.toStringAsFixed(1);
    final categoryName = freelancerItem.categoryName ?? '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: Palette.white,
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: Avatar(
                    url: freelancerItem.avatarUrl,
                    size: 90,
                    placeholderAsset: 'assets/icons/avatar.svg',
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SizedBox(
                  height: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          if (categoryName != null && categoryName.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                categoryName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  color: Palette.thin,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (city != null) ...[
                              _buildTag(
                                iconAsset: 'assets/icons/location.svg',
                                label: city,
                              ),
                              const SizedBox(width: 12),
                            ],
                            _buildTag(
                              iconAsset: 'assets/icons/StarFilled.svg',
                              label: ratingStr,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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

  Widget _buildTag({required String iconAsset, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Palette.grey3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 18,
            height: 18,
            color: Palette.secondaryIcon,
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
