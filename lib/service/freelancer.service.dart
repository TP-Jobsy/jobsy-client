import '../model/freelancer.dart';

class FreelancerService {
  // Пример для получения списка фрилансеров
  Future<List<Freelancer>> getAllFreelancers() async {
    // Здесь используйте свой API для получения фрилансеров
    // Это просто пример с фиктивными данными
    await Future.delayed(const Duration(seconds: 1));

    return [
      Freelancer(
        name: 'Иван Иванов',
        position: 'Программист',
        location: 'Москва',
        rating: 4.9,
        avatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
      ),
      Freelancer(
        name: 'Мария Петрова',
        position: 'Дизайнер',
        location: 'Санкт-Петербург',
        rating: 4.7,
        avatarUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
      ),
    ];
  }
}
