import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/app_router.dart';
import 'core/network/api_service.dart';
import 'core/services/local_storage_service.dart';
import 'core/theme/app_theme.dart';

import 'features/quran/data/datasource/quran_remote_datasource.dart';
import 'features/quran/data/repositories/quran_repository.dart';
import 'features/quran/presentation/cubit/quran_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalStorageService.init();

  runApp(const QuranApp());
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
        return MultiBlocProvider(
          providers: [
            BlocProvider<QuranCubit>(
              create:
                  (_) => QuranCubit(
                    QuranRepository(QuranRemoteDataSource(ApiService())),
                  )..getSurahs(),
            ),
          ],

          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
