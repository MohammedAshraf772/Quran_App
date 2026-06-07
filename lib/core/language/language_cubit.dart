import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/local_storage_service.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(Locale(LocalStorageService.getLanguage()));

  Future<void> changeLanguage(String code) async {
    emit(Locale(code));

    await LocalStorageService.saveLanguage(code);
  }
}
