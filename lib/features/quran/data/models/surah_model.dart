class SurahModel {
  final int number;
  final String name;
  final String englishName;
  final int ayahs;

  const SurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.ayahs,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['nomor'] ?? 0,
      name: json['nama'] ?? '',
      englishName: json['namaLatin'] ?? '',
      ayahs: json['jumlahAyat'] ?? 0,
    );
  }
}
