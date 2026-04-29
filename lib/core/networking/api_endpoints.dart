class ApiEndpoints {
  static const String baseUrl = 'https://api.escuelajs.co/api/v1';
  
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/users/'; // Note the trailing slash
  static const String profile = '$baseUrl/auth/profile'; 
  static const String products = '$baseUrl/products';
  static const String categories = '$baseUrl/categories';
}