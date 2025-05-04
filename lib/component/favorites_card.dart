import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../util/palette.dart';

class ProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;
  final VoidCallback onFavoriteToggle;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final title = project['title'] ?? '';
    final fixedPriceRaw = project['fixedPrice'];
    final fixedPrice = (fixedPriceRaw is num) ? fixedPriceRaw.toDouble() : null;

    final complexityRaw = project['complexity'] ?? '';
    final durationRaw = project['duration'] ?? '';
    final createdAt = project['createdAt'];

    final complexity = {
      'EASY': 'Простой',
      'MEDIUM': 'Средний',
      'HARD': 'Сложный',
    }[complexityRaw] ?? complexityRaw;

    final duration = {
      'LESS_THAN_1_MONTH': 'Менее 1 месяца',
      'LESS_THAN_3_MONTHS': 'От 1 до 3 месяцев',
      'LESS_THAN_6_MONTHS': 'От 3 до 6 месяцев',
    }[durationRaw] ?? durationRaw;

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
                GestureDetector(
                  onTap: onFavoriteToggle,
                  child: SvgPicture.asset(
                    'assets/icons/Heart Filled.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Palette.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Цена: ${fixedPrice != null ? '₽${fixedPrice.toStringAsFixed(2)}' : '—'}, '
                  'сложность — $complexity, дедлайн — $duration',
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
                  const Icon(Icons.apartment, size: 16, color: Palette.thin),
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
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Palette.thin,
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
}
