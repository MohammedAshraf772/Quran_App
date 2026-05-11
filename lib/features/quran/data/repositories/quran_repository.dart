import '../datasource/quran_remote_datasource.dart';
import '../models/surah_model.dart';

class QuranRepository {
  final QuranRemoteDataSource remoteDataSource;

  QuranRepository(this.remoteDataSource);

  Future<List<SurahModel>> getSurahs() async {
    return await remoteDataSource.getSurahs();
  }
}
