import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<void> saveLastRead({
    required int surahNumber,
    required int ayahNumber,
    required String surahName,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('last_surah_number', surahNumber);

    await prefs.setInt('last_ayah_number', ayahNumber);

    await prefs.setString('last_surah_name', surahName);
  }

  static Future<Map<String, dynamic>> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'surahNumber': prefs.getInt('last_surah_number') ?? 1,

      'ayahNumber': prefs.getInt('last_ayah_number') ?? 1,

      'surahName': prefs.getString('last_surah_name') ?? 'Al-Fatihah',
    };
  }
}
