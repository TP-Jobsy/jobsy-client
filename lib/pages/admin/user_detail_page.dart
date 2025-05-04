import 'package:flutter/material.dart';
import 'package:jobsy/pages/admin/sidebar.dart';
import '../../util/palette.dart';
import '../../widgets/avatar.dart';
import '../../service/mock_admin_service.dart';
import 'admin_layout.dart';
import 'pagination_bar.dart';

class UserDetailPage extends StatefulWidget {
  final UserDto user;
  const UserDetailPage({super.key, required this.user});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late String _status;
  int _currentPage = 1;
  final int _totalPages = 3;

  @override
  void initState() {
    super.initState();
    _status = widget.user.status;
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentSection: AdminSection.users,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(60, 36, 50, 24),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(8),
                  child: const Icon(Icons.arrow_back_ios, size: 20),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Основная информация',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
                DropdownButton<String>(
                  value: _status,
                  underline: const SizedBox(),
                  items: ['Активна', 'Неактивна']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _status = v);
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(60, 0, 50, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Avatar(
                      url: widget.user.avatarUrl,
                      size: 90,
                      placeholderAsset: 'assets/icons/avatar.svg',
                    ),
                  ),
                  const SizedBox(height: 40),

                  _buildField('Имя:', widget.user.firstName),
                  _buildField('Фамилия:', widget.user.lastName),
                  _buildField('Почта:', widget.user.email),
                  _buildField('Номер телефона:', widget.user.phone),
                  _buildField('Дата рождения:', widget.user.birthDateString),
                  _buildField('Роль:', widget.user.role),
                  _buildField('Страна:', widget.user.country),
                  _buildField('Город:', widget.user.city),
                  _buildField('Рейтинг:', widget.user.rating?.toString() ?? ''),
                  _buildField('Связь:', widget.user.contact),
                  _buildField('Сфера деятельности:', widget.user.field),
                  _buildField('Специализация:', widget.user.specialization),
                  _buildField('Опыт:', widget.user.experience),
                  _buildField('О себе:', widget.user.about),
                  _buildField('Навыки:', widget.user.skills),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          PaginationBar(
            currentPage: _currentPage,
            totalPages: _totalPages,
            onPageChanged: (newPage) {
              setState(() => _currentPage = newPage);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String initial) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          SizedBox(width: 150, child: Text(label, style: const TextStyle(fontSize: 16))),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: initial),
              decoration: InputDecoration(
                hintText: 'Текст',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Palette.grey3),
                ),
                enabledBorder: OutlineInputBorder(
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
}