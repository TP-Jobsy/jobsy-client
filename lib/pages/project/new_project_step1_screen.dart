import 'package:flutter/material.dart';
import 'package:jobsy/util/pallete.dart';
import './new_project_step2_screen.dart';
import '../../component/progress_step_indicator.dart';

class NewProjectStep1Screen extends StatefulWidget {
  const NewProjectStep1Screen({super.key});

  @override
  State<NewProjectStep1Screen> createState() => _NewProjectStep1ScreenState();
}

class _NewProjectStep1ScreenState extends State<NewProjectStep1Screen> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  String? category;
  String? specialization;

  final categories = [
    'Разработка и IT',
    'Дизайн и креатив',
    'Маркетинг и реклама',
    'Копирайтинг и переводы',
    'Видео и аудио',
    'Финансы и бухгалтерия',
    'Бизнес и управление',
    'Инжиниринг и архитектура',
  ];

  final specializations = {
    'Разработка и IT': [
      'Веб-разработка',
      'Мобильная разработка',
      'Бэкенд / серверная часть',
      'AI / машинное обучение',
      'QA и тестирование',
      'DevOps и администрирование',
    ],
    'Дизайн и креатив': [
      'Графический дизайн',
      'UI/UX-дизайн',
      'Иллюстрация',
      '3D-моделирование и визуализация',
      'Анимация',
      'Motion Design',
      'Брендинг / айдентика',
      'Полиграфический дизайн',
    ],
    'Маркетинг и реклама': [
      'Таргетированная реклама',
      'SEO',
      'Контент-маркетинг',
      'SMM',
      'Email-маркетинг',
    ],
    'Копирайтинг и переводы': [
      'Копирайтинг',
      'Рерайтинг',
      'Технические тексты',
      'Художественные переводы',
      'Юридические переводы',
    ],
    'Видео и аудио': [
      'Монтаж видео',
      'Озвучка',
      'Звукорежиссура',
      'Музыка и композитинг',
      'Анимация и моушн',
    ],
    'Финансы и бухгалтерия': [
      'Бухгалтерия',
      'Финансовый аудит',
      'Налогообложение',
      'Финансовое планирование',
    ],
    'Бизнес и управление': [
      'Управление проектами',
      'Бизнес-аналитика',
      'Консалтинг',
      'HR и рекрутинг',
    ],
    'Инжиниринг и архитектура': [
      'Архитектурное проектирование',
      'Инженерные расчёты',
      'Чертежи и схемы',
      'CAD-моделирование',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final specOptions = category != null && specializations.containsKey(category)
        ? specializations[category]!
        : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новый проект'),
        centerTitle: true,
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
      ),
      backgroundColor: Palette.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProgressStepIndicator(totalSteps: 6, currentStep: 0),
              const SizedBox(height: 24),
              const Text(
                'Основная информация',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Заголовок',
                  hintText: 'Сформулируйте коротко суть проекта',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                validator: (val) =>
                val == null || val.isEmpty ? 'Введите заголовок' : null,
                onChanged: (val) => title = val,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: category,
                dropdownColor: Palette.white,
                decoration: const InputDecoration(
                  labelText: 'Категория',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                items: categories.map((c) {
                  return DropdownMenuItem<String>(value: c, child: Text(c));
                }).toList(),
                onChanged: (val) => setState(() {
                  category = val;
                  specialization = null;
                }),
                validator: (val) => val == null ? 'Выберите категорию' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: specialization,
                dropdownColor: Palette.white,
                decoration: const InputDecoration(
                  labelText: 'Специализация',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                items: specOptions.map((s) {
                  return DropdownMenuItem<String>(value: s, child: Text(s));
                }).toList(),
                onChanged: (val) => setState(() => specialization = val),
                validator: (val) =>
                val == null ? 'Выберите специализацию' : null,
              ),
              const Spacer(),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewProjectStep2Screen(
                                previousData: {
                                  'title': title,
                                  'category': category,
                                  'specialization': specialization,
                                },
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Продолжить',
                        style: TextStyle(color: Palette.white, fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.grey3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Назад',
                        style: TextStyle(color: Palette.white, fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
