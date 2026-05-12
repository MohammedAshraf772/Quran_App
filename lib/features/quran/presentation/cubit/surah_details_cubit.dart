import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/quran_repository.dart';
import 'surah_details_state.dart';

class SurahDetailsCubit extends Cubit<SurahDetailsState> {
  final QuranRepository repository;

  SurahDetailsCubit(this.repository) : super(SurahDetailsInitial());

  Future<void> getSurahDetails(int surahNumber) async {
    emit(SurahDetailsLoading());

    try {
      final ayahs = await repository.getSurahDetails(surahNumber);

      emit(SurahDetailsLoaded(ayahs));
    } catch (e) {
      emit(SurahDetailsError(e.toString()));
    }
  }
}
