import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';
import '../model/category/category.dart';

class CategoryService {
  final ApiClient _api;

  CategoryService({ApiClient? client})
      : _api = client ?? ApiClient(baseUrl: Routes.apiBase);

  Future<List<Category>> getAllCategories(String token) {
    return _api.get<List<Category>>(
      '/categories',
      token: token,
      decoder: (json) => (json as List)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<Category> getCategoryById(int id, String token) {
    return _api.get<Category>(
      '/categories/$id',
      token: token,
      decoder: (json) => Category.fromJson(json as Map<String, dynamic>),
    );
  }
}