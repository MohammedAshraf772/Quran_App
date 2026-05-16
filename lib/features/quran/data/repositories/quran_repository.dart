import '../datasource/quran_remote_datasource.dart';
import '../models/surah_model.dart';

class QuranRepository {
  final QuranRemoteDataSource remoteDataSource;

  QuranRepository(this.remoteDataSource);

  Future<List<SurahModel>> getSurahs() async {
    final data = await remoteDataSource.getSurahs();

    return data.map<SurahModel>((e) {
      return SurahModel.fromJson(e);
    }).toList();
  }

  Future<List<dynamic>> getSurahDetails(int number) async {
    return await remoteDataSource.getSurahDetails(number);
  }
}
