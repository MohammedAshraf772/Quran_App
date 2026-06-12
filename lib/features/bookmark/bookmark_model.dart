class BookmarkModel {
  final int surahNumber;
  final String surahName;
  final String englishName;

  BookmarkModel({
    required this.surahNumber,
    required this.surahName,
    required this.englishName,
  });

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'surahName': surahName,
      'englishName': englishName,
    };
  }

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      surahNumber: json['surahNumber'],
      surahName: json['surahName'],
      englishName: json['englishName'],
    );
  }
}
