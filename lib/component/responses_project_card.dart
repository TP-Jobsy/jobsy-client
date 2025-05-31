import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../util/palette.dart';

class ResponsesProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;
  final String status;

  const ResponsesProjectCard({
    super.key,
    required this.project,
    this.status = 'Рассматривается',
  });

  @override
  Widget build(BuildContext context) {
    final title = project['title'] ?? '';
    final fixedPriceRaw = project['fixedPrice'];
    final fixedPrice = (fixedPriceRaw is num) ? fixedPriceRaw.toDouble() : null;

    final complexityRaw = project['complexity'] ?? '';
    final durationRaw = project['duration'] ?? '';
    final createdAt = project['createdAt'];

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

    final company = (project['clientCompany'] ?? '').toString().trim();
    final location = (project['clientLocation'] ?? '').toString().trim();

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
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Palette.primary,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                if (status.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Palette.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),

            Text(
              'Цена: ${fixedPrice != null ? '₽${fixedPrice.toStringAsFixed(2)}' : '—'}, '
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
                if (company.isNotEmpty) ...[
                  SvgPicture.asset('assets/icons/company.svg'),
                  const SizedBox(width: 4),
                  Text(
                    company,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Palette.thin,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
                if (company.isNotEmpty && location.isNotEmpty)
                  const SizedBox(width: 12),
                if (location.isNotEmpty) ...[
                  SvgPicture.asset(
                    'assets/icons/location.svg',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Palette.thin,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  _formatDate(createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Palette.secondary,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    final dt = DateTime.tryParse(isoDate);
    if (dt == null) return '';
    return DateFormat('d MMM yyyy', 'ru').format(dt);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Рассматривается':
        return Palette.orange;
      case 'Отказано':
        return Palette.red;
      default:
        return Palette.grey3;
    }
  }
}