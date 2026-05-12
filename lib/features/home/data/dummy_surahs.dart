import 'package:quran_app/features/quran/data/models/surah_model.dart';

final List<SurahModel> dummySurahs = List.generate(
  114,
  (index) => SurahModel(
    number: index + 1,
    name: 'سورة ${index + 1}',
    englishName: 'Surah ${index + 1}',
    verses: 7 + index,
  ),
);
