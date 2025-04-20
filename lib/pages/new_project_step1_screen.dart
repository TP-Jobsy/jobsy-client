import 'package:flutter/material.dart';
import 'new_project_step2_screen.dart';

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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressIndicator(),
              const SizedBox(height: 24),
              const Text(
                'Основная информация',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                dropdownColor: Colors.white,
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
                dropdownColor: Colors.white,
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
                        backgroundColor: const Color(0xFF2842F7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Продолжить',
                        style: TextStyle(color: Colors.white),
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
                        backgroundColor: Colors.grey.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Назад',
                        style: TextStyle(color: Colors.white),
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

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 32,
          height: 6,
          decoration: BoxDecoration(
            color: index == 0 ? Colors.blue : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
