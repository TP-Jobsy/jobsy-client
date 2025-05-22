import 'package:flutter/material.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../model/project/project_list_item.dart';
import '../../service/project_service.dart';
import '../../service/invitation_service.dart';
import '../../provider/auth_provider.dart';
import '../../util/palette.dart';

class InviteProjectScreen extends StatefulWidget {
  final int freelancerId;
  const InviteProjectScreen({Key? key, required this.freelancerId}) : super(key: key);

  @override
  State<InviteProjectScreen> createState() => _InviteProjectScreenState();
}

class _InviteProjectScreenState extends State<InviteProjectScreen> {
  late final ProjectService _projectService;
  late final InvitationService _invService;
  bool _loading = true;
  String? _error;
  List<ProjectListItem> _projects = [];

  @override
  void initState() {
    super.initState();
    _projectService = ProjectService();
    _invService = InvitationService();
    _loadOpenProjects();
  }

  Future<void> _loadOpenProjects() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final token = context.read<AuthProvider>().token;
    if (token == null) {
      setState(() {
        _error = 'Неавторизован';
        _loading = false;
      });
      return;
    }
    try {
      final page = await _projectService.fetchProjectListItems(
        status: 'OPEN',
        token: token,
        page: 0,
        size: 20,
      );
      _projects = page.content;
    } catch (e) {
      _error = 'Ошибка загрузки: $e';
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }


  Future<void> _invite(int projectId) async {
    final token = context.read<AuthProvider>().token!;
    try {
      await _invService.inviteFreelancer(
        token: token,
        projectId: projectId,
        freelancerId: widget.freelancerId,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Приглашение отправлено')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavBar(
        title: 'Выберите проект для приглашения',

      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : ListView.builder(
        itemCount: _projects.length,
        itemBuilder: (ctx, i) {
          final p = _projects[i];
          return ListTile(
            title: Text(p.title),
            subtitle: Text(p.clientCompanyName ?? ''),
            trailing: ElevatedButton(
              onPressed: () => _invite(p.id!),
              child: const Text('Пригласить'),
            ),
          );
        },
      ),
    );
  }
}