import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../model/project/project.dart';
import '../util/palette.dart';

class FavoritesCardProject extends StatelessWidget {
  final Project project;
  final VoidCallback onFavoriteToggle;

  const FavoritesCardProject({
    Key? key,
    required this.project,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final complexity = project.complexity.name;
    final duration = project.duration.name;
    final price = '₽${project.fixedPrice.toStringAsFixed(2)}';
    final company = project.client.basic.companyName ?? '';
    final city    = project.client.basic.city        ?? '';
    return Card(
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
                GestureDetector(
                  onTap: onFavoriteToggle,
                  child: SvgPicture.asset(
                    'assets/icons/Heart Filled.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Palette.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Text(
              'Цена: $price, сложность — $complexity, дедлайн — $duration',
              style: const TextStyle(fontSize: 13, color: Palette.thin),
            ),

            const SizedBox(height: 12),
            _buildClientInfoRow(company: company, city: city),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                DateFormat('d MMM yyyy', 'ru').format(project.createdAt),
                style: const TextStyle(fontSize: 12, color: Palette.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientInfoRow({required String company, required String city}) {
    if (company.isEmpty && city.isEmpty) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        if (company.isNotEmpty) ...[
          SvgPicture.asset('assets/icons/company.svg', width: 20, height: 20),
          const SizedBox(width: 4),
          Text(
            company,
            style: const TextStyle(fontSize: 13, color: Palette.thin),
          ),
        ],
        if (company.isNotEmpty && city.isNotEmpty) const SizedBox(width: 12),
        if (city.isNotEmpty) ...[
          SvgPicture.asset('assets/icons/location.svg', width: 20, height: 20),
          const SizedBox(width: 4),
          Text(city, style: const TextStyle(fontSize: 13, color: Palette.thin)),
        ],
      ],
    );
  }
}
