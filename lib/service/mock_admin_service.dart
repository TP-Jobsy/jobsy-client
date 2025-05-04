class MockAdminService {
  static Future<List<UserDto>> fetchUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(5, (i) => UserDto(
      id: i + 1,
      firstName: 'Имя${i+1}',
      lastName: 'Фамилия${i+1}',
      role: i % 2 == 0 ? 'CLIENT' : 'FREELANCER',
      status: i % 2 == 0 ? 'Активна' : 'Неактивна',
      registeredAt: DateTime(2025, 3, 10 + i),
    ));
  }

  static Future<List<ProjectDto>> fetchProjects() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(5, (i) => ProjectDto(
      id: i + 1,
      title: 'Проект №${i+1}',
      ownerName: 'Имя${i+1}',
      ownerLast: 'Фамилия${i+1}',
      status: i % 2 == 0 ? 'OPEN' : 'CLOSED',
      createdAt: DateTime(2025, 3, 5 + i),
    ));
  }

  static Future<List<PortfolioDto>> fetchPortfolios() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.generate(5, (i) => PortfolioDto(
      id: i + 1,
      projectTitle: 'Портфолио Проект №${i+1}',
      ownerName: 'Имя${i+1}',
      ownerLast: 'Фамилия${i+1}',
      addedAt: DateTime(2025, 2, 20 + i),
    ));
  }
}

class UserDto {
  final int id;
  final String firstName, lastName, role, status;
  final DateTime registeredAt;
  UserDto({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.status,
    required this.registeredAt,
  });
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
  final String projectTitle, ownerName, ownerLast;
  final DateTime addedAt;
  PortfolioDto({
    required this.id,
    required this.projectTitle,
    required this.ownerName,
    required this.ownerLast,
    required this.addedAt,
  });
}