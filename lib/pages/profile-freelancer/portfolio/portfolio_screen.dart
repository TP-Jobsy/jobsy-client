import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../component/error_snackbar.dart';
import '../../../component/project_card_portfolio.dart';
import '../../../model/portfolio.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/portfolio_service.dart';
import '../../../util/palette.dart';
import 'new_project_screen.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final _portfolioService = PortfolioService();
  List<FreelancerPortfolioDto> _projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPortfolio();
  }

  Future<void> _loadPortfolio() async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;
    try {
      final list = await _portfolioService.fetchPortfolio(token);
      setState(() => _projects = list);
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка загрузки',
        message: e.toString(),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onAdd() async {
    final createDto = await Navigator.push<FreelancerPortfolioCreateDto>(
      context,
      MaterialPageRoute(builder: (_) => const NewProjectScreen()),
    );
    if (createDto == null) return;

    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    try {
      final created = await _portfolioService.createPortfolio(token, createDto);
      setState(() => _projects.add(created));
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка создания',
        message: e.toString(),
      );
    }
  }

  Future<void> _onDelete(int id, int index) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    try {
      await _portfolioService.deletePortfolio(id, token);
      setState(() => _projects.removeAt(index));
    } catch (e) {
      ErrorSnackbar.show(
        context,
        type: ErrorType.error,
        title: 'Ошибка удаления',
        message: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        backgroundColor: Palette.white,
        elevation: 0,
        leading: BackButton(color: Palette.black),
        centerTitle: true,
        title: const Text(
          'Портфолио',
          style: TextStyle(
            fontWeight: FontWeight.w400,
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
          SvgPicture.asset('assets/DrawKit9.svg', height: 300),
          const SizedBox(height: 24),
          const Text(
            'У вас нет проектов в портфолио',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Нажмите "Добавить", чтобы создать первый',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14, color: Palette.thin, fontFamily: 'Inter'),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _projects.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final p = _projects[i];
        return ProjectCardPorfolio(
          title: p.title,
          description: p.description,
          link: p.projectLink,
          onTapLink: () {
          },
          onMore: () {
            showModalBottomSheet(
              context: context,
              builder: (_) => SafeArea(
                child: Wrap(children: [
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Удалить'),
                    onTap: () {
                      Navigator.pop(context);
                      _onDelete(p.id!, i);
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