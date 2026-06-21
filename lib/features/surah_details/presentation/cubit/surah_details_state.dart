import 'package:quran_app/features/quran/data/models/ayah_model.dart';

abstract class SurahDetailsState {}

class SurahDetailsInitial extends SurahDetailsState {}

class SurahDetailsLoading extends SurahDetailsState {}

class SurahDetailsLoaded extends SurahDetailsState {
  final List<AyahModel> ayahs;
  final List<List<AyahModel>> pages;
  final List<int> pageNumbers;
  final int currentPageIndex;

  SurahDetailsLoaded({
    required this.ayahs,
    required this.pages,
    required this.pageNumbers,
    required this.currentPageIndex,
  });

  SurahDetailsLoaded copyWith({int? currentPageIndex}) {
    return SurahDetailsLoaded(
      ayahs: ayahs,
      pages: pages,
      pageNumbers: pageNumbers,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }
}

class SurahDetailsError extends SurahDetailsState {
  final String message;
  SurahDetailsError(this.message);
}
