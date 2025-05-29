import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import '../../util/palette.dart';
import '../../provider/auth_provider.dart';
import '../../service/client_project_service.dart';
import 'project_detail_content.dart';

class ProjectDetailScreenFreeById extends StatefulWidget {
  final int projectId;
  final bool showOnlyDescription;

  const ProjectDetailScreenFreeById({
    Key? key,
    required this.projectId,
    this.showOnlyDescription = false,
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

  late final ClientProjectService _service;

  @override
  void initState() {
    super.initState();
    _service = context.read<ClientProjectService>();
    _fetchProject();
  }

  Future<void> _fetchProject() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final project = await _service.getProjectById(widget.projectId);
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
          : ProjectDetailContent(
        projectFree: _projectFree!,
        showOnlyDescription: widget.showOnlyDescription,
      ),
    );
  }
}