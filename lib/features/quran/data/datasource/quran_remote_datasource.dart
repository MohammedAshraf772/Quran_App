import 'package:dio/dio.dart';

import '../models/ayah_model.dart';
import '../models/surah_model.dart';

class QuranRemoteDataSource {
  final Dio dio;

  QuranRemoteDataSource(this.dio);

  Future<List<SurahModel>> getSurahs() async {
    final response = await dio.get('https://api.alquran.cloud/v1/surah');

    final List data = response.data['data'];

    return data.map((e) {
      return SurahModel.fromJson(e);
    }).toList();
  }

  Future<List<AyahModel>> getSurahDetails(int number) async {
    final response = await dio.get(
      'https://api.alquran.cloud/v1/surah/$number',
    );

    final List ayahs = response.data['data']['ayahs'];

    return ayahs.map((e) {
      return AyahModel.fromJson(e);
    }).toList();
  }
}
