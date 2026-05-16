abstract class SurahDetailsState {}

class SurahDetailsInitial extends SurahDetailsState {}

class SurahDetailsLoading extends SurahDetailsState {}

class SurahDetailsLoaded extends SurahDetailsState {
  final List ayahs;

  SurahDetailsLoaded(this.ayahs);
}

class SurahDetailsError extends SurahDetailsState {
  final String message;

  SurahDetailsError(this.message);
}
