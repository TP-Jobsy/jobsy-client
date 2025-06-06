import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../../component/error_snackbar.dart';
import '../../../component/progress_step_indicator.dart';
import '../../../service/ai_service.dart';
import '../../../service/project_service.dart';
import '../../../util/palette.dart';
import '../projects_screen.dart';

class NewProjectStep6Screen extends StatefulWidget {
  final Map<String, dynamic> previousData;
  final int draftId;

  const NewProjectStep6Screen({
    Key? key,
    required this.draftId,
    required this.previousData,
  }) : super(key: key);

  @override
  State<NewProjectStep6Screen> createState() => _NewProjectStep6ScreenState();
}

class _NewProjectStep6ScreenState extends State<NewProjectStep6Screen> {
  late AiService _aiService;
  late ProjectService _projectService;
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  bool _isAiLoading = false;
  bool _isSubmitting = false;
  bool _hasInitDependencies = false;

  @override
  void initState() {
    super.initState();
    AppMetrica.reportEvent('NewProjectStepFinal_opened');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitDependencies) {
      _hasInitDependencies = true;
      _aiService = context.read<AiService>();
      _projectService = context.read<ProjectService>();
    }
  }

  Future<void> _generateDescription() async {
    AppMetrica.reportEvent('NewProjectStepFinal_generate_tap');
    if (_descriptionController.text.trim().isEmpty) return;
    setState(() => _isAiLoading = true);
    try {
      final generated = await _aiService.generateDescription(
        projectId: widget.draftId,
        userPrompt: _descriptionController.text.trim(),
      );
      _descriptionController.text = generated;
      AppMetrica.reportEvent('NewProjectStepFinal_generate_success');

    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка AI',
        message: '$e',
      );
    } finally {
      setState(() => _isAiLoading = false);
    }
  }

  Future<void> _publish() async {
    AppMetrica.reportEvent('NewProjectStepFinal_publish_tap');

    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final updated = {
      ...widget.previousData,
      'description': _descriptionController.text.trim(),
      'paymentType': 'FIXED',
    };

    try {
      await _projectService.publishDraft(widget.draftId, updated);
      AppMetrica.reportEvent('NewProjectStepFinal_published');
      ErrorSnackbar.show(
        context,
        type: ErrorType.success,
        title: 'Успех',
        message: 'Проект опубликован',
      );
      AppMetrica.reportEvent('ProjectCreated');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const ProjectsScreen()),
            (_) => false,
      );
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка публикации',
        message: '$e',
      );
    } finally {
      setState(() => _isSubmitting = false);
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
      resizeToAvoidBottomInset: true,
      appBar: CustomNavBar(
        title: '',
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: isSmallScreen ? 16 : 20,
            height: isSmallScreen ? 16 : 20,
            color: Palette.navbar,
          ),
          onPressed:
          _isSubmitting ? null : () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Palette.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 24,
          vertical: isVerySmallScreen ? 8 : 16,
        ),
        child: Column(
          children: [
            const ProgressStepIndicator(totalSteps: 6, currentStep: 5),
            SizedBox(height: isVerySmallScreen ? 20 : 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Описание проекта',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            SizedBox(height: isVerySmallScreen ? 20 : 30),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    minLines: 5,
                    maxLines: null,
                    style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                    decoration: InputDecoration(
                      hintText: 'Опишите задачи, сроки, требования…',
                      contentPadding: const EdgeInsets.all(12),
                      hintStyle: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Palette.grey3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Palette.grey3,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Palette.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Palette.red),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().length < 30) {
                        return 'Описание должно быть не менее 30 символов';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: isVerySmallScreen ? 20 : 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isAiLoading ? null : _generateDescription,
                icon: _isAiLoading
                    ? SizedBox(
                  width: 16,
                  height: 16,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Palette.primary,
                    ),
                  ),
                )
                    : const Icon(Icons.smart_toy, color: Palette.primary),
                label: Text(
                  'Сгенерировать AI',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Palette.primary,
                    fontFamily: 'Inter',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: isSmallScreen ? 12 : 14,
                  ),
                  backgroundColor: Palette.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Palette.grey3),
                    borderRadius: BorderRadius.circular(24),
                  ),
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
          isVerySmallScreen ? 12 : 20,
        ),
        child: SizedBox(
          width: double.infinity,
          height: isSmallScreen ? 45 : 50,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _publish,
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: _isSubmitting
                ? const CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation(Palette.white),
            )
                : Text(
              'Опубликовать проект',
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
}