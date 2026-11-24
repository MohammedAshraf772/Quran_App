import 'package:dio/dio.dart';

class AudioService {
  final Dio _dio;

  AudioService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://api.alquran.cloud/v1/',
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
            ),
          );

  Future<List<String>> getSurahAudio(int surahNumber) async {
    final response = await _dio.get('surah/$surahNumber/ar.alafasy');
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid audio response format');
    }

    final surahData = data['data'];
    if (surahData is! Map<String, dynamic>) {
      throw const FormatException('Missing surah data in audio response');
    }

    final ayahs = surahData['ayahs'];
    if (ayahs is! List) {
      throw const FormatException('Missing ayahs list in audio response');
    }

    return ayahs
        .map((item) => item is Map<String, dynamic> ? item['audio'] : null)
        .whereType<String>()
        .where((url) => url.isNotEmpty)
        .toList();
  }
}
