class SurahModel {
  final int number;

  final String name;

  final String englishName;

  final String englishNameTranslation;

  final int ayahs;

  SurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.ayahs,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] ?? 0,

      name: json['name'] ?? '',

      englishName: json['englishName'] ?? '',

      englishNameTranslation: json['englishNameTranslation'] ?? '',

      ayahs: json['numberOfAyahs'] ?? 0,
    );
  }
}
