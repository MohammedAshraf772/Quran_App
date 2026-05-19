import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/surah_model.dart';
import '../../data/repositories/quran_repository.dart';

import 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  final QuranRepository repository;

  QuranCubit(this.repository) : super(QuranInitial());

  List<SurahModel> allSurahs = [];

  Future<void> getSurahs() async {
    emit(QuranLoading());

    try {
      final surahs = await repository.getSurahs();

      allSurahs = surahs;

      emit(QuranLoaded(surahs));
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  void searchSurah(String query) {
    if (query.isEmpty) {
      emit(QuranLoaded(allSurahs));
      return;
    }

    final filtered =
        allSurahs.where((surah) {
          return surah.englishName.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              surah.name.contains(query);
        }).toList();

    emit(QuranLoaded(filtered));
  }
}
