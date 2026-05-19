import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String lastSurahKey = 'last_surah';

  static const String lastAyahKey = 'last_ayah';

  static Future<void> saveLastRead({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(lastSurahKey, surahNumber);

    await prefs.setInt(lastAyahKey, ayahNumber);
  }

  static Future<int> getLastSurah() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(lastSurahKey) ?? 1;
  }

  static Future<int> getLastAyah() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(lastAyahKey) ?? 1;
  }
}
