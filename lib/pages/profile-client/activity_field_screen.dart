import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../component/error_snackbar.dart';
import '../../model/profile/client/client_profile_field_dto.dart';
import '../../provider/client_profile_provider.dart';
import '../../util/palette.dart';

class ActivityFieldScreen extends StatefulWidget {
  const ActivityFieldScreen({super.key});

  @override
  State<ActivityFieldScreen> createState() => _ActivityFieldScreenState();
}

class _ActivityFieldScreenState extends State<ActivityFieldScreen> {
  late TextEditingController _fieldCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final desc = context.read<ClientProfileProvider>().profile!.field.fieldDescription;
    _fieldCtrl = TextEditingController(text: desc);
  }

  @override
  void dispose() {
    _fieldCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _saving = true);
    final dto = ClientProfileField(fieldDescription: _fieldCtrl.text);
    await context.read<ClientProfileProvider>().saveField(dto);
    final err = context.read<ClientProfileProvider>().error;
    setState(() => _saving = false);
    if (err == null) {
      Navigator.pop(context);
    } else {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка',
        message: err,
      );
    }
  }

  void _cancel() => Navigator.pop(context);

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
        title: 'Сфера деятельности',
        titleStyle: TextStyle(
          fontSize: isSmallScreen ? 20 : 22,
          fontFamily: 'Inter',
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: _cancel,
        ),
        trailing: const SizedBox(width: 30),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 24,
            vertical: 16,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(height: isVerySmallScreen ? 10 : 20),
                        TextField(
                          controller: _fieldCtrl,
                          maxLines: null,
                          minLines: 1,
                          maxLength: 500,
                          decoration: InputDecoration(
                            hintText: 'Опишите вашу деятельность',
                            hintStyle: const TextStyle(
                              color: Palette.grey3,
                              fontFamily: 'Inter',
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Palette.grey3,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Palette.grey3),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isSmallScreen ? 16 : 24,
            0,
            isSmallScreen ? 16 : 24,
            isVerySmallScreen ? 10 : 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saving ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _saving
                      ? const CircularProgressIndicator(color: Palette.white)
                      : Text(
                    'Сохранить изменения',
                    style: TextStyle(
                      color: Palette.white,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              SizedBox(height: isVerySmallScreen ? 8 : 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _cancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.grey20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Отмена',
                    style: TextStyle(
                      color: Palette.black,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}