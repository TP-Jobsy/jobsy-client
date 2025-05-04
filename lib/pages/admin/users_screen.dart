import 'package:flutter/material.dart';
import 'package:jobsy/pages/admin/sidebar.dart';
import '../../service/mock_admin_service.dart';
import 'abstract_table_page.dart';
import 'user_detail_page.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbstractTablePage<UserDto>(
      currentSection: AdminSection.users,
      futureList: MockAdminService.fetchUsers(),
      columns: const [
        DataColumn(label: Text('Id')),
        DataColumn(label: Text('Имя')),
        DataColumn(label: Text('Фамилия')),
        DataColumn(label: Text('Роль')),
        DataColumn(label: Text('Статус')),
        DataColumn(label: Text('Дата регистрации')),
        DataColumn(label: Text('Подробнее')),
      ],
      buildRow: (u) {
        final d = u.registeredAt;
        final date =
            '${d.day.toString().padLeft(2,'0')}.'
            '${d.month.toString().padLeft(2,'0')}.'
            '${d.year}';
        return DataRow(cells: [
          DataCell(Text(u.id.toString())),
          DataCell(Text(u.firstName)),
          DataCell(Text(u.lastName)),
          DataCell(Text(u.role)),
          DataCell(Text(u.status)),
          DataCell(Text(date)),
          DataCell(IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => UserDetailPage(user: u),
                  ),
              );
            },
          )),
        ]);
      },
    );
  }
}