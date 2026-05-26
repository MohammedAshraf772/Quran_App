class AyahModel {
  final int number;
  final String text;
  final int page;

  AyahModel({required this.number, required this.text, required this.page});

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: json['numberInSurah'],
      text: json['text'],
      page: json['page'],
    );
  }
}
