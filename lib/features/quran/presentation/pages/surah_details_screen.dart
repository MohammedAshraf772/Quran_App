import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/api_service.dart';

import '../../data/datasource/quran_remote_datasource.dart';
import '../../data/repositories/quran_repository.dart';

import '../cubit/surah_details_cubit.dart';
import '../cubit/surah_details_state.dart';

class SurahScreen extends StatelessWidget {
  final int surahNumber;
  final String surahName;

  const SurahScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => SurahDetailsCubit(
            QuranRepository(QuranRemoteDataSource(ApiService())),
          )..getSurahDetails(surahNumber),

      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,

          title: Text(
            surahName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: BlocBuilder<SurahDetailsCubit, SurahDetailsState>(
          builder: (context, state) {
            if (state is SurahDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SurahDetailsError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            if (state is SurahDetailsLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),

                itemCount: state.ayahs.length,

                itemBuilder: (context, index) {
                  final ayah = state.ayahs[index];

                  return Container(
                    width: double.infinity,

                    margin: const EdgeInsets.only(bottom: 14),

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      "${ayah['text']} ﴿${ayah['numberInSurah']}﴾",

                      textAlign: TextAlign.right,

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        height: 2,
                        fontFamily: 'Amiri',
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
