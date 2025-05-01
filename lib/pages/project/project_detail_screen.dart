import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../util/palette.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Palette.white,
        appBar: AppBar(
          title: const Text('Проект', style: TextStyle(fontFamily: 'Inter')),
          centerTitle: true,
          backgroundColor: Palette.white,
          foregroundColor: Palette.black,
          elevation: 0,
          leading: const BackButton(color: Palette.black),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Описание'),
              Tab(text: 'Отклики'),
              Tab(text: 'Приглашения'),
            ],
            labelColor: Palette.primary,
            unselectedLabelColor: Palette.thin,
            indicatorColor: Palette.primary,
          ),
        ),
        body: TabBarView(
          children: [
            _buildDescriptionTab(),
            _buildPlaceholder('Отклики пока недоступны'),
            _buildPlaceholder('Приглашения пока недоступны'),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionTab() {
    final title = project['title']?.toString() ?? 'Без названия';
    final description = project['description']?.toString() ?? 'Описание отсутствует';
    final category = project['category']?.toString() ?? '';
    final specialization = project['specialization']?.toString() ?? '';
    final company = project['company']?['name']?.toString() ?? 'Компания не указана';
    final location = project['location']?.toString() ?? 'Локация не указана';
    final date = _formatDate(project['createdAt']);
    final duration = project['duration']?.toString() ?? '';
    final complexity = project['complexity']?.toString() ?? '';
    final rating = project['rating']?.toString() ?? '—';
    final budget = project['budget'] is Map
        ? '${project['budget']?['amount']} ${project['budget']?['currency']}'
        : project['budget']?.toString() ?? '—';
    final skills = (project['skills'] is List)
        ? List<String>.from(project['skills'].map((e) => e.toString()))
        : <String>[];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        Row(
          children: [
            const Icon(Icons.business, size: 16, color: Palette.thin),
            const SizedBox(width: 4),
            Text(company, style: _thinText()),
            const SizedBox(width: 12),
            const Icon(Icons.location_on, size: 16, color: Palette.thin),
            const SizedBox(width: 4),
            Text(location, style: _thinText()),
            const Spacer(),
            Text(date, style: _thinText()),
          ],
        ),
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
        const SizedBox(height: 24),
        const Text('Описание проекта:', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
        const SizedBox(height: 8),
        Text(description, style: const TextStyle(fontSize: 14, fontFamily: 'Inter')),
        const SizedBox(height: 24),
        _infoRow('Срок выполнения:', duration),
        _infoRow('Бюджет:', budget),
        _infoRow('Уровень сложности:', complexity),
        _infoRow('Оценка клиента:', rating),
        const SizedBox(height: 24),
        if (skills.isNotEmpty) ...[
          const Text('Навыки:', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills
                .map((skill) => Chip(
              label: Text(skill, style: const TextStyle(fontFamily: 'Inter')),
              backgroundColor: Palette.dotInactive,
            ))
                .toList(),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
          Expanded(child: Text(value, style: const TextStyle(fontFamily: 'Inter'))),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(fontSize: 16, fontFamily: 'Inter'),
        textAlign: TextAlign.center,
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
    return const TextStyle(fontSize: 12, color: Palette.thin, fontFamily: 'Inter');
  }
}
