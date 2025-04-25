import 'package:flutter/material.dart';

import '../../util/pallete.dart';

class ProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project['title'] ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Palette.primary,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Почасовая ставка: 500–600 руб / час, уровень сложности — сложный, дедлайн — от 1 до 3 месяцев',
              style: TextStyle(
                fontSize: 13,
                color: Palette.secondary,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.apartment, size: 16, color: Palette.secondary),
                const SizedBox(width: 4),
                const Text(
                  'Digital Growth Agency',
                  style: TextStyle(fontSize: 13, fontFamily: 'Inter'),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.location_on, size: 16, color: Palette.secondary),
                const SizedBox(width: 4),
                const Text(
                  'Дубай, ОАЭ',
                  style: TextStyle(fontSize: 13, fontFamily: 'Inter'),
                ),
                const Spacer(),
                Text(
                  _formatDate(project['createdAt']),
                  style: TextStyle(fontSize: 12, color: Palette.dotInactive, fontFamily: 'Inter'),
                )
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
    return '${dt.day} ${_monthName(dt.month)} ${dt.year}';
  }

  String _monthName(int month) {
    const months = [
      '', 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
    ];
    return months[month];
  }
}
