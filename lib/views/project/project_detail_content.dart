import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../component/error_snackbar.dart';
import '../../service/freelancer_response_service.dart';
import '../../util/link_utils.dart';
import '../../util/palette.dart';
import '../../viewmodels/freelancer_profile_provider.dart';

class ProjectDetailContent extends StatelessWidget {
  final Map<String, dynamic> projectFree;
  final bool showOnlyDescription;

  const ProjectDetailContent({
    Key? key,
    required this.projectFree,
    this.showOnlyDescription = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    final _responseService = context.read<FreelancerResponseService>();
    final _profileProv = context.read<FreelancerProfileProvider>();
    final contactLink = projectFree['client']?['contact']?['link'] as String?;
    final projectId = projectFree['id'] as int;
    final title = projectFree['title'] as String? ?? 'Без названия';
    final description =
        projectFree['description'] as String? ?? 'Описание отсутствует';
    final date = _formatDate(projectFree['createdAt'] as String?);
    final durationRaw = projectFree['duration'] as String? ?? '';
    final complexityRaw = projectFree['complexity'] as String? ?? '';
    final fixedPriceNum = projectFree['fixedPrice'] as num?;
    final fixedPrice =
    fixedPriceNum != null ? '₽${fixedPriceNum.toStringAsFixed(0)}' : '—';

    final duration = {
      'LESS_THAN_1_MONTH': 'менее 1 месяца',
      'LESS_THAN_3_MONTHS': 'от 1 до 3 месяцев',
      'LESS_THAN_6_MONTHS': 'от 3 до 6 месяцев',
    }[durationRaw] ?? durationRaw;

    final complexity = {
      'EASY': 'простая',
      'MEDIUM': 'средняя',
      'HARD': 'сложная',
    }[complexityRaw] ?? complexityRaw;

    final clientBasic =
        (projectFree['client']?['basic'] as Map<String, dynamic>?) ?? {};
    final company = clientBasic['companyName'] as String?;
    final city = clientBasic['city'] as String?;
    final clientRating = projectFree['clientRating'] != null
        ? (projectFree['clientRating'] as num).toString()
        : null;

    final skills = (projectFree['skills'] as List<dynamic>?)
        ?.whereType<Map<String, dynamic>>()
        .map((s) => s['name'] as String? ?? '')
        .where((n) => n.isNotEmpty)
        .toList() ??
        [];

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth < 360 ? 16 : 24,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  style: TextStyle(
                                      fontSize: 11, color: Palette.thin),
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
                                  style: TextStyle(
                                      fontSize: 11, color: Palette.thin),
                                ),
                                const SizedBox(width: 16),
                              ],
                              const Spacer(),
                              Text(
                                date,
                                style:
                                const TextStyle(fontSize: 11, color: Palette.thin),
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
                          const Divider(color: Palette.grey7, thickness: 0.5),
                          const SizedBox(height: 16),
                          const Text(
                            'Описание проекта:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(description,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 16),
                          const Divider(color: Palette.grey7, thickness: 0.5),
                          const SizedBox(height: 16),
                          _infoRow('Срок выполнения:', duration),
                          _infoRow('Бюджет:', fixedPrice),
                          _infoRow('Уровень сложности:', complexity),
                          if (clientRating != null) ...[
                            const SizedBox(height: 8),
                            _infoRow('Оценка клиента:', clientRating),
                          ],
                          const SizedBox(height: 16),
                          const Divider(color: Palette.grey2, thickness: 0.5),
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
                            const Text(
                              '— нет навыков',
                              style:
                              TextStyle(fontSize: 12, color: Palette.thin),
                            )
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: skills
                                  .map(
                                    (name) => Chip(
                                  label: Text(
                                    name,
                                    style:
                                    const TextStyle(fontSize: 12),
                                  ),
                                  backgroundColor: Palette.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Palette.grey2),
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                ),
                              )
                                  .toList(),
                            ),
                          const SizedBox(height: 24),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  if (!showOnlyDescription)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        screenWidth < 360 ? 16 : 24,
                        0,
                        screenWidth < 360 ? 16 : 24,
                        16 + MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: OutlinedButton(
                              onPressed: () =>
                                  openExternalLink(context, contactLink),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Palette.sky,
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: const Text(
                                'Связаться',
                                style: TextStyle(
                                  color: Palette.white,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () async {
                                final freelancerId = _profileProv.profile?.id;
                                if (freelancerId == null) {
                                  ErrorSnackbar.show(
                                    context,
                                    type: ErrorType.error,
                                    title: 'Ошибка',
                                    message: 'Вам нужно зайти в аккаунт',
                                  );
                                  return;
                                }
                                AppMetrica.reportEvent('ProjectDetailScreen_apply_tap');
                                try {
                                  await _responseService.respond(
                                    projectId: projectId,
                                    freelancerId: freelancerId,
                                  );
                                  AppMetrica.reportEvent('ProjectDetailScreen_apply_success');
                                  ErrorSnackbar.show(
                                    context,
                                    type: ErrorType.success,
                                    title: 'Успех',
                                    message: 'Вы откликнулись на проект',
                                  );
                                } catch (e) {
                                  ErrorSnackbar.show(
                                    context,
                                    type: ErrorType.error,
                                    title: 'Ошибка',
                                    message: 'Не удалось откликнуться: $e',
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Palette.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
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
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text('$label ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
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
}