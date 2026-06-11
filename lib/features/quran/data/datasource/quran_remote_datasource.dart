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

    try {
      final response = await apiService.dio.get('surah');

      final List data = response.data['data'];

      await prefs.setString('cached_surahs', jsonEncode(data));

      return data.map((e) => SurahModel.fromJson(e)).toList();
    } catch (e) {
      final cachedData = prefs.getString('cached_surahs');

      if (cachedData != null) {
        final List data = jsonDecode(cachedData);

        return data.map((e) => SurahModel.fromJson(e)).toList();
      }

      rethrow;
    }
  }

  Future<List<AyahModel>> getSurahDetails(int number) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await apiService.dio.get('surah/$number/quran-uthmani');

      final List data = response.data['data']['ayahs'];

      await prefs.setString('surah_$number', jsonEncode(data));

      return data.map((e) => AyahModel.fromJson(e)).toList();
    } catch (e) {
      final cachedData = prefs.getString('surah_$number');

      if (cachedData != null) {
        final List data = jsonDecode(cachedData);

        return data.map((e) => AyahModel.fromJson(e)).toList();
      }

      rethrow;
    }
  }
}
