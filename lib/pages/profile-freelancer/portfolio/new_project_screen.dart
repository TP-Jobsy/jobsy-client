import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../component/custom_nav_bar.dart';
import '../../../component/error_snackbar.dart';
import '../../../model/portfolio/portfolio.dart';
import '../../../model/skill/skill.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/portfolio_skill_service.dart';
import '../../../util/palette.dart';
import '../../../util/routes.dart';
import '../../project/skill_search/skill_search_screen.dart';

class NewProjectScreen extends StatefulWidget {
  final FreelancerPortfolioDto? existing;
  const NewProjectScreen({super.key, this.existing});
  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _roleCtrl;
  late final TextEditingController _descCtrl;
  List<Skill> _skills = [];
  String? _link;
  late final PortfolioSkillService _skillService;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existing?.title);
    _roleCtrl = TextEditingController(text: widget.existing?.roleInProject);
    _descCtrl = TextEditingController(text: widget.existing?.description);
    _link = widget.existing?.projectLink;
    if (widget.existing != null) {
      _skills = List.from(widget.existing!.skills);
    }
    final auth = context.read<AuthProvider>();
    _skillService = PortfolioSkillService(
      getToken: () async {
        await auth.ensureLoaded();
        return auth.token;
      },
      refreshToken: () async {
        await auth.refreshTokens();
      },
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _roleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickSkills() async {
    final skill = await Navigator.push<Skill>(
      context,
      MaterialPageRoute(builder: (_) => const SkillSearchScreen()),
    );
    if (skill == null) return;
    if (widget.existing != null) {
      await _skillService.addSkillToPortfolio(
        widget.existing!.id,
        skill.id,
      );
    }
    setState(() {
      if (!_skills.any((s) => s.id == skill.id)) {
        _skills.add(skill);
      }
    });
  }

  Future<void> _pickLink() async {
    final link = await Navigator.pushNamed(context, Routes.linkEntry);
    if (link is String) setState(() => _link = link);
  }

  void _save() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.warning,
        title: 'Внимание',
        message: 'Название проекта обязательно',
      );
      return;
    }
    final isEdit = widget.existing != null;
    final dto = isEdit
        ? FreelancerPortfolioUpdateDto(
      title: title,
      description: _descCtrl.text.trim(),
      roleInProject: _roleCtrl.text.trim().isEmpty ? null : _roleCtrl.text.trim(),
      projectLink: _link ?? '',
      skillIds: _skills.map((s) => s.id).toList(),
    )
        : FreelancerPortfolioCreateDto(
      title: title,
      description: _descCtrl.text.trim(),
      roleInProject: _roleCtrl.text.trim().isEmpty ? null : _roleCtrl.text.trim(),
      projectLink: _link ?? '',
      skillIds: _skills.map((s) => s.id).toList(),
    );
    Navigator.of(context).pop(<dynamic>[widget.existing?.id, dto]);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

    final titleStyle = TextStyle(fontSize: isSmallScreen ? 18.0 : 22.0);
    final fieldLabelSize = isSmallScreen ? 12.0 : 14.0;
    final chipFontSize = isSmallScreen ? 10.0 : 12.0;
    final buttonHeight = isSmallScreen ? 40.0 : 50.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Palette.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isSmallScreen ? 48 : 56),
        child: CustomNavBar(
          title: widget.existing == null ? 'Добавление проекта' : 'Редактировать проект',
          titleStyle: titleStyle,
          trailing: const SizedBox(width: 24),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 24,
                  vertical: isSmallScreen ? 12 : 16,
                ),
                child: Column(
                  children: [
                    _buildField(
                      'Название проекта',
                      'Введите название',
                      _titleCtrl,
                      labelFontSize: fieldLabelSize,
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildField(
                      'Ваша роль',
                      'Введите роль',
                      _roleCtrl,
                      labelFontSize: fieldLabelSize,
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildField(
                      'Описание проекта',
                      'Введите описание',
                      _descCtrl,
                      maxLines: isSmallScreen ? 3 : 4,
                      labelFontSize: fieldLabelSize,
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildChooser(
                      label: 'Навыки',
                      child: _skills.isEmpty
                          ? Text('Выбрать навыки', style: TextStyle(fontSize: fieldLabelSize))
                          : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _skills.map((s) {
                          return InputChip(
                            label: Text(
                              s.name,
                              style: TextStyle(
                                fontSize: chipFontSize,
                                fontFamily: 'Inter',
                                color: Palette.black,
                              ),
                            ),
                            backgroundColor: Palette.white,
                            side: const BorderSide(color: Palette.grey3),
                            deleteIcon: SvgPicture.asset(
                              'assets/icons/Close.svg',
                              width: isSmallScreen ? 12 : 15,
                              height: isSmallScreen ? 12 : 15,
                              color: Palette.black,
                            ),
                            onDeleted: () => setState(
                                  () => _skills.removeWhere((e) => e.id == s.id),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }).toList(),
                      ),
                      onTap: _pickSkills,
                      labelFontSize: fieldLabelSize,
                      isSmallScreen: isSmallScreen,
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildChooser(
                      label: 'Ссылка на проект',
                      child: Text(_link ?? 'Добавить', style: TextStyle(fontSize: fieldLabelSize)),
                      onTap: _pickLink,
                      labelFontSize: fieldLabelSize,
                      isSmallScreen: isSmallScreen,
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          isSmallScreen ? 16 : 24,
          0,
          isSmallScreen ? 16 : 24,
          24,
        ),
        child: SizedBox(
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'Сохранить',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: Palette.white,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
      String label,
      String hint,
      TextEditingController ctrl, {
        double labelFontSize = 14,
        int maxLines = 1,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: labelFontSize)),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Palette.grey3, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.grey3),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChooser({
    required String label,
    required Widget child,
    required VoidCallback onTap,
    required double labelFontSize,
    required bool isSmallScreen,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: labelFontSize)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              border: Border.all(color: Palette.grey3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(child: child),
                SvgPicture.asset(
                  'assets/icons/ArrowRight.svg',
                  width: isSmallScreen ? 10 : 12,
                  height: isSmallScreen ? 10 : 12,
                  color: Palette.navbar,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}