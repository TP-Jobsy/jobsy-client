import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../util/pallete.dart';
import '../model/category.dart';
import '../model/specialization.dart';

class ProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;
  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final title         = project['title']       as String? ?? '';
    final fixedPriceRaw = project['fixedPrice'];
    final fixedPrice    = (fixedPriceRaw is num) ? fixedPriceRaw.toDouble() : null;

    final complexityRaw = project['complexity']  as String? ?? '';
    final durationRaw   = project['duration']    as String? ?? '';
    final createdAt     = project['createdAt']   as String?;

    final category      = project['category']      as CategoryDto?;
    final specialization= project['specialization']as SpecializationDto?;

    final complexity = <String,String>{
      'EASY': 'Простой',
      'MEDIUM': 'Средний',
      'HARD': 'Сложный',
    }[complexityRaw] ?? complexityRaw;

    final duration = <String,String>{
      'LESS_THAN_1_MONTH': 'Менее 1 месяца',
      'LESS_THAN_3_MONTHS': 'От 1 до 3 месяцев',
      'LESS_THAN_6_MONTHS': 'От 3 до 6 месяцев',
    }[durationRaw] ?? durationRaw;

    return Card(
      elevation: 1,
      color: Palette.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Palette.primary,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),

            // Цена, сложность, дедлайн
            Text(
              _buildInfoLine(fixedPrice, complexity, duration),
              style: TextStyle(
                fontSize: 13,
                color: Palette.thin,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),

            // Категория · Специализация · Дата
            Row(
              children: [
                const Icon(Icons.category, size: 16, color: Palette.thin),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    category?.name ?? '',
                    style: const TextStyle(fontSize: 13, fontFamily: 'Inter'),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.work_outline, size: 16, color: Palette.thin),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    specialization?.name ?? '',
                    style: const TextStyle(fontSize: 13, fontFamily: 'Inter'),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(createdAt),
                  style: TextStyle(
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

  String _buildInfoLine(double? fixedPrice, String complexity, String duration) {
    final priceText = fixedPrice != null
        ? '₽${fixedPrice.toStringAsFixed(2)}'
        : '—';
    return 'Цена: $priceText, сложность — $complexity, дедлайн — $duration';
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    final dt = DateTime.tryParse(isoDate);
    if (dt == null) return '';
    return DateFormat('d MMMM yyyy', 'ru').format(dt);
  }
}
