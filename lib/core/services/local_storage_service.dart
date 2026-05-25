import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveLastRead({
    required String surahName,
    required int ayahNumber,
  }) async {
    await prefs.setString('last_surah', surahName);

    await prefs.setInt('last_ayah', ayahNumber);
  }

  static Future<Map<String, dynamic>> getLastRead() async {
    final surahName = prefs.getString('last_surah') ?? 'Al-Fatihah';

    final ayahNumber = prefs.getInt('last_ayah') ?? 1;

    return {'surahName': surahName, 'ayahNumber': ayahNumber};
  }
}
