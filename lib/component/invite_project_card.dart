import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../util/palette.dart';

class InviteProjectCard extends StatelessWidget {
  final String projectTitle;
  final String projectDescription;
  final double? fixedPrice;
  final String complexity;
  final String duration;
  final String? company;
  final String? location;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final String status;
  final bool isProcessed;
  final String? createdAt;

  const InviteProjectCard({
    Key? key,
    required this.projectTitle,
    required this.projectDescription,
    this.fixedPrice,
    required this.complexity,
    required this.duration,
    this.company,
    this.location,
    required this.onAccept,
    required this.onReject,
    required this.status,
    required this.isProcessed,
    this.createdAt,
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
      case 'Принято':
        statusColor = Palette.green;
        statusText = 'Принято';
        break;
      default:
        statusColor = Palette.grey3;
        statusText = 'Ожидает';
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Palette.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    projectTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Palette.primary,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Цена: ${fixedPrice != null ? '₽${fixedPrice?.toStringAsFixed(2)}' : '—'}, '
                  'Сложность — $complexity, Срок — $duration',
              style: const TextStyle(
                fontSize: 13,
                color: Palette.thin,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (company?.isNotEmpty ?? false) ...[
                  const Icon(Icons.business, size: 16, color: Palette.thin),
                  const SizedBox(width: 4),
                  Text(
                    company!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Palette.thin,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
                if ((company?.isNotEmpty ?? false) && (location?.isNotEmpty ?? false))
                  const SizedBox(width: 12),
                if (location?.isNotEmpty ?? false) ...[
                  const Icon(Icons.location_on, size: 16, color: Palette.thin),
                  const SizedBox(width: 4),
                  Text(
                    location!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Palette.thin,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
                const Spacer(),
                if (createdAt != null)
                  Text(
                    _formatDate(createdAt!),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Palette.secondary,
                      fontFamily: 'Inter',
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Отказать',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primary,
                        foregroundColor: Palette.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Принять',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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
      ),
    );
  }

  String _formatDate(String isoDate) {
    final dt = DateTime.tryParse(isoDate);
    if (dt == null) return '';
    return DateFormat('d MMM yyyy', 'ru').format(dt);
  }
}