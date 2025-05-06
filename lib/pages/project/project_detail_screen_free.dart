import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../component/error_snackbar.dart';
import '../../util/palette.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/freelancer_response_service.dart';

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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildDescriptionTab(context),
    );
  }

  Widget _buildDescriptionTab(BuildContext context) {
    // Основные поля
    final title = projectFree['title'] as String? ?? 'Без названия';
    final description =
        projectFree['description'] as String? ?? 'Описание отсутствует';
    final date = _formatDate(projectFree['createdAt'] as String?);
    final durationRaw = projectFree['duration'] as String? ?? '';
    final complexityRaw = projectFree['complexity'] as String? ?? '';
    final fixedPriceNum = projectFree['fixedPrice'] as num?;
    final fixedPrice =
        fixedPriceNum != null ? '₽${fixedPriceNum.toStringAsFixed(0)}' : '—';

    // Локализация
    final duration =
        {
          'LESS_THAN_1_MONTH': 'менее 1 месяца',
          'LESS_THAN_3_MONTHS': 'от 1 до 3 месяцев',
          'LESS_THAN_6_MONTHS': 'от 3 до 6 месяцев',
        }[durationRaw] ??
        durationRaw;

    final complexity =
        {
          'EASY': 'простая',
          'MEDIUM': 'средняя',
          'HARD': 'сложная',
        }[complexityRaw] ??
        complexityRaw;

    // Клиент (basic → companyName, country, city, phone, email)
    final clientBasic =
        (projectFree['client']?['basic'] ?? {}) as Map<String, dynamic>;
    final company = clientBasic['companyName'] as String?;
    final country = clientBasic['country'] as String?;
    final city = clientBasic['city'] as String?;
    final phone = clientBasic['phone'] as String?;
    final email = clientBasic['email'] as String?;

    // Навыки
    final skills =
        (projectFree['skills'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>()
            .map((s) => s['name'] as String? ?? '')
            .where((n) => n.isNotEmpty)
            .toList() ??
        [];

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Клиент + дата
              Row(
                children: [
                  if (company != null && company.isNotEmpty) ...[
                    SvgPicture.asset(
                      'assets/icons/company.svg',
                      width: 17,
                      height: 17,
                      color: Palette.thin,
                    ),
                    const SizedBox(width: 4),
                    Text(company, style: _thinText()),
                    const SizedBox(width: 12),
                  ],
                  if (country != null && country.isNotEmpty) ...[
                    Text(country, style: _thinText()),
                    const SizedBox(width: 8),
                  ],
                  if (city != null && city.isNotEmpty) ...[
                    SvgPicture.asset(
                      'assets/icons/location.svg',
                      width: 17,
                      height: 17,
                      color: Palette.thin,
                    ),
                    const SizedBox(width: 4),
                    Text(city, style: _thinText()),
                  ],
                  const Spacer(),
                  Text(date, style: _thinText()),
                ],
              ),
              const SizedBox(height: 16),

              // Заголовок
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),

              const SizedBox(height: 20),
              Divider(color: Palette.grey2, thickness: 1),
              const SizedBox(height: 20),

              // Описание
              const Text(
                'Описание проекта:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              Text(description, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 20),

              Divider(color: Palette.grey3, thickness: 1),
              const SizedBox(height: 20),

              // Параметры
              _infoRow('Бюджет:', fixedPrice),
              _infoRow('Срок выполнения:', duration),
              _infoRow('Уровень сложности:', complexity),

              const SizedBox(height: 20),
              Divider(color: Palette.grey3, thickness: 1),
              const SizedBox(height: 20),

              // Навыки
              const Text(
                'Навыки:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              if (skills.isEmpty)
                Text('— нет навыков', style: _thinText())
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      skills
                          .map(
                            (name) => Chip(
                              label: Text(name),
                              backgroundColor: Palette.grey2.withOpacity(0.2),
                            ),
                          )
                          .toList(),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),

        // Действия
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 1) «Связаться» по телефону или email
              _actionButton(context, 'Связаться', Palette.primary, () async {
                String? uri;
                if (phone != null && phone.isNotEmpty) {
                  uri = 'tel:$phone';
                } else if (email != null && email.isNotEmpty) {
                  uri = 'mailto:$email';
                }
                if (uri != null && await canLaunchUrl(Uri.parse(uri))) {
                  await launchUrl(Uri.parse(uri));
                } else {
                  ErrorSnackbar.show(
                    context,
                    type: ErrorType.warning,
                    title: 'Внимание',
                    message: 'Контактная информация недоступна',
                  );
                }
              }),
              const SizedBox(height: 16),

              // 2) «Откликнуться»
              _actionButton(context, 'Откликнуться', Palette.sky, () async {
                final auth = context.read<AuthProvider>();
                final token = auth.token;
                if (token == null) {
                  ErrorSnackbar.show(
                    context,
                    type: ErrorType.warning,
                    title: 'Внимание',
                    message: 'Пожалуйста, авторизуйтесь',
                  );
                  return;
                }

                // 1) Преобразуем freelancerId
                final rawFreelancerId = auth.user?.id;
                final freelancerId = int.tryParse(rawFreelancerId?.toString() ?? '');
                if (freelancerId == null) {
                  ErrorSnackbar.show(
                    context,
                    type: ErrorType.info,
                    title: 'Внимание',
                    message: 'Неверный ID фрилансера',
                  );
                  return;
                }

                // 2) Преобразуем projectId
                final rawProjectId = projectFree['id'];
                final projectId = int.tryParse(rawProjectId?.toString() ?? '');
                if (projectId == null) {
                  ErrorSnackbar.show(
                    context,
                    type: ErrorType.info,
                    title: 'Внимание',
                    message: 'Неверный ID проекта',
                  );
                  return;
                }

                // 3) Всё готово, вызываем сервис
                try {
                  await FreelancerResponseService().respond(
                    token: token,
                    projectId: projectId,
                    freelancerId: freelancerId,
                  );
                  ErrorSnackbar.show(
                    context,
                    type: ErrorType.success,
                    title: 'Успешно',
                    message: 'Отклик отправлен',
                  );
                } catch (e) {
                  ErrorSnackbar.show(
                    context,
                    type: ErrorType.error,
                    title: 'Ошибка',
                    message: e.toString(),
                  );
                }
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
          Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(String? iso) {
    if (iso == null) return '';
    final dt = DateTime.tryParse(iso);
    return dt == null ? '' : DateFormat('d MMMM yyyy', 'ru').format(dt);
  }

  TextStyle _thinText() =>
      const TextStyle(fontSize: 12, color: Palette.thin, fontFamily: 'Inter');

  Widget _actionButton(
    BuildContext context,
    String label,
    Color buttonColor,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, color: Palette.white),
      ),
    );
  }
}
