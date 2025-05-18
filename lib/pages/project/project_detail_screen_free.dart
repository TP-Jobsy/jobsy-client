import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../component/error_snackbar.dart';
import '../../model/project/projects_cubit.dart';
import '../../provider/freelancer_profile_provider.dart';
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
    final title = projectFree['title'] as String? ?? 'Без названия';
    final description =
        projectFree['description'] as String? ?? 'Описание отсутствует';
    final date = _formatDate(projectFree['createdAt'] as String?);
    final durationRaw = projectFree['duration'] as String? ?? '';
    final complexityRaw = projectFree['complexity'] as String? ?? '';
    final fixedPriceNum = projectFree['fixedPrice'] as num?;
    final fixedPrice =
        fixedPriceNum != null ? '₽${fixedPriceNum.toStringAsFixed(0)}' : '—';

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

    final clientBasic = (projectFree['client']?['basic'] as Map<String, dynamic>?) ?? {};
    final company = clientBasic['companyName'] as String?;
    final city = clientBasic['city'] as String?;
    final phone = clientBasic['phone'] as String?;
    final email = clientBasic['email'] as String?;
    final clientRating =
        projectFree['clientRating'] != null
            ? (projectFree['clientRating'] as num).toString()
            : null;

    final skills = (projectFree['skills'] as List<dynamic>?)
        ?.whereType<Map<String, dynamic>>()
        .map((s) => s['name'] as String? ?? '')
        .where((n) => n.isNotEmpty)
        .toList() ?? [];

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              Row(
                children: [
                  if (company != null && company.isNotEmpty) ...[
                    SvgPicture.asset(
                      'assets/icons/company.svg',
                      width: 16,
                      height: 16,
                      color: Palette.thin,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      company,
                      style: TextStyle(fontSize: 11, color: Palette.thin),
                    ),
                    const SizedBox(width: 16),
                  ],
                  if (city != null && city.isNotEmpty) ...[
                    SvgPicture.asset(
                      'assets/icons/location.svg',
                      width: 16,
                      height: 16,
                      color: Palette.thin,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      city,
                      style: TextStyle(fontSize: 11, color: Palette.thin),
                    ),
                    const SizedBox(width: 16),
                  ],
                  const Spacer(),
                  Text(
                    date,
                    style: TextStyle(fontSize: 11, color: Palette.thin),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 16),

              Divider(color: Palette.grey7, thickness: 0.5),
              const SizedBox(height: 16),

              const Text(
                'Описание проекта:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              Text(description, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 16),

              Divider(color: Palette.grey7, thickness: 0.5),
              const SizedBox(height: 16),

              _infoRow('Срок выполнения:', duration),
              _infoRow('Бюджет:', fixedPrice),
              _infoRow('Уровень сложности:', complexity),
              if (clientRating != null) ...[
                const SizedBox(height: 8),
                _infoRow('Оценка клиента:', clientRating),
              ],
              const SizedBox(height: 16),

              Divider(color: Palette.grey2, thickness: 0.5),
              const SizedBox(height: 16),

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
                      skills.map((name) {
                        return Chip(
                          label: Text(
                            name,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Palette.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Palette.grey2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }).toList(),
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 40,
                child: OutlinedButton(
                  onPressed: () async {
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
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Palette.sky,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    'Связаться',
                    style: TextStyle(
                      color: Palette.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
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

                    final profileProvider = context.read<FreelancerProfileProvider>();
                    final profile = profileProvider.profile;
                    if (profile == null) {
                      ErrorSnackbar.show(
                        context,
                        type: ErrorType.warning,
                        title: 'Ошибка',
                        message: 'Профиль фрилансера не загружен',
                      );
                      return;
                    }

                    final freelancerId = profile.id;
                    if (freelancerId == null || freelancerId <= 0) {
                      ErrorSnackbar.show(
                        context,
                        type: ErrorType.warning,
                        title: 'Ошибка',
                        message: 'Некорректный ID фрилансера',
                      );
                      return;
                    }

                    final projectId = int.tryParse(projectFree['id'].toString());
                    if (projectId == null) {
                      ErrorSnackbar.show(
                        context,
                        type: ErrorType.info,
                        title: 'Внимание',
                        message: 'Неверный ID проекта',
                      );
                      return;
                    }

                    try {
                      await FreelancerResponseService().respond(
                        token: token,
                        projectId: projectId,
                        freelancerId: freelancerId,
                      );

                      if (context.mounted) {
                        context.read<ProjectsCubit>().loadTab(1);
                        ErrorSnackbar.show(
                          context,
                          type: ErrorType.success,
                          title: 'Успешно',
                          message: 'Отклик отправлен',
                        );
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ErrorSnackbar.show(
                          context,
                          type: ErrorType.error,
                          title: 'Ошибка',
                          message: e.toString(),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    side: BorderSide.none,
                  ),
                  child: const Text(
                    'Откликнуться',
                    style: TextStyle(
                      color: Palette.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
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
}
