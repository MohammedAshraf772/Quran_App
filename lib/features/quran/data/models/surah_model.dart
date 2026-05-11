class SurahModel {
  final int number;
  final String name;
  final String englishName;
  final int verses;

  const SurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.verses,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      verses: json['numberOfAyahs'],
    );
  }
}
