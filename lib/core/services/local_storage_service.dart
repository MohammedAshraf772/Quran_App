import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveLastRead({
    required int surahNumber,
    required String surahName,
    required int ayahNumber,
    required int pageNumber,
    required String ayahText,
  }) async {
    await prefs.setInt('last_surah_number', surahNumber);

    await prefs.setString('last_ayah_text', ayahText);

    await prefs.setInt('last_surah_number', surahNumber);

    await prefs.setInt('last_page_number', pageNumber);

    await prefs.setString('last_ayah_text', ayahText);
  }

  static Map<String, dynamic> getLastRead() {
    return {
      'surahNumber': prefs.getInt('last_surah_number') ?? 1,

      'surahName': prefs.getString('last_surah_name') ?? 'Al-Fatihah',

      'ayahNumber': prefs.getInt('last_ayah_number') ?? 1,

      'pageNumber': prefs.getInt('last_page_number') ?? 1,

      'ayahText': prefs.getString('last_ayah_text') ?? '',
    };
  }
}
