import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import '../../component/error_snackbar.dart';
import '../../util/palette.dart';
import '../../util/routes.dart';
import '../../viewmodels/client_profile_provider.dart';

class DeleteAccountConfirmationScreenFree extends StatelessWidget {
  const DeleteAccountConfirmationScreenFree({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        title: 'Удалить аккаунт',
        titleStyle: TextStyle(
          fontSize: screenWidth < 360 ? 20 : 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth < 360 ? 16 : 24,
                      vertical: 16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SvgPicture.asset(
                              'assets/delete_screen_confirmation.svg',
                              height: isSmallScreen ? screenHeight * 0.35 : 400,
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 20),
                            Text(
                              'Вы уверены, что хотите удалить свой аккаунт?',
                              style: TextStyle(
                                fontSize: screenWidth < 360 ? 18 : 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: isSmallScreen ? 8 : 10),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth < 360 ? 8 : 0,
                              ),
                              child: Text(
                                'Это действие необратимо – все ваши данные, включая историю, настройки и сохраненные материалы, будут удалены без возможности восстановления.',
                                style: TextStyle(
                                  fontSize: screenWidth < 360 ? 13 : 14,
                                  color: Palette.thin,
                                  fontFamily: 'Inter',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: isSmallScreen ? 16 : 32,
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Palette.grey3),
                                    minimumSize: const Size.fromHeight(50),
                                    backgroundColor: Palette.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: const Text(
                                    'Отмена',
                                    style: TextStyle(
                                      color: Palette.white,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final provider = context.read<ClientProfileProvider>();
                                    try {
                                      await provider.deleteAccount();
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        Routes.auth,
                                            (route) => false,
                                      );
                                    } catch (e) {
                                      ErrorSnackbar.show(
                                        context,
                                        type: ErrorType.error,
                                        title: 'Ошибка при удалении аккаунта',
                                        message: '$e',
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Palette.grey20,
                                    minimumSize: const Size.fromHeight(50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: const Text(
                                    'Подтвердить',
                                    style: TextStyle(
                                      color: Palette.black,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}