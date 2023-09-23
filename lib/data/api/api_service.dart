import 'package:dio/dio.dart' as dio;

class ApiService {
  ApiService();

  static String baseUrl = 'https://jsonplaceholder.typicode.com';
  static final _dio = dio.Dio();

  static Future<dynamic> getApi(String path) async {
    try {
      final response = await _dio.get(baseUrl + path);
      return Future.value(response.data);
    } catch (e) {
      print('api error ============> $e');
      return Future.error(e);
    }
  }
}
