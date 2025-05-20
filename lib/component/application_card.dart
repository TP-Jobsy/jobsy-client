import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../util/palette.dart';
import '../widgets/avatar.dart';

class ApplicationCard extends StatelessWidget {
  final String name;
  final String position;
  final String location;
  final double rating;
  final String avatarUrl;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final String status;
  final bool isProcessed;

  const ApplicationCard({
    Key? key,
    required this.name,
    required this.position,
    required this.location,
    required this.rating,
    required this.avatarUrl,
    required this.onAccept,
    required this.onReject,
    required this.status,
    required this.isProcessed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (status) {
      case 'Рассматривается':
        statusColor = Palette.primary;
        statusText = 'Рассматривается';
        break;
      case 'Отклонено':
        statusColor = Palette.red;
        statusText = 'Отклонено';
        break;
      default:
        statusColor = Palette.grey3;
        statusText = 'Ожидает';
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 90,
                        height: 90,
                        child: Avatar(
                          url: avatarUrl,
                          size: 90,
                          placeholderAsset: 'assets/icons/avatar.svg',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
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
                                if (position.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      position,
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
                            Row(
                              children: [
                                if (location.isNotEmpty) ...[
                                  _buildTag(
                                    iconAsset: 'assets/icons/location.svg',
                                    label: location,
                                  ),
                                  const SizedBox(width: 20),
                                ],
                                _buildTag(
                                  iconAsset: 'assets/icons/StarFilled.svg',
                                  label: rating.toStringAsFixed(1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (!isProcessed) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onReject,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Palette.red,
                            side: const BorderSide(color: Palette.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text(
                            'Отказать',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onAccept,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.primary,
                            foregroundColor: Palette.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text(
                            'Принять',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
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