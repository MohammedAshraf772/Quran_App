import '../../../../core/network/api_service.dart';
import '../models/surah_model.dart';

class QuranRemoteDataSource {
  final ApiService apiService;

  QuranRemoteDataSource(this.apiService);

  Future<List<SurahModel>> getSurahs() async {
    final response = await apiService.dio.get('surah');

    final List data = response.data['data'];

    return data.map((e) {
      return SurahModel.fromJson(e);
    }).toList();
  }
}
