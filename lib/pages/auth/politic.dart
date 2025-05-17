import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../util/palette.dart';

class PoliticScreen extends StatelessWidget {
  const PoliticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Политика и условия',
          style: TextStyle(
            color: Palette.black,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24), // Добавлен отступ снизу
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Пользовательское соглашение',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Используя это приложение, вы соглашаетесь соблюдать условия использования. '
                    'Вы обязуетесь предоставлять достоверную информацию при регистрации и не нарушать '
                    'законодательство РФ и других стран при использовании приложения.',
                style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
              ),
              SizedBox(height: 24),
              Text(
                'Политика конфиденциальности',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 8),
              Text(
                '1. Какие данные мы собираем?\n\n'
                    '1.1. Данные, предоставляемые вами:\n'
                    '- Регистрационная информация: имя, фамилия, электронная почта, номер телефона, дата рождения\n'
                    '- Профиль фрилансера/заказчика: специализация, навыки, портфолио, отзывы, рейтинг, опыт работы\n'
                    '1.2. Данные, собираемые автоматически:\n'
                    '- Техническая информация: IP-адрес, тип устройства, версия ОС\n'
                    '- Данные использования: история действий, поисковые запросы, время сеансов\n\n'
                    '2. Как мы используем ваши данные?\n'
                    '- Для предоставления и улучшения функционала Сервиса\n'
                    '- Для связи с вами (уведомления, поддержка, важные обновления)\n'
                    '- Для анализа поведения пользователей\n'
                    '- Для защиты от мошенничества и злоупотреблений\n\n'
                    '3. Кому мы передаем данные?\n'
                    '- Другим пользователям: ваш профиль виден в рамках Сервиса\n'
                    '- По закону: если требуется судом или государственными органами\n\n'
                    '4. Как мы защищаем ваши данные?\n'
                    '- Используем шифрование (SSL/TLS)\n'
                    '- Ограничиваем доступ к данным\n'
                    '- Регулярно обновляем меры безопасности\n\n'
                    '5. Ваши права\n'
                    '- Запросить доступ, исправление или удаление данных\n'
                    '- Удалить аккаунт через настройки профиля\n\n'
                    '6. Изменения в политике\n'
                    'Мы можем обновлять эту политику. О значимых изменениях сообщим через уведомления.\n\n'
                    '7. Контакты\n'
                    'По вопросам конфиденциальности: support@example.com',
                style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
              ),
              SizedBox(height: 24),
              Text(
                'Связь с нами',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Если у вас возникли вопросы по поводу условий или политики конфиденциальности, '
                    'вы можете связаться с нами по электронной почте support@example.com.',
                style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}