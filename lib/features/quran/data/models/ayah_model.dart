class AyahModel {
  final int number;
  final String text;

  AyahModel({required this.number, required this.text});

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(number: json['numberInSurah'], text: json['text']);
  }
}
