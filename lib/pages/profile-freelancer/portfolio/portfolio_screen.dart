import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../component/custom_nav_bar.dart';
import '../../../component/error_snackbar.dart';
import '../../../component/project_card_portfolio.dart';
import '../../../model/portfolio/portfolio.dart';
import '../../../model/skill/skill.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/portfolio_service.dart';
import '../../../service/portfolio_skill_service.dart';
import '../../../util/palette.dart';
import 'new_project_screen.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final _portfolioService      = PortfolioService();
  final _portfolioSkillService = PortfolioSkillService();
  List<FreelancerPortfolioDto> _projects   = [];
  bool                        _isLoading  = true;

  @override
  void initState() {
    super.initState();
    _loadPortfolio();
  }

  Future<void> _loadPortfolio() async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;
    try {
      final list = await _portfolioService.fetchPortfolio(token);
      setState(() => _projects = list);
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка загрузки',
        message: e.toString(),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onAdd() async {
    final result = await Navigator.push<List<dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const NewProjectScreen()),
    );
    if (result == null) return;
    final createDto = result[1] as FreelancerPortfolioCreateDto;
    final token     = context.read<AuthProvider>().token!;
    try {
      await _portfolioService.createPortfolio(token, createDto);
      await _loadPortfolio();
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка создания',
        message: e.toString(),
      );
    }
  }

  Future<void> _onEdit(int index) async {
    final existing = _projects[index];
    final result   = await Navigator.push<List<dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => NewProjectScreen(existing: existing)),
    );
    if (result == null) return;
    final id        = result[0] as int;
    final updateDto = result[1] as FreelancerPortfolioUpdateDto;
    final token     = context.read<AuthProvider>().token!;
    try {
      await _portfolioService.updatePortfolio(token, id, updateDto);
      await _loadPortfolio();
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка редактирования',
        message: e.toString(),
      );
    }
  }

  Future<void> _onDeleteProject(int id, int index) async {
    final token = context.read<AuthProvider>().token!;
    try {
      await _portfolioService.deletePortfolio(id, token);
      setState(() => _projects.removeAt(index));
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка удаления',
        message: e.toString(),
      );
    }
  }

  Future<void> _onRemoveSkill(int pIndex, Skill skill) async {
    final p     = _projects[pIndex];
    final token = context.read<AuthProvider>().token!;
    try {
      await _portfolioSkillService.removeSkillFromPortfolio(p.id!, skill.id, token);
      setState(() => p.skills.removeWhere((s) => s.id == skill.id));
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка удаления навыка',
        message: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Palette.white,
      body: Column(
        children: [
          CustomNavBar(
            title: 'Портфолио',
            trailing: GestureDetector(
              onTap: _onAdd,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/Add.svg',
                  width: 20,
                  height: 20,
                  color: Palette.grey1,
                ),
              ),
            ),
          ),
          Expanded(
            child: _projects.isEmpty ? _buildEmpty() : _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/DrawKit9.svg', height: 400),
          const SizedBox(height: 24),
          const Text(
            'У вас нет проектов в портфолио',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Нажмите "+" чтобы создать первый',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Palette.thin,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _projects.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final p = _projects[i];
        return ProjectCardPortfolio(
          title: p.title,
          description: p.description,
          link: p.projectLink,
          skills: p.skills,
          onRemoveSkill: (skill) => _onRemoveSkill(i, skill),
          onTapLink: () async {
            final uri = Uri.parse(p.projectLink);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              ErrorSnackbar.show(
                context,
                type: ErrorType.error,
                title: 'Ошибка',
                message: 'Не удалось открыть ссылку',
              );
            }
          },
          onMore: () async {
            final action = await showModalBottomSheet<String>(
              context: context,
              backgroundColor: Palette.white,
              builder: (_) => SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: SvgPicture.asset('assets/icons/Edit.svg', color: Palette.grey3),
                      title: const Text('Редактировать'),
                      onTap: () => Navigator.pop(context, 'edit'),
                    ),
                    ListTile(
                      leading: SvgPicture.asset('assets/icons/Delete.svg'),
                      title: const Text('Удалить проект'),
                      onTap: () => Navigator.pop(context, 'delete'),
                    ),
                  ],
                ),
              ),
            );
            if (action == 'edit') {
              _onEdit(i);
            } else if (action == 'delete') {
              _onDeleteProject(p.id!, i);
            }
          },
        );
      },
    );
  }
}