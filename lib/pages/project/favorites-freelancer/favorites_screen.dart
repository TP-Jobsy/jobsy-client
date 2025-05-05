import 'package:flutter/material.dart';
import 'package:jobsy/component/favorites_card_client.dart';
import 'package:provider/provider.dart';
import '../../../component/error_snackbar.dart';
import '../../../model/project/project.dart';
import '../../../provider/auth_provider.dart';
import '../../../service/favorite_service.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late FavoriteService _favService;
  late String _token;
  List<Project> _favorites = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _favService = context.read<FavoriteService>();
    _token      = context.read<AuthProvider>().token!;
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final list = await _favService.fetchFavoriteProjects(_token);
      setState(() {
        _favorites = list;
        _loading   = false;
      });
    } catch (e) {
      setState(() {
        _error   = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('Ошибка: $_error'));
    }
    if (_favorites.isEmpty) {
      return Center(
        child: Text(
          'У вас нет избранных проектов',
          style: TextStyle(color: Colors.grey[600], fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favorites.length,
      itemBuilder: (ctx, i) {
        final proj = _favorites[i];
        return FavoritesCardProject(
          project: proj,
          isFavorite: true,
          onFavoriteToggle: () async {
            try {
              await _favService.removeFavoriteProject(proj.id, _token);
              setState(() => _favorites.removeAt(i));
            } catch (e) {
              ErrorSnackbar.show(
                context,
                type: ErrorType.error,
                title: 'Ваша роль не поддерживается',
                message: e.toString(),
              );
            }
          },
        );
      },
    );
  }
}