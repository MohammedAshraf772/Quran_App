import 'package:dio/dio.dart';

class AudioService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://api.alquran.cloud/v1/'));

  Future<List<String>> getSurahAudio(int surahNumber) async {
    final response = await dio.get('surah/$surahNumber/ar.alafasy');

    final ayahs = response.data['data']['ayahs'];

    return ayahs.map<String>((e) => e['audio'] as String).toList();
  }
}
