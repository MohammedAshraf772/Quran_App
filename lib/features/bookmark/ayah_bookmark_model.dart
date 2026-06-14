class AyahBookmarkModel {
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String ayahText;

  AyahBookmarkModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.ayahText,
  });

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'surahName': surahName,
      'ayahText': ayahText,
    };
  }

  factory AyahBookmarkModel.fromJson(Map<String, dynamic> json) {
    return AyahBookmarkModel(
      surahNumber: json['surahNumber'],
      ayahNumber: json['ayahNumber'],
      surahName: json['surahName'],
      ayahText: json['ayahText'],
    );
  }
}
