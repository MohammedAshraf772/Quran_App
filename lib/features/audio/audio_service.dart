import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://api.alquran.cloud/v1/'));

  Future<String> getSurahAudio(int surahNumber) async {
    final response = await dio.get('surah/$surahNumber/ar.alafasy');

    debugPrint(response.data.toString());

    return response.data['data']['ayahs'][0]['audio'];
  }
}
