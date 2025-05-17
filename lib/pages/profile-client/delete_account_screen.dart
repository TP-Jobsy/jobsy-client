import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../util/palette.dart';
import '../../provider/client_profile_provider.dart';
import '../../util/routes.dart';




class DeleteAccountConfirmationScreen extends StatelessWidget {
  const DeleteAccountConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: const Text(
          'Удалить аккаунт',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        ),
        centerTitle: true,
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/delete_screen_confirmation.svg',
              height: 400,
            ),
            const SizedBox(height: 20),
            const Text(
              'Вы уверены, что хотите удалить свой аккаунт?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Это действие необратимо – все ваши данные, включая историю, настройки и сохраненные материалы, будут удалены без возможности восстановления.',
              style: TextStyle(
                fontSize: 14,
                color: Palette.thin,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            Column(
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
                    style: TextStyle(color: Palette.white, fontSize: 16, fontFamily: 'Inter'),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ошибка при удалении аккаунта')),
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
                    style: TextStyle(color: Palette.black, fontSize: 16, fontFamily: 'Inter'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
