import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../util/palette.dart'; // Подключите палитру цветов
import '../../../model/freelancer.dart'; // Модель данных для фрилансеров
import '../../../component/freelancer_card.dart';
import '../../service/freelancer.service.dart'; // Компонент для отображения карточки фрилансера

class FreelancerSearchScreen extends StatefulWidget {
  const FreelancerSearchScreen({super.key});

  @override
  State<FreelancerSearchScreen> createState() => _FreelancerSearchScreenState();
}

class _FreelancerSearchScreenState extends State<FreelancerSearchScreen> {
  final _searchController = TextEditingController();
  bool _isLoading = true;
  String? _error;
  List<Freelancer> _freelancers = [];

  @override
  void initState() {
    super.initState();
    _loadFreelancers();  // Загружаем всех фрилансеров при инициализации
  }

  Future<void> _loadFreelancers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Получаем список фрилансеров через сервис
      final freelancers = await FreelancerService().getAllFreelancers();
      setState(() {
        _freelancers = freelancers;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearch() {
    final searchText = _searchController.text.toLowerCase();
    if (searchText.isNotEmpty) {
      setState(() {
        _freelancers = _freelancers
            .where((freelancer) =>
        freelancer.name.toLowerCase().contains(searchText) ||
            freelancer.position.toLowerCase().contains(searchText))
            .toList();
      });
    } else {
      _loadFreelancers();  // Если поиск пустой, показываем всех
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: const Text('Поиск фрилансеров'),
        backgroundColor: Palette.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.black,
          ),
          onPressed: () {
            Navigator.pop(context); // Возвращаемся на предыдущий экран
          },
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: Palette.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Palette.dotInactive),
                boxShadow: [
                  BoxShadow(
                    color: Palette.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  SvgPicture.asset(
                    'assets/icons/Search.svg',
                    width: 16,
                    height: 16,
                    color: Palette.black,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Поиск фрилансера',
                        hintStyle: TextStyle(color: Palette.grey3),
                        border: InputBorder.none,
                      ),
                      onChanged: (_) => _onSearch(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text('Ошибка загрузки: $_error'));
    }

    if (_freelancers.isEmpty) {
      return const Center(child: Text('Нет фрилансеров'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _freelancers.length,
      itemBuilder: (ctx, i) {
        final freelancer = _freelancers[i];
        return FreelancerCard(
          name: freelancer.name,
          position: freelancer.position,
          location: freelancer.location,
          rating: freelancer.rating,
          avatarUrl: freelancer.avatarUrl,
          onTap: () {
            // Логика для перехода на страницу профиля фрилансера
            Navigator.pushNamed(
              context,
              '/freelancerProfile',
              arguments: freelancer,  // Передаем фрилансера на страницу профиля
            );
          },
        );
      },
    );
  }
}
