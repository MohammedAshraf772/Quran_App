class AyahModel {
  final int number;
  final String arabicText;

  const AyahModel({required this.number, required this.arabicText});

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(number: json['nomorAyat'], arabicText: json['teksArab']);
  }
}
