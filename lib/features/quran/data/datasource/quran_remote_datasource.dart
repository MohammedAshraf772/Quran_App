import 'package:quran_app/core/network/api_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ayah_model.dart';
import '../models/surah_model.dart';

class QuranRemoteDataSource {
  final ApiService apiService;

  QuranRemoteDataSource(this.apiService);

  Future<List<SurahModel>> getSurahs() async {
    final prefs = await SharedPreferences.getInstance();

    final cachedSurahs = prefs.getString('all_surahs');

    if (cachedSurahs != null) {
      final List data = jsonDecode(cachedSurahs);

      return data.map((e) => SurahModel.fromJson(e)).toList();
    }

    final response = await apiService.dio.get('surah');

    final List data = response.data['data'];

    await prefs.setString('all_surahs', jsonEncode(data));

    return data.map((e) => SurahModel.fromJson(e)).toList();
  }

  Future<List<AyahModel>> getSurahDetails(int number) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await apiService.dio.get('surah/$number/quran-uthmani');

      final List data = response.data['data']['ayahs'];

      await prefs.setString('surah_$number', jsonEncode(data));

      return data.map((e) => AyahModel.fromJson(e)).toList();
    } catch (e) {
      final cachedSurah = prefs.getString('surah_$number');

      if (cachedSurah != null) {
        final List data = jsonDecode(cachedSurah);

        return data.map((e) => AyahModel.fromJson(e)).toList();
      }

      rethrow;
    }
  }

  Future<String> getTafsir(int surahNumber, int ayahNumber) async {
    final response = await apiService.dio.get(
      'ayah/$surahNumber:$ayahNumber/ar.muyassar',
    );

    return response.data['data']['text'];
  }
}
