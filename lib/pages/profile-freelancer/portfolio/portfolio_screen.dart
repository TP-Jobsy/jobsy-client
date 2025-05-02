import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobsy/component/project_card_portfolio.dart';

import '../../../util/palette.dart';
import '../../../util/routes.dart';


class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  List<Map<String, String>> _projects = [];

  void _onAdd() async {
    final result = await Navigator.pushNamed(context, Routes.newProject);
    if (result != null && result is Map<String, String>) {
      setState(() {
        _projects.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        backgroundColor: Palette.white,
        elevation: 0,
        leading: BackButton(color: Palette.black),
        title: const Text(
          'Портфолио',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: Palette.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Palette.primary),
            onPressed: _onAdd,
          ),
        ],
      ),
      body: _projects.isEmpty ? _buildEmpty() : _buildList(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/DrawKit9.svg', height: 400),
          const SizedBox(height: 24),
          const Text(
            'У вас нет никаких проектов\nв портфолио',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Нажмите "Добавить", чтобы начать!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
            ),
            child: const Text('Добавить', style: TextStyle(color: Palette.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      itemCount: _projects.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final p = _projects[i];
        return ProjectCardPorfolio(
          title: p['title'] ?? '',
          description: p['description'] ?? '',
          link: p['link'] ?? '',
          onTapLink: () {
              // url_launcher.launch(p['link']!);
            // например, открытие url_launcher.launch(p['link']!)
          },
          onMore: () {
            // тут можно реализовать редактирование или удаление:
            showModalBottomSheet(
              context: context,
              builder: (_) => SafeArea(
                child: Wrap(children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Редактировать'),
                    onTap: () {
                      Navigator.pop(context);
                      // при желании: Navigator.pushNamed(...).then(...)
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Удалить'),
                    onTap: () {
                      setState(() => _projects.removeAt(i));
                      Navigator.pop(context);
                    },
                  ),
                ]),
              ),
            );
          },
        );
      },
    );
  }
}