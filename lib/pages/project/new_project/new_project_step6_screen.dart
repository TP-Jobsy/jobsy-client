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
  late final AiService _aiService;
  late final ProjectService _projectService;
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  bool _isAiLoading = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _aiService = context.read<AiService>();
    _projectService = context.read<ProjectService>();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _generateDescription() async {
    if (_descriptionController.text.trim().isEmpty) return;
    setState(() => _isAiLoading = true);
    try {
      final generated = await _aiService.generateDescription(
        projectId: widget.draftId,
        userPrompt: _descriptionController.text.trim(),
      );
      _descriptionController.text = generated;
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
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final updated = {
      ...widget.previousData,
      'description': _descriptionController.text.trim(),
      'paymentType': 'FIXED',
    };

    try {
      await _projectService.publishDraft(widget.draftId, updated);
      ErrorSnackbar.show(
        context,
        type: ErrorType.success,
        title: 'Успех',
        message: 'Проект опубликован',
      );
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomNavBar(
        title: '',
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Palette.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const ProgressStepIndicator(totalSteps: 6, currentStep: 5),
            const SizedBox(height: 40),
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
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    minLines: 5,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Опишите задачи, сроки, требования…',
                      contentPadding: EdgeInsets.all(12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Palette.grey3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Palette.grey3,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Palette.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Palette.red),
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
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isAiLoading ? null : _generateDescription,
                icon:
                    _isAiLoading
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Palette.primary,
                            ),
                          ),
                        )
                        : const Icon(Icons.smart_toy, color: Palette.primary),
                label: const Text(
                  'Сгенерировать AI',
                  style: TextStyle(color: Palette.primary, fontFamily: 'Inter'),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _publish,
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child:
                _isSubmitting
                    ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Palette.white),
                    )
                    : const Text(
                      'Опубликовать проект',
                      style: TextStyle(
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
