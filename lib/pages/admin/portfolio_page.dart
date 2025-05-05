import 'package:flutter/material.dart';
import 'package:jobsy/pages/admin/sidebar.dart';
import '../../service/mock_admin_service.dart';
import 'abstract_table_page.dart';
import 'portfolio_detail_page.dart'; // импорт страницы деталей

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbstractTablePage<PortfolioDto>(
      currentSection: AdminSection.portfolio,
      futureList: MockAdminService.fetchPortfolios(),
      columns: const [
        DataColumn(label: Text('Id')),
        DataColumn(label: Text('Проект')),
        DataColumn(label: Text('Имя')),
        DataColumn(label: Text('Фамилия')),
        DataColumn(label: Text('Дата добавления')),
        DataColumn(label: Text('Подробнее')),
      ],
      buildRow: (pf) {
        final d = pf.addedAt;
        final date =
            '${d.day.toString().padLeft(2, '0')}.'
            '${d.month.toString().padLeft(2, '0')}.'
            '${d.year}';

        return DataRow(cells: [
          DataCell(Text(pf.id.toString())),
          DataCell(Text(pf.projectTitle)),
          DataCell(Text(pf.ownerName)),
          DataCell(Text(pf.ownerLast)),
          DataCell(Text(date)),
          DataCell(IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PortfolioDetailPage(portfolio: pf),
                ),
              );
            },
          )),
        ]);
      },
    );
  }
}
