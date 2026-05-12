import 'package:equatable/equatable.dart';

import '../../data/models/ayah_model.dart';

abstract class SurahDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SurahDetailsInitial extends SurahDetailsState {}

class SurahDetailsLoading extends SurahDetailsState {}

class SurahDetailsLoaded extends SurahDetailsState {
  final List<AyahModel> ayahs;

  SurahDetailsLoaded(this.ayahs);

  @override
  List<Object?> get props => [ayahs];
}

class SurahDetailsError extends SurahDetailsState {
  final String message;

  SurahDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
