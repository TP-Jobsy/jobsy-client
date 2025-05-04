import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../component/application_card.dart';
import '../../util/palette.dart';
import '../../util/routes.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Map<String, dynamic> project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _applications = [];
  List<Map<String, dynamic>> _invitations = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Инициализация тестовых данных
    _applications = [
      {
        'name': 'Полина Попова',
        'position': 'QA инженер',
        'location': 'Москва',
        'rating': 4.9,
        'avatarUrl': 'https://randomuser.me/api/portraits/women/1.jpg',
        'status': 'Ожидает', // Статус отклика
        'isProcessed': false, // Флаг для определения, был ли отклик принят или отклонен
      },
      {
        'name': 'Виктория Сушкова',
        'position': 'QA инженер',
        'location': 'Москва',
        'rating': 4.7,
        'avatarUrl': 'https://randomuser.me/api/portraits/women/2.jpg',
        'status': 'Ожидает', // Статус отклика
        'isProcessed': false, // Флаг для определения, был ли отклик принят или отклонен
      },
    ];
  }

  void _onAccept(Map<String, dynamic> application) {
    setState(() {
      application['status'] = 'Рассматривается'; // Изменяем статус на "Рассматривается"
      application['isProcessed'] = true; // Устанавливаем флаг, что отклик обработан
      _applications.remove(application);  // Убираем из откликов
      _invitations.add(application);  // Добавляем в приглашения
    });

    // Переключаемся на вкладку "Приглашения" после принятия
    _tabController.animateTo(2);
  }

  void _onReject(Map<String, dynamic> application) {
    setState(() {
      application['status'] = 'Отклонено'; // Изменяем статус на "Отклонено"
      application['isProcessed'] = true; // Устанавливаем флаг, что отклик обработан
      _applications.remove(application);  // Убираем из откликов
      _invitations.add(application);  // Добавляем в приглашения
    });

    // Переключаемся на вкладку "Приглашения" после отклонения
    _tabController.animateTo(2);
  }

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
        leading: const BackButton(color: Palette.black),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
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
        controller: _tabController,
        children: [
          _buildDescriptionTab(),
          _buildApplicationsTab(),
          _buildInvitationsTab(),
        ],
      ),
    );
  }

  Widget _buildDescriptionTab() {
    final title = widget.project['title']?.toString() ?? 'Без названия';
    final description = widget.project['description']?.toString() ?? 'Описание отсутствует';
    final company = widget.project['clientCompany']?.toString() ?? 'Компания не указана';
    final location = widget.project['clientLocation']?.toString() ?? 'Локация не указана';
    final date = _formatDate(widget.project['createdAt']);
    final durationRaw = widget.project['duration']?.toString() ?? '';
    final complexityRaw = widget.project['complexity']?.toString() ?? '';
    final fixedPrice = widget.project['fixedPrice'];

    final duration = {
      'LESS_THAN_1_MONTH': 'Менее 1 месяца',
      'LESS_THAN_3_MONTHS': 'От 1 до 3 месяцев',
      'LESS_THAN_6_MONTHS': 'От 3 до 6 месяцев',
    }[durationRaw] ?? durationRaw;

    final complexity = {
      'EASY': 'Простой',
      'MEDIUM': 'Средний',
      'HARD': 'Сложный',
    }[complexityRaw] ?? complexityRaw;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            const Icon(Icons.apartment, size: 16, color: Palette.thin),
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
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        ),
        const SizedBox(height: 24),
        const Text(
          'Описание проекта:',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        ),
        const SizedBox(height: 8),
        Text(description, style: const TextStyle(fontSize: 14, fontFamily: 'Inter')),
        const SizedBox(height: 24),
        _infoRow('Срок выполнения:', duration),
        _infoRow('Бюджет:', fixedPrice != null ? '₽${fixedPrice.toString()}' : '—'),
        _infoRow('Уровень сложности:', complexity),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildApplicationsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: _applications.map((application) {
        return ApplicationCard(
          name: application['name'],
          position: application['position'],
          location: application['location'],
          rating: application['rating'],
          avatarUrl: application['avatarUrl'],
          status: application['status'],
          isProcessed: application['isProcessed'],
          onAccept: () => _onAccept(application),
          onReject: () => _onReject(application),
        );
      }).toList(),
    );
  }

  Widget _buildInvitationsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: _invitations.map((invitation) {
        return GestureDetector(
          onTap: () {
            // Переход на экран профиля фрилансера
            Navigator.pushNamed(
              context,
              Routes.freelancerProfileScreen,  // Обратите внимание на правильный маршрут
              arguments: {
                'name': invitation['name'],
                'position': invitation['position'],
                'location': invitation['location'],
                'avatarUrl': invitation['avatarUrl'],
                'rating': invitation['rating'],
                'description': invitation['description'],
                'skills': invitation['skills'] ?? [],  // Навыки
              },
            );
          },
          child: ApplicationCard(
            name: invitation['name'],
            position: invitation['position'],
            location: invitation['location'],
            rating: invitation['rating'],
            avatarUrl: invitation['avatarUrl'],
            status: invitation['status'],
            isProcessed: invitation['isProcessed'],
            onAccept: () {
              // Логика для принятия приглашения
            },
            onReject: () {
              // Логика для отказа
            },
          ),
        );
      }).toList(),
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
