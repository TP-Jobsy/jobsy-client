import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../util/palette.dart';
import '../../provider/client_profile_provider.dart';
import '../../util/routes.dart';




class DeleteAccountConfirmationScreen extends StatelessWidget {
  const DeleteAccountConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);  // Возврат на предыдущий экран
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            // Пространство для иконки
            Expanded(
              child: Image.asset(
                'assets/delete_screen_confirmation.svg',  // Путь к изображению
                fit: BoxFit.contain,
                width: double.infinity,
              ),
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

            // Кнопки для подтверждения или отмены
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);  // Отменить удаление
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Palette.grey3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Отмена',
                      style: TextStyle(color: Palette.black, fontSize: 16, fontFamily: 'Inter'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Вызов метода для удаления аккаунта
                      final provider = context.read<ClientProfileProvider>();
                      try {
                        await provider.deleteAccount();  // Удаление аккаунта
                        // После удаления аккаунта, перенаправим пользователя на экран входа
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.auth,  // Переход на экран аутентификации
                              (route) => false,
                        );
                      } catch (e) {
                        // Обработка ошибки
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ошибка при удалении аккаунта')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Подтвердить',
                      style: TextStyle(color: Palette.white, fontSize: 16, fontFamily: 'Inter'),
                    ),
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
