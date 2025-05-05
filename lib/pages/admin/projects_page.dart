import 'package:flutter/material.dart';
import 'package:jobsy/pages/admin/sidebar.dart';
import '../../service/mock_admin_service.dart';
import 'abstract_table_page.dart';
import 'project_detail_page.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbstractTablePage<ProjectDto>(
      currentSection: AdminSection.projects,
      futureList: MockAdminService.fetchProjects(),
      columns: const [
        DataColumn(label: Text('Id')),
        DataColumn(label: Text('Название проекта')),
        DataColumn(label: Text('Имя')),
        DataColumn(label: Text('Фамилия')),
        DataColumn(label: Text('Статус')),
        DataColumn(label: Text('Дата создания')),
        DataColumn(label: Text('Подробнее')),
      ],
      buildRow: (p) {
        final d = p.createdAt;
        final date =
            '${d.day.toString().padLeft(2, '0')}.'
            '${d.month.toString().padLeft(2, '0')}.'
            '${d.year}';

        return DataRow(cells: [
          DataCell(Text(p.id.toString())),
          DataCell(Text(p.title)),
          DataCell(Text(p.ownerName)),
          DataCell(Text(p.ownerLast)),
          DataCell(Text(p.status)),
          DataCell(Text(date)),
          DataCell(IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProjectDetailPage(project: p),
                ),
              );
            },
          )),
        ]);
      },
    );
  }
}
