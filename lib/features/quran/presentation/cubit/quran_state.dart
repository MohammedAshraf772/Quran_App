import 'package:equatable/equatable.dart';

import '../../data/models/surah_model.dart';

abstract class QuranState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuranInitial extends QuranState {}

class QuranLoading extends QuranState {}

class QuranLoaded extends QuranState {
  final List<SurahModel> surahs;

  QuranLoaded(this.surahs);

  @override
  List<Object?> get props => [surahs];
}

class QuranError extends QuranState {
  final String message;

  QuranError(this.message);

  @override
  List<Object?> get props => [message];
}
