import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/local_storage_service.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(LocalStorageService.getTheme());

  Future<void> toggleTheme() async {
    final newTheme = !state;

    emit(newTheme);

    await LocalStorageService.saveTheme(newTheme);
  }
}
