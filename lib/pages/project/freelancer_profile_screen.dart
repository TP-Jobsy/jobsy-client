import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../util/palette.dart';

class FreelancerProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Извлекаем данные, переданные через аргументы с проверкой на null
    final Map<String, dynamic>? args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return const Center(child: Text('Ошибка загрузки данных профиля'));
    }

    final name = args['name'] ?? 'Не указано';
    final position = args['position'] ?? 'Не указана';
    final location = args['location'] ?? 'Не указано';
    final avatarUrl = args['avatarUrl'] ?? '';  // Заглушка, если URL не передан
    final rating = args['rating'] ?? 0.0;
    final description = args['description'] ?? 'Описание отсутствует';
    final skills = List<String>.from(args['skills'] ?? []);
    final experience = args['experience'] ?? 'Не указан';
    final country = args['country'] ?? 'Не указана';

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: const Text('Профиль'),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: avatarUrl.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(
                  avatarUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              )
                  : SvgPicture.asset('assets/icons/avatar.svg'),  // Заглушка, если нет URL
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    position,
                    style: const TextStyle(fontSize: 16, color: Palette.secondary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/location.svg', width: 17, height: 17, color: Palette.thin),
                      const SizedBox(width: 8),
                      Text(location, style: const TextStyle(fontSize: 14, color: Palette.secondary)),
                      const SizedBox(width: 16),
                      SvgPicture.asset('assets/icons/star.svg', width: 17, height: 17, color: Palette.thin),
                      const SizedBox(width: 8),
                      Text('$rating', style: const TextStyle(fontSize: 14, color: Palette.secondary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Описание фрилансера
            const Text(
              'О себе:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Palette.black),
            ),
            const SizedBox(height: 16),
            // Опыт работы и страна
            _infoRow('Опыт:', experience),
            _infoRow('Страна:', country),
            const SizedBox(height: 16),
            // Навыки фрилансера
            const Text(
              'Навыки:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills
                  .map(
                    (skill) => Chip(
                  label: Text(skill),
                  backgroundColor: Palette.blue2,
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
      // Размещение кнопок внизу экрана
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16), // Отступы вокруг кнопок
          child: Column(
            mainAxisSize: MainAxisSize.min, // Чтобы кнопки не занимали лишнее пространство
            children: [
              // Кнопка "Связаться"
              OutlinedButton(
                onPressed: () {
                  // Логика для связи с фрилансером
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Palette.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(346, 38), // Ширина 346px, высота 38px
                ),
                child: const Text(
                  'Связаться',
                  style: TextStyle(color: Palette.primary, fontSize: 16),
                ),
              ),
              const SizedBox(height: 16), // Добавляем пространство между кнопками
              // Кнопка "Пригласить"
              ElevatedButton(
                onPressed: () {
                  // Логика для приглашения фрилансера
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(346, 38), // Ширина 346px, высота 38px
                ),
                child: const Text(
                  'Пригласить',
                  style: TextStyle(color: Palette.white, fontSize: 16),
                ),
              ),
            ],
          ),
        )



    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
          Expanded(child: Text(value, style: const TextStyle(fontFamily: 'Inter'))),
        ],
      ),
    );
  }
}
