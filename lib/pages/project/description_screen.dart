import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../model/project/project_detail.dart';
import '../../provider/auth_provider.dart';
import '../../service/dashboard_service.dart';
import '../../util/palette.dart';

class DescriptionScreen extends StatefulWidget {
  final int projectId;

  const DescriptionScreen({super.key, required this.projectId});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  final _dashboardService = DashboardService();

  late String _token;
  ProjectDetail? _detail;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _token = context.read<AuthProvider>().token!;
      _loadDetail();
    });
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final detail = await _dashboardService.getClientProjectDetail(
        /// TODO
        /// НАДО НА ФРИЛАНСЕРА ПОМЕНЯТЬ
        token: _token,
        projectId: widget.projectId,
      );
      setState(() => _detail = detail);
    } catch (e) {
      setState(() => _error = 'Ошибка загрузки: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        title: const Text('Проект', style: TextStyle(fontFamily: 'Inter')),
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _detail == null
          ? const SizedBox.shrink()
          : _buildDescriptionTab(_detail!),
    );
  }

  Widget _buildDescriptionTab(ProjectDetail detail) {
    final p = detail.project;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          p.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(p.description),
        const SizedBox(height: 24),
        _infoRow('Срок выполнения:', _mapDuration(p.duration.name)),
        _infoRow('Бюджет:', '₽${p.fixedPrice.toStringAsFixed(0)}'),
        _infoRow('Сложность:', _mapComplexity(p.complexity.name)),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _mapDuration(String raw) {
    switch (raw) {
      case 'LESS_THAN_1_MONTH':
        return 'Менее 1 месяца';
      case 'LESS_THAN_3_MONTHS':
        return 'От 1 до 3 месяцев';
      case 'LESS_THAN_6_MONTHS':
        return 'От 3 до 6 месяцев';
      default:
        return raw;
    }
  }

  String _mapComplexity(String raw) {
    switch (raw) {
      case 'EASY':
        return 'Простой';
      case 'MEDIUM':
        return 'Средний';
      case 'HARD':
        return 'Сложный';
      default:
        return raw;
    }
  }
}