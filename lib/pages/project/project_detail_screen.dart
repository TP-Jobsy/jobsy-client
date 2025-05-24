import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../component/application_card.dart';
import '../../component/custom_nav_bar.dart';
import '../../component/error_snackbar.dart';
import '../../enum/project-application-status.dart';
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

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _dashboardService = DashboardService();
  final _responseService = FreelancerResponseService();

  late String _token;
  ProjectDetail? _detail;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<AuthProvider>().token;
      if (token != null) {
        _token = token;
        _loadDetail();
      } else {
        setState(() {
          _error = 'Ошибка: токен не найден';
          _loading = false;
        });
      }
    });
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
        token: _token,
        projectId: widget.projectId,
      );
      setState(() => _detail = detail);
    } catch (e) {
      setState(() => _error = 'Ошибка загрузки: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _handleResponse(
      ProjectApplication app, ProjectApplicationStatus status) async {
    try {
      await _responseService.handleResponseStatus(
        token: _token,
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
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        title: 'Проект',
        titleStyle: const TextStyle(fontFamily: 'Inter', fontSize: 22),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        trailing: const SizedBox(width: 35),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _detail == null
          ? const SizedBox.shrink()
          : Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Palette.primary,
            labelColor: Palette.black,
            unselectedLabelColor: Palette.thin,
            tabs: const [
              Tab(child: Text('Описание', style: TextStyle(fontSize: 17))),
              Tab(child: Text('Отклики', style: TextStyle(fontSize: 17))),
              Tab(child: Text('Приглашения', style: TextStyle(fontSize: 17))),
            ],
            indicatorWeight: 2.0,
            dividerColor: Colors.transparent,
            labelPadding: EdgeInsets.symmetric(horizontal: 15),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDescriptionTab(_detail!),
                _buildApplicationsTab(_detail!),
                _buildInvitationsTab(_detail!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionTab(ProjectDetail detail) {
    final p = detail.project;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          p.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(p.description),
        const SizedBox(height: 24),
        _infoRow('Срок выполнения:', _mapDuration(p.duration.name)),
        _infoRow('Бюджет:', '₽${p.fixedPrice.toStringAsFixed(0)}'),
        _infoRow('Сложность:', _mapComplexity(p.complexity.name)),
      ],
    );
  }

  Widget _buildApplicationsTab(ProjectDetail detail) {
    final responses = detail.responses
        .where((a) => a.status == ProjectApplicationStatus.PENDING)
        .toList();

    if (responses.isEmpty) {
      return const Center(child: Text('Нет новых откликов'));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: responses.map((app) {
        final FreelancerProfile f = app.freelancer;
        return ApplicationCard(
          name: '${f.basic.firstName} ${f.basic.lastName}',
          position: f.about.specializationName ?? '',
          location: f.basic.city ?? '',
          rating: f.averageRating ?? 0.0,
          avatarUrl: f.avatarUrl ?? '',
          status: app.status.name,
          isProcessed: false,
          onAccept: () => _handleResponse(app, ProjectApplicationStatus.APPROVED),
          onReject: () => _handleResponse(app, ProjectApplicationStatus.DECLINED),
        );
      }).toList(),
    );
  }

  Widget _buildInvitationsTab(ProjectDetail detail) {
    final invites = detail.invitations;
    if (invites.isEmpty) {
      return const Center(child: Text('Нет приглашений'));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: invites.map((app) {
        final FreelancerProfile f = app.freelancer;
        return GestureDetector(
          onTap: () => Navigator.push(
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
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
