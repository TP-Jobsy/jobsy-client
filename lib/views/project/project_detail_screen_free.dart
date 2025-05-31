import 'package:flutter/material.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import '../../util/palette.dart';
import 'project_detail_content.dart';

class ProjectDetailScreenFree extends StatelessWidget {
  final Map<String, dynamic> projectFree;
  final bool showOnlyDescription;

  const ProjectDetailScreenFree({
    Key? key,
    required this.projectFree,
    this.showOnlyDescription = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        title: 'Проект',
        titleStyle: const TextStyle(fontFamily: 'Inter', fontSize: 22),
      ),
      body: ProjectDetailContent(
        projectFree: projectFree,
        showOnlyDescription: showOnlyDescription,
      ),
    );
  }
}