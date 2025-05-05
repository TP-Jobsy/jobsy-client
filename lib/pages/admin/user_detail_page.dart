import 'package:flutter/material.dart';
import 'package:jobsy/pages/admin/sidebar.dart';
import '../../util/palette.dart';
import '../../widgets/avatar.dart';
import '../../service/mock_admin_service.dart';
import 'admin_layout.dart';
import 'pagination_bar.dart';
import 'project_detail_page.dart';
import 'portfolio_detail_page.dart';

class UserDetailPage extends StatefulWidget {
  final UserDto user;
  const UserDetailPage({super.key, required this.user});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late String _status;
  int _currentPage = 1;

  late final List<ProjectDto> _userProjects;
  late final List<PortfolioDto> _userPortfolio;

  bool get isClient => widget.user.role == 'CLIENT';
  int get totalPages => isClient ? 3 : 2;

  @override
  void initState() {
    super.initState();
    _status = widget.user.status;

    _userProjects = List.generate(
      5,
          (i) => ProjectDto(
        id: i + 1,
        title: 'Проект ${i + 1}',
        ownerName: 'Иван',
        ownerLast: 'Иванов',
        status: 'OPEN',
        createdAt: DateTime(2025, 3, 11),
      ),
    );

    _userPortfolio = List.generate(
      5,
          (i) => PortfolioDto(
        id: i + 1,
        projectTitle: 'Портфолио ${i + 1}',
        ownerName: 'Иван',
        ownerLast: 'Иванов',
        addedAt: DateTime(2025, 3, 5),
        position: 'Разработчик',
        specialization: 'Мобильная разработка',
        description: 'Описание проекта $i',
        level: 'Средний',
        duration: '3 мес.',
        budget: '5000₽',
        skills: 'Flutter, Dart',
        responses: 12,
        invitations: 3,
        status: 'Активна',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentSection: AdminSection.users,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 30, 50, 24),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(8),
                  child: const Icon(Icons.arrow_back_ios, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _getPageTitle(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
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
          Expanded(child: _getPageContent()),
          PaginationBar(
            currentPage: _currentPage,
            totalPages: totalPages,
            onPageChanged: (newPage) {
              setState(() => _currentPage = newPage);
            },
          ),
        ],
      ),
    );
  }

  String _getPageTitle() {
    if (_currentPage == 1) return 'Основная информация';
    if (_currentPage == 2) return isClient ? 'Проекты' : 'Проекты фрилансера';
    return 'Портфолио';
  }

  Widget _getPageContent() {
    if (_currentPage == 1) return _buildUserInfo();
    if (_currentPage == 2) return _buildProjectList(_userProjects, isPortfolio: false);
    return isClient ? _buildProjectList(_userPortfolio, isPortfolio: true) : const SizedBox.shrink();
  }

  Widget _buildUserInfo() {
    return SingleChildScrollView(
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
          _buildField('Телефон:', widget.user.phone),
          _buildField('Дата рождения:', widget.user.birthDateString),
          _buildField('Роль:', widget.user.role),
          _buildField('Город:', widget.user.city),
          _buildField('Страна:', widget.user.country),
          _buildField('Рейтинг:', widget.user.rating?.toString() ?? ''),
          _buildField('Связь:', widget.user.contact),
          _buildField('Сфера деятельности:', widget.user.field),
          _buildField('Специализация:', widget.user.specialization),
          _buildField('Опыт:', widget.user.experience),
          _buildField('О себе:', widget.user.about),
          _buildField('Навыки:', widget.user.skills),
        ],
      ),
    );
  }

  Widget _buildProjectList(List<dynamic> items, {required bool isPortfolio}) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => isPortfolio
                    ? PortfolioDetailPage(portfolio: item as PortfolioDto)
                    : ProjectDetailPage(project: item as ProjectDto),
              ),
            );
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Row(
              children: [
                Expanded(child: Text('ID: ${item.id}')),
                Expanded(
                  child: Text(isPortfolio
                      ? 'Проект: ${item.projectTitle}'
                      : 'Заголовок: ${item.title}'),
                ),
                Expanded(child: Text('Имя: ${item.ownerName}')),
                Expanded(child: Text('Фамилия: ${item.ownerLast}')),
                Expanded(
                  child: Text(isPortfolio
                      ? 'Дата добавления: ${_formatDate(item.addedAt)}'
                      : 'Дата создания: ${_formatDate(item.createdAt)}'),
                ),
                const Icon(Icons.arrow_forward_ios, size: 18),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          SizedBox(width: 150, child: Text(label, style: const TextStyle(fontSize: 16))),
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
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Palette.grey3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}.'
        '${d.month.toString().padLeft(2, '0')}.'
        '${d.year}';
  }
}
