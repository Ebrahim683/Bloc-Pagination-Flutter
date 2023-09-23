import 'package:pagination_flutter/data/api/api_service.dart';

class HomeRepository {
  static Future<dynamic> getPostRepository(int page, int limit) async {
    final data = await ApiService.getApi('/posts?_page=$page&_limit=$limit');
    return data;
  }
}
