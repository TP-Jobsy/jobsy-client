class MockAdminService {
  static Future<List<UserDto>> fetchUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(5, (i) {
      final isClient = i % 2 == 0;
      return UserDto(
        id: i + 1,
        firstName: 'Имя${i + 1}',
        lastName: 'Фамилия${i + 1}',
        role: isClient ? 'CLIENT' : 'FREELANCER',
        status: isClient ? 'Активна' : 'Неактивна',
        registeredAt: DateTime(2025, 3, 10 + i),
        avatarUrl: 'https://i.pravatar.cc/150?img=${i + 1}',
        email: 'user${i + 1}@example.com',
        phone: '+7 900 000 0${i + 10}',
        birthDate: DateTime(1990, 1 + (i % 12), 10 + i),
        country: 'Страна${i + 1}',
        city: 'Город${i + 1}',
        rating: 4.0 + i * 0.2,
        contact: 'telegram${i + 1}',
        field: 'Сфера${i + 1}',
        specialization: 'Спец${i + 1}',
        experience: '${1 + i} год(а)',
        about: 'Немного текста о пользователе №${i + 1}',
        skills: 'SkillA, SkillB, SkillC',
      );
    });
  }

  static Future<List<ProjectDto>> fetchProjects() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(5, (i) {
      return ProjectDto(
        id: i + 1,
        title: 'Проект №${i + 1}',
        ownerName: 'Имя${i + 1}',
        ownerLast: 'Фамилия${i + 1}',
        status: i % 2 == 0 ? 'OPEN' : 'CLOSED',
        createdAt: DateTime(2025, 3, 5 + i),
      );
    });
  }

  static Future<List<PortfolioDto>> fetchPortfolios() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(5, (i) {
      return PortfolioDto(
        id: i + 1,
        projectTitle: 'Портфолио Проект №${i + 1}',
        ownerName: 'Имя${i + 1}',
        ownerLast: 'Фамилия${i + 1}',
        addedAt: DateTime(2025, 2, 20 + i),
        position: 'Разработчик',
        specialization: 'Специализация ${i + 1}',
        description: 'Описание портфолио проекта №${i + 1}',
        level: 'Средний',
        duration: '${3 + i} мес.',
        budget: '${1000 + i * 500}₽',
        skills: 'Flutter, Dart, Firebase',
        responses: 10 + i,
        invitations: 2 + i,
        status: 'Активна',
      );
    });
  }
}
class UserDto {
  final int id;
  final String firstName, lastName, role, status;
  final DateTime registeredAt;
  final String avatarUrl;
  final String email;
  final String phone;
  final DateTime birthDate;
  final String country;
  final String city;
  final double rating;
  final String contact;
  final String field;
  final String specialization;
  final String experience;
  final String about;
  final String skills;

  UserDto({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.status,
    required this.registeredAt,
    required this.avatarUrl,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.country,
    required this.city,
    required this.rating,
    required this.contact,
    required this.field,
    required this.specialization,
    required this.experience,
    required this.about,
    required this.skills,
  });

  String get birthDateString {
    final d = birthDate;
    return '${d.day.toString().padLeft(2, '0')}.'
        '${d.month.toString().padLeft(2, '0')}.'
        '${d.year}';
  }
}

class ProjectDto {
  final int id;
  final String title, ownerName, ownerLast, status;
  final DateTime createdAt;

  ProjectDto({
    required this.id,
    required this.title,
    required this.ownerName,
    required this.ownerLast,
    required this.status,
    required this.createdAt,
  });
}

class PortfolioDto {
  final int id;
  final String projectTitle;
  final String ownerName;
  final String ownerLast;
  final DateTime addedAt;
  final String position;
  final String specialization;
  final String description;
  final String level;
  final String duration;
  final String budget;
  final String skills;
  final int responses;
  final int invitations;
  final String status;

  PortfolioDto({
    required this.id,
    required this.projectTitle,
    required this.ownerName,
    required this.ownerLast,
    required this.addedAt,
    required this.position,
    required this.specialization,
    required this.description,
    required this.level,
    required this.duration,
    required this.budget,
    required this.skills,
    required this.responses,
    required this.invitations,
    required this.status,
  });
}
