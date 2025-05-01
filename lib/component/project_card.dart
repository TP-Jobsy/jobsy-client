import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../util/palette.dart';
import '../model/category.dart';
import '../model/specialization.dart';

class ProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final title = project['title'] ?? '';
    final fixedPriceRaw = project['fixedPrice'];
    final fixedPrice = (fixedPriceRaw is num) ? fixedPriceRaw.toDouble() : null;

    final complexityRaw = project['complexity'] ?? '';
    final durationRaw = project['duration'] ?? '';
    final createdAt = project['createdAt'];

    final category = project['category'] as CategoryDto?;
    final specialization = project['specialization'] as SpecializationDto?;

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
            // 🔹 Заголовок + троеточие
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
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Palette.thin),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 'edit' && onEdit != null) onEdit!();
                    if (value == 'delete' && onDelete != null) onDelete!();
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.black),
                          SizedBox(width: 8),
                          Text('Редактировать', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.black),
                          SizedBox(width: 8),
                          Text('Удалить', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 🔹 Цена, сложность, дедлайн
            Text(
              _buildInfoLine(fixedPrice, complexity, duration),
              style: const TextStyle(
                fontSize: 13,
                color: Palette.thin,
                fontFamily: 'Inter',
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 Категория · Специализация · Дата
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

  String _buildInfoLine(double? price, String complexity, String duration) {
    final priceText = price != null ? '₽${price.toStringAsFixed(2)}' : '—';
    return 'Цена: $priceText, сложность — $complexity, дедлайн — $duration';
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    final dt = DateTime.tryParse(isoDate);
    if (dt == null) return '';
    return DateFormat('d MMM yyyy', 'ru').format(dt);
  }
}
