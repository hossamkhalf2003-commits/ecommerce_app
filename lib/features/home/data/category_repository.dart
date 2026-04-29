import 'package:dio/dio.dart';
import '../../../core/networking/api_endpoints.dart';
import 'category_model.dart';

class CategoryRepository {
  final Dio _dio = Dio();

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(ApiEndpoints.categories);
      final List<dynamic> data = response.data;
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      throw 'Failed to load categories';
    }
  }
}