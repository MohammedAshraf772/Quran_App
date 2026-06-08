import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/language/language_cubit.dart';

import 'app/app_router.dart';

import 'core/network/api_service.dart';
import 'core/services/local_storage_service.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';

import 'features/quran/data/datasource/quran_remote_datasource.dart';
import 'features/quran/data/repositories/quran_repository.dart';
import 'features/quran/presentation/cubit/quran_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  await LocalStorageService.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
        Locale('de'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
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

      builder: (_, __) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create:
                  (_) => QuranCubit(
                    QuranRepository(QuranRemoteDataSource(ApiService())),
                  )..getSurahs(),
            ),

            BlocProvider(create: (_) => ThemeCubit()),

            BlocProvider(create: (_) => LanguageCubit()),
          ],

          child: BlocBuilder<ThemeCubit, bool>(
            builder: (context, isDark) {
              return BlocListener<LanguageCubit, Locale>(
                listener: (context, locale) async {
                  await context.setLocale(locale);
                },
                child: BlocBuilder<ThemeCubit, bool>(
                  builder: (context, isDark) {
                    return MaterialApp.router(
                      debugShowCheckedModeBanner: false,

                      locale: context.locale,

                      supportedLocales: context.supportedLocales,

                      localizationsDelegates: context.localizationDelegates,

                      theme: AppTheme.lightTheme,

                      darkTheme: AppTheme.darkTheme,

                      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

                      routerConfig: AppRouter.router,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
