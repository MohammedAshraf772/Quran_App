import 'package:flutter/widgets.dart';
import 'package:quran_app/core/network/api_service.dart';

import '../models/ayah_model.dart';
import '../models/surah_model.dart';

class QuranRemoteDataSource {
  final ApiService apiService;

  QuranRemoteDataSource(this.apiService);

  Future<List<SurahModel>> getSurahs() async {
    final response = await apiService.dio.get('surah');

    final List data = response.data['data'];

    return data.map((e) {
      return SurahModel.fromJson(e);
    }).toList();
  }

  Future<List<AyahModel>> getSurahDetails(int number) async {
    final response = await apiService.dio.get('surah/$number/quran-uthmani');
    debugPrint(response.data.toString());
    final List data = response.data['data']['ayahs'];

    return data.map((e) {
      return AyahModel.fromJson(e);
    }).toList();
  }
}
