import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveLastRead({
    required String surahName,
    required int ayahNumber,
    required int pageNumber,
  }) async {
    await prefs.setString('last_surah', surahName);

    await prefs.setInt('last_ayah', ayahNumber);

    await prefs.setInt('last_page', pageNumber);
  }

  static Map<String, dynamic> getLastRead() {
    return {
      'surahName': prefs.getString('last_surah') ?? 'Al-Fatihah',

      'ayahNumber': prefs.getInt('last_ayah') ?? 1,

      'pageNumber': prefs.getInt('last_page') ?? 1,
    };
  }
}
