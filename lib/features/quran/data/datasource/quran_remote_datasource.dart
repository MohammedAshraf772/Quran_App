import '../../../../core/network/api_service.dart';
import '../models/surah_model.dart';
import '../models/ayah_model.dart';

class QuranRemoteDataSource {
  final ApiService apiService;

  QuranRemoteDataSource(this.apiService);

  Future<List<SurahModel>> getSurahs() async {
    final response = await apiService.dio.get('surat');

    final List data = response.data['data'];

    return data.map((e) {
      return SurahModel(
        number: e['nomor'],
        name: e['nama'],
        englishName: e['namaLatin'],
        verses: e['jumlahAyat'],
      );
    }).toList();
  }

  Future<List<AyahModel>> getSurahDetails(int surahNumber) async {
    final response = await apiService.dio.get('surat/$surahNumber');

    final List verses = response.data['data']['ayat'];

    return verses.map((e) {
      return AyahModel.fromJson(e);
    }).toList();
  }
}
