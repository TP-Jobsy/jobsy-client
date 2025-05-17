import 'package:flutter/material.dart';
import 'package:jobsy/pages/admin/sidebar.dart';
import '../../service/mock_admin_service.dart';
import 'admin_layout.dart';
import '../../util/palette.dart';

class PortfolioDetailPage extends StatelessWidget {
  final PortfolioDto portfolio;

  const PortfolioDetailPage({super.key, required this.portfolio});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentSection: AdminSection.portfolio,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(60, 40, 60, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios, size: 20),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Основная информация',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    'Активна',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildField('Название проекта:', portfolio.projectTitle),
            _buildField('Должность:', portfolio.position),
            _buildField('Специализация:', portfolio.specialization),
            _buildField('Описание:', portfolio.description),
            _buildField('Уровень сложности:', portfolio.level),
            _buildField('Срок выполнения:', portfolio.duration),
            _buildField('Сумма:', portfolio.budget),
            _buildField('Навыки:', portfolio.skills),
            _buildField('Отклики:', portfolio.responses.toString()),
            _buildField('Приглашения:', portfolio.invitations.toString()),
            _buildField('Дата создания:', _formatDate(portfolio.addedAt)),
            _buildField('Статус:', portfolio.status),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 180, child: Text(label, style: const TextStyle(fontSize: 16))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              readOnly: true,
              controller: TextEditingController(text: value),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Palette.grey3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Palette.grey3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }
}