import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import '../../util/palette.dart';
import '../../provider/auth_provider.dart';
import '../../service/client_project_service.dart';
import 'project_detail_content.dart';

class ProjectDetailScreenFreeById extends StatefulWidget {
  final int projectId;
  const ProjectDetailScreenFreeById({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  @override
  _ProjectDetailScreenFreeByIdState createState() =>
      _ProjectDetailScreenFreeByIdState();
}

class _ProjectDetailScreenFreeByIdState
    extends State<ProjectDetailScreenFreeById> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _projectFree;

  @override
  void initState() {
    super.initState();
    _fetchProject();
  }

  Future<void> _fetchProject() async {
    final token = context.read<AuthProvider>().token;
    if (token == null) {
      setState(() {
        _error = 'Не авторизованы';
        _isLoading = false;
      });
      return;
    }

    try {
      final service = context.read<ClientProjectService>();
      final project = await service.getProjectById(
        token: token,
        projectId: widget.projectId,
      );
      setState(() {
        _projectFree = project.toJson();
      });
    } catch (e) {
      setState(() {
        _error = 'Ошибка загрузки: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        title: 'Проект',
        titleStyle: const TextStyle(fontFamily: 'Inter', fontSize: 22),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : ProjectDetailContent(projectFree: _projectFree!),
    );
  }
}