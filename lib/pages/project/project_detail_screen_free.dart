import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../util/palette.dart';

class ProjectDetailScreenFree extends StatelessWidget {
  final Map<String, dynamic> projectFree;

  const ProjectDetailScreenFree({super.key, required this.projectFree});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: const Text('Проект', style: TextStyle(fontFamily: 'Inter')),
        centerTitle: true,
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildDescriptionTab(context),
    );
  }

  Widget _buildDescriptionTab(BuildContext context) {
    final title = projectFree['title']?.toString() ?? 'Без названия';
    final description =
        projectFree['description']?.toString() ?? 'Описание отсутствует';
    final company =
        projectFree['clientCompany']?.toString() ?? 'Компания не указана';
    final location =
        projectFree['clientLocation']?.toString() ?? 'Локация не указана';
    final date = _formatDate(projectFree['createdAt']);
    final durationRaw = projectFree['duration']?.toString() ?? '';
    final complexityRaw = projectFree['complexity']?.toString() ?? '';
    final fixedPrice = projectFree['fixedPrice'];

    final duration =
        {
          'LESS_THAN_1_MONTH': 'Менее 1 месяца',
          'LESS_THAN_3_MONTHS': 'От 1 до 3 месяцев',
          'LESS_THAN_6_MONTHS': 'От 3 до 6 месяцев',
        }[durationRaw] ?? durationRaw;

    final complexity =
        {
          'EASY': 'Простой',
          'MEDIUM': 'Средний',
          'HARD': 'Сложный',
        }[complexityRaw] ?? complexityRaw;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/icons/company.svg', width: 17, height: 17, color: Palette.thin),
                  const SizedBox(width: 4),
                  Text(company, style: _thinText()),
                  const SizedBox(width: 12),
                  SvgPicture.asset('assets/icons/location.svg', width: 17, height: 17, color: Palette.thin),
                  const SizedBox(width: 4),
                  Text(location, style: _thinText()),
                  const Spacer(),
                  Text(date, style: _thinText()),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Описание проекта:',
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 24),
              _infoRow('Срок выполнения:', duration),
              _infoRow(
                'Бюджет:',
                fixedPrice != null ? '₽${fixedPrice.toString()}' : '—',
              ),
              _infoRow('Уровень сложности:', complexity),
              const SizedBox(height: 24),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _actionButton(context, 'Откликнуться', Palette.primary, () {
                print('Откликнуться');
              }),
              const SizedBox(height: 12),
              _actionButton(context, 'Связаться', Palette.sky, () {
                print('Связаться');
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontFamily: 'Inter')),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    final dt = DateTime.tryParse(isoDate);
    if (dt == null) return '';
    return DateFormat('d MMMM yyyy', 'ru').format(dt);
  }

  TextStyle _thinText() {
    return const TextStyle(
      fontSize: 12,
      color: Palette.thin,
      fontFamily: 'Inter',
    );
  }

  Widget _actionButton(BuildContext context, String label, Color buttonColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.primary,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: Palette.white,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
