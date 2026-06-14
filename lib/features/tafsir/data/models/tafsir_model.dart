class TafsirModel {
  final String text;

  TafsirModel({required this.text});

  factory TafsirModel.fromJson(Map<String, dynamic> json) {
    return TafsirModel(text: json['text']);
  }
}
