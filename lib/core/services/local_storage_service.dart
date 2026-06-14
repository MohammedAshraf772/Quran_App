import 'dart:convert';

import 'package:quran_app/features/bookmark/ayah_bookmark_model.dart';
import 'package:quran_app/features/bookmark/bookmark_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences prefs;
  static const String bookmarksKey = 'bookmarks';

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // ================= LAST READ =================

  static Future<void> saveLastRead({
    required int surahNumber,
    required String surahName,
    required int ayahNumber,
    required int pageNumber,
    required String ayahText,
  }) async {
    await prefs.setInt('last_surah_number', surahNumber);

    await prefs.setString('last_surah_name', surahName);

    await prefs.setInt('last_ayah_number', ayahNumber);

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

  // ================= THEME =================

  static Future<void> saveTheme(bool isDark) async {
    await prefs.setBool('is_dark_mode', isDark);
  }

  static bool getTheme() {
    return prefs.getBool('is_dark_mode') ?? false;
  }

  // ================= LANGUAGE =================

  static Future<void> saveLanguage(String languageCode) async {
    await prefs.setString('language_code', languageCode);
  }

  static String getLanguage() {
    return prefs.getString('language_code') ?? 'en';
  }

  // ================= BOOKMARK =================
  static Future<void> addBookmark(BookmarkModel bookmark) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> saved = prefs.getStringList(bookmarksKey) ?? [];

    final exists = saved.any((item) {
      final data = BookmarkModel.fromJson(jsonDecode(item));

      return data.surahNumber == bookmark.surahNumber;
    });

    if (exists) return;

    saved.add(jsonEncode(bookmark.toJson()));

    await prefs.setStringList(bookmarksKey, saved);
  }

  static Future<void> removeBookmark(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> saved = prefs.getStringList(bookmarksKey) ?? [];

    saved.removeWhere((item) {
      final data = BookmarkModel.fromJson(jsonDecode(item));

      return data.surahNumber == surahNumber;
    });

    await prefs.setStringList(bookmarksKey, saved);
  }

  static Future<List<BookmarkModel>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> saved = prefs.getStringList(bookmarksKey) ?? [];

    return saved.map((item) {
      return BookmarkModel.fromJson(jsonDecode(item));
    }).toList();
  }

  static addAyahBookmark(AyahBookmarkModel ayahBookmarkModel) {}
}
