import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/surah_model.dart';
import '../../data/repositories/quran_repository.dart';
import 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  final QuranRepository _repository;

  QuranCubit(this._repository) : super(QuranInitial());

  List<SurahModel> _allSurahs = const [];

  Future<void> getSurahs() async {
    emit(QuranLoading());

    try {
      final surahs = await _repository.getSurahs();
      _allSurahs = surahs;
      emit(QuranLoaded(surahs));
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  void searchSurah(String query) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      emit(QuranLoaded(_allSurahs));
      return;
    }

    final lowerQuery = trimmedQuery.toLowerCase();
    final filtered =
        _allSurahs.where((surah) {
          return surah.englishName.toLowerCase().contains(lowerQuery) ||
              surah.name.contains(trimmedQuery);
        }).toList();

    emit(QuranLoaded(filtered));
  }
}
