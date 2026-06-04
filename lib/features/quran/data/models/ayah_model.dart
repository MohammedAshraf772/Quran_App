class AyahModel {
  final int number;
  final String text;
  final int page;
  final int juz;

  AyahModel({
    required this.number,
    required this.text,
    required this.page,
    required this.juz,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: json['numberInSurah'],
      text: json['text'],
      page: json['page'],
      juz: json['juz'],
    );
  }
}
