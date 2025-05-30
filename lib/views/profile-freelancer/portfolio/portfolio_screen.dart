import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../component/custom_nav_bar.dart';
import '../../../component/error_snackbar.dart';
import '../../../component/project_card_portfolio.dart';
import '../../../model/portfolio/portfolio.dart';
import '../../../model/skill/skill.dart';
import '../../../service/portfolio_service.dart';
import '../../../service/portfolio_skill_service.dart';
import '../../../util/palette.dart';
import '../../../viewmodels/auth_provider.dart';
import 'new_project_screen.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  late final PortfolioService _portfolioService;
  late final PortfolioSkillService _portfolioSkillService;
  List<FreelancerPortfolioDto> _projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _portfolioService = PortfolioService(
      getToken: () async {
        await auth.ensureLoaded();
        return auth.token;
      },
      refreshToken: () async {
        await auth.refreshTokens();
      },
    );
    _portfolioSkillService = PortfolioSkillService(
      getToken: () async {
        await auth.ensureLoaded();
        return auth.token;
      },
      refreshToken: () async {
        await auth.refreshTokens();
      },
    );
    _loadPortfolio();
  }

  Future<void> _loadPortfolio() async {
    try {
      final list = await _portfolioService.fetchPortfolio();
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
    try {
      await _portfolioService.createPortfolio(createDto);
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
    final result = await Navigator.push<List<dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => NewProjectScreen(existing: existing)),
    );
    if (result == null) return;
    final id = result[0] as int;
    final updateDto = result[1] as FreelancerPortfolioUpdateDto;
    final token = context.read<AuthProvider>().token!;
    try {
      await _portfolioService.updatePortfolio(id, updateDto);
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
    try {
      await _portfolioService.deletePortfolio(id);
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
    final p = _projects[pIndex];
    try {
      await _portfolioSkillService.removeSkillFromPortfolio(p.id, skill.id);
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Palette.white,
      body: Column(
        children: [
          CustomNavBar(
            title: 'Портфолио',
            titleStyle: TextStyle(
              fontSize: isSmallScreen ? 20 : 22,
              fontWeight: FontWeight.bold,
            ),
            trailing: GestureDetector(
              onTap: _onAdd,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 6.0 : 8.0),
                child: SvgPicture.asset(
                  'assets/icons/Add.svg',
                  width: isSmallScreen ? 18 : 20,
                  height: isSmallScreen ? 18 : 20,
                  color: Palette.grey1,
                ),
              ),
            ),
          ),
          Expanded(
            child: _projects.isEmpty
                ? _buildEmpty(isSmallScreen, isMediumScreen)
                : _buildList(isSmallScreen, isMediumScreen),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(bool isSmallScreen, bool isMediumScreen) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/DrawKit9.svg',
              height: isSmallScreen ? 250 : (isMediumScreen ? 350 : 400),
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            Text(
              'У вас нет проектов в портфолио',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 24 : 48,
              ),
              child: Text(
                'Нажмите "+" чтобы создать первый',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: Palette.thin,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(bool isSmallScreen, bool isMediumScreen) {
    final paddingValue = isSmallScreen ? 12.0 : 16.0;
    final spacing = isSmallScreen ? 8.0 : 12.0;

    return ListView.separated(
      padding: EdgeInsets.all(paddingValue),
      itemCount: _projects.length,
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (context, i) {
        final p = _projects[i];
        return ProjectCardPortfolio(
          title: p.title,
          description: p.description,
          link: p.projectLink,
          skills: p.skills,
          isCompact: isSmallScreen,
          onRemoveSkill: (skill) => _onRemoveSkill(i, skill),
          onTapLink: () async {
            final link = p.projectLink?.trim();
            if (link == null || link.isEmpty) {
              ErrorSnackbar.show(
                context,
                type: ErrorType.error,
                title: 'Ошибка',
                message: 'Ссылка не указана',
              );
              return;
            }
            final uri = Uri.tryParse(link);
            if (uri == null) {
              ErrorSnackbar.show(
                context,
                type: ErrorType.error,
                title: 'Ошибка',
                message: 'Неверный формат ссылки',
              );
              return;
            }
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
                      leading: SvgPicture.asset(
                        'assets/icons/Edit.svg',
                        color: Palette.grey3,
                        width: isSmallScreen ? 18 : 24,
                        height: isSmallScreen ? 18 : 24,
                      ),
                      title: Text(
                        'Редактировать',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                      onTap: () => Navigator.pop(context, 'edit'),
                    ),
                    ListTile(
                      leading: SvgPicture.asset(
                        'assets/icons/Delete.svg',
                        width: isSmallScreen ? 18 : 24,
                        height: isSmallScreen ? 18 : 24,
                      ),
                      title: Text(
                        'Удалить проект',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                      onTap: () => Navigator.pop(context, 'delete'),
                    ),
                  ],
                ),
              ),
            );
            if (action == 'edit') {
              _onEdit(i);
            } else if (action == 'delete') {
              _onDeleteProject(p.id, i);
            }
          },
        );
      },
    );
  }
}