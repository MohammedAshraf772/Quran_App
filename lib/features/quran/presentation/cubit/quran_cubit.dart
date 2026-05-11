import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/quran_repository.dart';
import 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  final QuranRepository repository;

  QuranCubit(this.repository) : super(QuranInitial());

  Future<void> getSurahs() async {
    emit(QuranLoading());

    try {
      final surahs = await repository.getSurahs();

      emit(QuranLoaded(surahs));
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }
}
