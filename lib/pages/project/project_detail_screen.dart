import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../component/application_card.dart';
import '../../component/custom_nav_bar.dart';
import '../../component/error_snackbar.dart';
import '../../enum/project-application-status.dart';
import '../../enum/project-status.dart';
import '../../model/project/project_detail.dart';
import '../../model/project/project_application.dart';
import '../../model/profile/free/freelancer_profile_dto.dart';
import '../../provider/auth_provider.dart';
import '../../service/dashboard_service.dart';
import '../../service/freelancer_response_service.dart';
import '../../util/palette.dart';
import 'freelancer_profile_screen.dart';

class ProjectDetailScreen extends StatefulWidget {
  final int projectId;
  final ProjectStatus projectStatus;

  const ProjectDetailScreen({
    super.key,
    required this.projectId,
    required this.projectStatus,
  });

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final DashboardService _dashboardService;
  late final FreelancerResponseService _responseService;

  ProjectDetail? _detail;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _dashboardService = context.read<DashboardService>();
    _responseService = context.read<FreelancerResponseService>();

    final tabCount = widget.projectStatus == ProjectStatus.OPEN ? 3 : 1;
    _tabController = TabController(length: tabCount, vsync: this);

    _loadDetail();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final detail = await _dashboardService.getClientProjectDetail(
        widget.projectId,
      );
      setState(() => _detail = detail);
    } catch (e) {
      setState(() => _error = 'Ошибка загрузки: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _handleResponse(
    ProjectApplication app,
    ProjectApplicationStatus status,
  ) async {
    try {
      await _responseService.handleResponseStatus(
        projectId: widget.projectId,
        applicationId: app.id!,
        status: status,
      );
      await _loadDetail();
      _tabController.animateTo(2);
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: '$e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallScreen = screenHeight < 600;

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        title: 'Проект',
        titleStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: isSmallScreen ? 18 : 22,
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: isSmallScreen ? 16 : 20,
            height: isSmallScreen ? 16 : 20,
            color: Palette.navbar,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        trailing: const SizedBox(width: 35),
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : _detail == null
              ? const SizedBox.shrink()
              : Column(
                children: [
                  if (widget.projectStatus ==
                      ProjectStatus
                          .OPEN)
                    TabBar(
                      controller: _tabController,
                      indicatorColor:
                          Palette.primary,
                      labelColor:
                          Palette.black,
                      unselectedLabelColor:
                          Palette.thin,
                      tabs: [
                        Tab(
                          child: Text(
                            'Описание',
                            style: TextStyle(fontSize: isSmallScreen ? 12 : 13),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Отклики',
                            style: TextStyle(fontSize: isSmallScreen ? 12 : 13),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Приглашения',
                            style: TextStyle(fontSize: isSmallScreen ? 12 : 13),
                          ),
                        ),
                      ],
                      indicatorWeight: 2.0,
                      dividerColor: Colors.transparent,
                      labelPadding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 10 : 15,
                      ),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>((
                        Set<MaterialState> states,
                      ) {
                        return Colors.transparent;
                      }),
                    ),
                  Expanded(
                    child:
                        widget.projectStatus == ProjectStatus.OPEN
                            ? TabBarView(
                              controller: _tabController,
                              children: [
                                _buildDescriptionTab(_detail!, isSmallScreen),
                                _buildApplicationsTab(_detail!, isSmallScreen),
                                _buildInvitationsTab(_detail!, isSmallScreen),
                              ],
                            )
                            : _buildDescriptionTab(_detail!, isSmallScreen),
                  ),
                ],
              ),
    );
  }

  Widget _buildDescriptionTab(ProjectDetail detail, bool isSmallScreen) {
    final p = detail.project;
    return ListView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      children: [
        Text(
          p.title,
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        Text(p.description),
        SizedBox(height: isSmallScreen ? 16 : 24),
        _infoRow(
          'Срок выполнения:',
          _mapDuration(p.duration.name),
          isSmallScreen,
        ),
        _infoRow(
          'Бюджет:',
          '₽${p.fixedPrice.toStringAsFixed(0)}',
          isSmallScreen,
        ),
        _infoRow(
          'Сложность:',
          _mapComplexity(p.complexity.name),
          isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildApplicationsTab(ProjectDetail detail, bool isSmallScreen) {
    final responses =
        detail.responses
            .where((a) => a.status == ProjectApplicationStatus.PENDING)
            .toList();

    if (responses.isEmpty) {
      return const Center(child: Text('Нет новых откликов'));
    }

    return ListView(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
      children:
          responses.map((app) {
            final FreelancerProfile f = app.freelancer;
            return ApplicationCard(
              name: '${f.basic.firstName} ${f.basic.lastName}',
              position: f.about.specializationName ?? '',
              location: f.basic.city ?? '',
              rating: f.averageRating ?? 0.0,
              avatarUrl: f.avatarUrl ?? '',
              status: app.status.name,
              isProcessed: false,
              onAccept:
                  () => _handleResponse(app, ProjectApplicationStatus.APPROVED),
              onReject:
                  () => _handleResponse(app, ProjectApplicationStatus.DECLINED),
            );
          }).toList(),
    );
  }

  Widget _buildInvitationsTab(ProjectDetail detail, bool isSmallScreen) {
    final invites = detail.invitations;
    if (invites.isEmpty) {
      return const Center(child: Text('Нет приглашений'));
    }

    return ListView(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
      children:
          invites.map((app) {
            final FreelancerProfile f = app.freelancer;
            return GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FreelancerProfileScreen(freelancer: f),
                    ),
                  ),
              child: ApplicationCard(
                name: '${f.basic.firstName} ${f.basic.lastName}',
                position: f.about.specializationName ?? '',
                location: f.basic.city ?? '',
                rating: f.averageRating ?? 0.0,
                avatarUrl: f.avatarUrl ?? '',
                status: app.status.name,
                isProcessed: true,
                onAccept: () {},
                onReject: () {},
              ),
            );
          }).toList(),
    );
  }

  Widget _infoRow(String label, String value, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 13 : 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: isSmallScreen ? 13 : 14),
            ),
          ),
        ],
      ),
    );
  }

  String _mapDuration(String raw) {
    switch (raw) {
      case 'LESS_THAN_1_MONTH':
        return 'менее 1 месяца';
      case 'LESS_THAN_3_MONTHS':
        return 'от 1 до 3 месяцев';
      case 'LESS_THAN_6_MONTHS':
        return 'от 3 до 6 месяцев';
      default:
        return raw;
    }
  }

  String _mapComplexity(String raw) {
    switch (raw) {
      case 'EASY':
        return 'простая';
      case 'MEDIUM':
        return 'средняя';
      case 'HARD':
        return 'сложная';
      default:
        return raw;
    }
  }
}
