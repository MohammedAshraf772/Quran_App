import '../../../quran/data/models/ayah_model.dart';

class SurahDetailsState {
  final bool isLoading;
  final List<AyahModel> ayahs;
  final List<List<AyahModel>> pages;
  final List<int> pageNumbers;
  final int currentPageIndex;
  final String? errorMessage;

  const SurahDetailsState({
    this.isLoading = true,
    this.ayahs = const [],
    this.pages = const [],
    this.pageNumbers = const [],
    this.currentPageIndex = 0,
    this.errorMessage,
  });

  SurahDetailsState copyWith({
    bool? isLoading,
    List<AyahModel>? ayahs,
    List<List<AyahModel>>? pages,
    List<int>? pageNumbers,
    int? currentPageIndex,
    String? errorMessage,
  }) {
    return SurahDetailsState(
      isLoading: isLoading ?? this.isLoading,
      ayahs: ayahs ?? this.ayahs,
      pages: pages ?? this.pages,
      pageNumbers: pageNumbers ?? this.pageNumbers,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      errorMessage: errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SurahDetailsState &&
        other.isLoading == isLoading &&
        other.ayahs == ayahs &&
        other.pages == pages &&
        other.pageNumbers == pageNumbers &&
        other.currentPageIndex == currentPageIndex &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(
    isLoading,
    ayahs,
    pages,
    pageNumbers,
    currentPageIndex,
    errorMessage,
  );
}
