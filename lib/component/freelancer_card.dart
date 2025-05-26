import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/palette.dart';

class FreelancerCard extends StatelessWidget {
  final String name;
  final String position;
  final String location;
  final double rating;
  final String avatarUrl;
  final VoidCallback onTap;

  const FreelancerCard({
    super.key,
    required this.name,
    required this.position,
    required this.location,
    required this.rating,
    required this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Palette.red,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(avatarUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          position,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Inter',
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildTag(
                    icon: SvgPicture.asset('assets/icons/location.svg', width: 15, height: 15),
                    label: location,
                  ),
                  const SizedBox(width: 5),
                  _buildTag(
                    icon: SvgPicture.asset('assets/icons/StarFilled.svg', width: 15, height: 15),
                    label: rating.toStringAsFixed(1),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag({required SvgPicture icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: Palette.grey3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
              color: Palette.black,
            ),
          ),
        ],
      ),
    );
  }
}