import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/local_storage_service.dart';
import '../../../quran/data/models/ayah_model.dart';
import '../../../quran/data/repositories/quran_repository.dart';
import 'surah_details_state.dart';

class SurahDetailsCubit extends Cubit<SurahDetailsState> {
  final QuranRepository _repository;

  SurahDetailsCubit(this._repository) : super(SurahDetailsInitial());

  Future<void> loadSurah({
    required int surahNumber,
    required String surahEnglishName,
  }) async {
    emit(SurahDetailsLoading());

    try {
      final ayahs = await _repository.getSurahDetails(surahNumber);
      if (ayahs.isNotEmpty) {
        await LocalStorageService.saveLastRead(
          surahNumber: surahNumber,
          surahName: surahEnglishName,
          ayahNumber: ayahs.first.number,
          pageNumber: ayahs.first.page,
          ayahText: ayahs.first.text,
        );
      }
      final Map<int, List<AyahModel>> grouped = {};
      for (final ayah in ayahs) {
        grouped.putIfAbsent(ayah.page, () => []).add(ayah);
      }
      final sortedPages = grouped.keys.toList()..sort();
      final pages = sortedPages.map((p) => grouped[p]!).toList();
      final lastRead = LocalStorageService.getLastRead();
      int startIndex = 0;
      if (lastRead['surahNumber'] == surahNumber) {
        final saved = sortedPages.indexOf(lastRead['pageNumber'] as int);
        if (saved != -1) startIndex = saved;
      }

      emit(
        SurahDetailsLoaded(
          ayahs: ayahs,
          pages: pages,
          pageNumbers: sortedPages,
          currentPageIndex: startIndex,
        ),
      );
    } catch (e) {
      emit(SurahDetailsError(e.toString()));
    }
  }

  Future<void> onPageChanged({
    required int newIndex,
    required int surahNumber,
    required String surahEnglishName,
    required List<List<AyahModel>> pages,
    required List<int> pageNumbers,
    required List<AyahModel> ayahs,
  }) async {
    final firstAyah = pages[newIndex].first;

    await LocalStorageService.saveLastRead(
      surahNumber: surahNumber,
      surahName: surahEnglishName,
      ayahNumber: firstAyah.number,
      pageNumber: firstAyah.page,
      ayahText: firstAyah.text,
    );

    if (state is SurahDetailsLoaded) {
      emit((state as SurahDetailsLoaded).copyWith(currentPageIndex: newIndex));
    }
  }
}
