import '../../../../core/network/api_service.dart';

class QuranRemoteDataSource {
  final ApiService apiService;

  QuranRemoteDataSource(this.apiService);

  Future<List<dynamic>> getSurahs() async {
    final response = await apiService.get("https://api.alquran.cloud/v1/surah");

    return response.data['data'];
  }

  Future<List<dynamic>> getSurahDetails(int number) async {
    final response = await apiService.get(
      "https://api.alquran.cloud/v1/surah/$number",
    );

    return response.data['data']['ayahs'];
  }
}
