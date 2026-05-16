import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();

  Future<Response> get(String url) async {
    return await dio.get(url);
  }
}
