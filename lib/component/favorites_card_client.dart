import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../model/project/project_list_item.dart';
import '../util/palette.dart';

class FavoritesCardClient extends StatelessWidget {
  final ProjectListItem project;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onTap;

  const FavoritesCardClient({
    super.key,
    required this.project,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final rawComplexity = project.projectComplexity;
    final rawDuration = project.projectDuration;
    final complexity = _localizeComplexity(rawComplexity);
    final duration = _localizeDuration(rawDuration);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: Palette.white,
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 8),
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
                      project.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Palette.primary,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onFavoriteToggle,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        isFavorite
                            ? 'assets/icons/Heart Filled.svg'
                            : 'assets/icons/Heart Outlined.svg',
                        width: 20,
                        height: 20,
                        color: Palette.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Цена: ₽${project.fixedPrice.toStringAsFixed(2)}, '
                'Сложность — $complexity, '
                'Срок — $duration',
                style: const TextStyle(fontSize: 13, color: Palette.thin),
              ),
              const SizedBox(height: 12),
              _buildClientInfoRow(
                company: project.clientCompanyName ?? '',
                city: project.clientCity ?? '',
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  DateFormat('d MMM yyyy', 'ru').format(project.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Palette.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClientInfoRow({required String company, required String city}) {
    if (company.isEmpty && city.isEmpty) return const SizedBox.shrink();
    return Row(
      children: [
        if (company.isNotEmpty) ...[
          SvgPicture.asset('assets/icons/company.svg', width: 15, height: 15),
          const SizedBox(width: 4),
          Text(
            company,
            style: const TextStyle(fontSize: 13, color: Palette.thin),
          ),
        ],
        if (company.isNotEmpty && city.isNotEmpty) const SizedBox(width: 12),
        if (city.isNotEmpty) ...[
          SvgPicture.asset('assets/icons/location.svg', width: 15, height: 15),
          const SizedBox(width: 4),
          Text(city, style: const TextStyle(fontSize: 13, color: Palette.thin)),
        ],
      ],
    );
  }

  String _localizeComplexity(String code) {
    switch (code) {
      case 'EASY':
        return 'простая';
      case 'MEDIUM':
        return 'средняя';
      case 'HARD':
        return 'сложная';
      default:
        return code;
    }
  }

  String _localizeDuration(String code) {
    switch (code) {
      case 'LESS_THAN_1_MONTH':
        return 'менее 1 месяца';
      case 'LESS_THAN_3_MONTHS':
        return 'от 1 до 3 месяцев';
      case 'LESS_THAN_6_MONTHS':
        return 'от 3 до 6 месяцев';
      default:
        return code;
    }
  }
}
