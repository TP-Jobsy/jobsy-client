import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../component/error_snackbar.dart';
import '../../enum/project-status.dart';
import '../../model/project/project.dart';
import '../../service/project_service.dart';
import '../../service/invitation_service.dart';
import '../../util/palette.dart';

class InviteProjectScreen extends StatefulWidget {
  final int freelancerId;

  const InviteProjectScreen({Key? key, required this.freelancerId})
    : super(key: key);

  @override
  State<InviteProjectScreen> createState() => _InviteProjectScreenState();
}

class _InviteProjectScreenState extends State<InviteProjectScreen> {
  late final ProjectService _projectService;
  late final InvitationService _invService;

  bool _loading = true;
  String? _error;
  List<Project> _projects = [];
  Project? _selected;

  @override
  void initState() {
    super.initState();
    _projectService = context.read<ProjectService>();
    _invService = context.read<InvitationService>();
    _loadOpenProjects();
  }

  Future<void> _loadOpenProjects() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _projects = await _projectService.fetchMyProjects(
        status: ProjectStatus.OPEN,
      );
    } catch (e) {
      _error = 'Ошибка загрузки: $e';
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _invite() async {
    if (_selected == null) return;
    try {
      await _invService.inviteFreelancer(
        projectId: _selected!.id!,
        freelancerId: widget.freelancerId,
      );
      ErrorSnackbar.show(
        context,
        type: ErrorType.success,
        title: 'Успех',
        message: 'Приглашение отправлено',
      );
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: e.toString(),
      );
    }
  }

  void _select(Project p) {
    setState(() => _selected = p);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        title: 'Выбор проекта',
        titleStyle: const TextStyle(fontSize: 22, fontFamily: 'Inter'),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text(_error!))
            : LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            final contentWidth = isWide ? 600.0 : double.infinity;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _projects.length,
                        itemBuilder: (ctx, i) {
                          final p = _projects[i];
                          final isSel = p.id == _selected?.id;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            child: InkWell(
                              onTap: () => _select(p),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: isSel ? Palette.primary : Palette.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSel ? Palette.primary : Palette.grey3,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        p.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          color: isSel
                                              ? Palette.white
                                              : Palette.black,
                                        ),
                                      ),
                                    ),
                                    if (isSel)
                                      SvgPicture.asset(
                                        'assets/icons/Check.svg',
                                        width: 20,
                                        height: 20,
                                        color: Palette.white,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isWide ? 400 : double.infinity,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _selected != null ? _invite : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: const Text(
                              'Пригласить',
                              style: TextStyle(
                                color: Palette.white,
                                fontSize: 16,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
