import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/app_router.dart';
import 'core/network/api_service.dart';
import 'features/quran/data/datasource/quran_remote_datasource.dart';
import 'features/quran/data/repositories/quran_repository.dart';
import 'features/quran/presentation/cubit/quran_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService();

  final remoteDataSource = QuranRemoteDataSource(apiService);

  final repository = QuranRepository(remoteDataSource);

  runApp(
    BlocProvider(
      create: (_) => QuranCubit(repository),
      child: const QuranApp(),
    ),
  );
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
