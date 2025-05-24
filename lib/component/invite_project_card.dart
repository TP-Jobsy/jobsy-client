import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../util/palette.dart';

class InviteProjectCard extends StatelessWidget {
  final String projectTitle;
  final String projectDescription;
  final double? fixedPrice;
  final String complexityRaw;
  final String durationRaw;
  final String? company;
  final String? location;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final String status;
  final bool isProcessed;
  final String? createdAt;

  const InviteProjectCard({
    Key? key,
    required this.projectTitle,
    required this.projectDescription,
    this.fixedPrice,
    required this.complexityRaw,
    required this.durationRaw,
    this.company,
    this.location,
    this.onAccept,
    this.onReject,
    required this.status,
    required this.isProcessed,
    this.createdAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    final complexity =
        {
          'EASY': 'простая',
          'MEDIUM': 'средняя',
          'HARD': 'сложная',
        }[complexityRaw] ??
        complexityRaw;

    final duration =
        {
          'LESS_THAN_1_MONTH': 'менее 1 месяца',
          'LESS_THAN_3_MONTHS': 'от 1 до 3 месяцев',
          'LESS_THAN_6_MONTHS': 'от 3 до 6 месяцев',
        }[durationRaw] ??
        durationRaw;

    switch (status) {
      case 'PENDING':
        statusColor = Palette.primary;
        statusText = 'Рассматривается';
        break;
      case 'DECLINED':
        statusColor = Palette.red;
        statusText = 'Отклонено';
        break;
      case 'APPROVED':
        statusColor = Palette.green;
        statusText = 'Принято';
        break;
      default:
        statusColor = Palette.blue1;
        statusText = 'Ожидает';
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Palette.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                if ((company?.isNotEmpty ?? false) &&
                    (location?.isNotEmpty ?? false))
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
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Palette.grey2.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: onReject,
                        style: TextButton.styleFrom(
                          foregroundColor: Palette.red,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                          ),
                        ),
                        child: const Text('Отклонить'),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: Palette.grey2.withOpacity(0.2),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: onAccept,
                        style: TextButton.styleFrom(
                          foregroundColor: Palette.primary,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                          ),
                        ),
                        child: const Text('Принять'),
                      ),
                    ),
                  ],
                ),
              ),
            ]
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
