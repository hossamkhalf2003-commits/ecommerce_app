import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/networking/api_endpoints.dart';
import 'user_model.dart';

class AuthRepository {
  final Dio _dio = Dio();
  final SharedPreferences _prefs; // 1. Add this

  AuthRepository(this._prefs); // 2. Require it in constructor

  // Job 1: Log in and return ONLY the token
  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      
      final token = response.data['access_token'];
      
      // 3. Save the token to the hard drive!
      await _prefs.setString('auth_token', token);
      
      return token; 

    } on DioException catch (e) {
      final errorData = e.response?.data;
      if (errorData is Map && errorData.containsKey('message')) {
        throw errorData['message']; 
      } else {
        throw 'Login failed. Please check your credentials.';
      }
    } catch (e) {
      throw 'An unexpected error occurred.';
    }
  }

  // Job 2: Use the token to fetch and return the UserModel
  Future<UserModel> getUserProfile(String token) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.profile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw 'Failed to load profile. Please try logging in again.';
    }
  }

  // Job 3: Logout
  Future<void> logout() async {
    await _prefs.remove('auth_token');
  }
}