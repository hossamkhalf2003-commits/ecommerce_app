import 'package:dio/dio.dart';
import '../../../core/networking/api_endpoints.dart';
import 'product_model.dart';


class ProductRepository {
  final Dio _dio = Dio();

  // 1. Rename to getProducts and add the optional named parameter
  Future<List<ProductModel>> getProducts({int? categoryId}) async {
    try {
      // 2. The URL logic: 
      // If a categoryId is passed, append it to the endpoint.
      // If categoryId is null, just use the base products endpoint.
      final String url = categoryId != null 
          ? '${ApiEndpoints.products}/?categoryId=$categoryId' 
          : ApiEndpoints.products;

      final response = await _dio.get(url);
      
      final List<dynamic> jsonData = response.data;
      return jsonData.map((json) => ProductModel.fromJson(json)).toList();
      
    } on DioException catch (e) {
      // ignore: avoid_print
      print(  'Error fetching products: ${e.message}');
      throw 'Failed to load products. Please check your connection.';
    } catch (e) {
      throw 'An unexpected error occurred while loading products.';
    }
  }
}