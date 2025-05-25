import 'package:jobsy/service/api_client.dart';
import 'package:jobsy/util/routes.dart';
import '../model/category/category.dart';

class CategoryService {
  final ApiClient _api;

  CategoryService({
    required TokenGetter getToken,
    required TokenRefresher refreshToken,
    ApiClient? client,
  }) : _api =
           client ??
           ApiClient(
             baseUrl: Routes.apiBase,
             getToken: getToken,
             refreshToken: refreshToken,
           );

  Future<List<Category>> getAllCategories() {
    return _api.get<List<Category>>(
      '/categories',
      decoder:
          (json) =>
              (json as List)
                  .map((e) => Category.fromJson(e as Map<String, dynamic>))
                  .toList(),
    );
  }

  Future<Category> getCategoryById(int id) {
    return _api.get<Category>(
      '/categories/$id',
      decoder: (json) => Category.fromJson(json as Map<String, dynamic>),
    );
  }
}
