import 'package:flutter/material.dart';
import 'package:jobsy/pages/admin/sidebar.dart';
import 'admin_layout.dart';

class AbstractTablePage<T> extends StatelessWidget {
  final AdminSection currentSection;
  final Future<List<T>> futureList;
  final List<DataColumn> columns;
  final DataRow Function(T) buildRow;

  const AbstractTablePage({
    super.key,
    required this.currentSection,
    required this.futureList,
    required this.columns,
    required this.buildRow,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: futureList,
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Ошибка: ${snap.error}'));
        }
        final items = snap.data ?? [];

        return AdminLayout(
          currentSection: currentSection,
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (ctx, constraints) {
                final availableWidth = constraints.maxWidth;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: availableWidth),
                    child: DataTable(
                      columnSpacing: 24,
                      horizontalMargin: 12,
                      dataRowHeight: 56,
                      dividerThickness: 1,
                      columns: columns,
                      rows: items.map(buildRow).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}