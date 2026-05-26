import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/features/home/presentation/widgets/surah_title.dart';

import '../../../../core/constants/app_colors.dart';

import '../cubit/quran_cubit.dart';
import '../cubit/quran_state.dart';

import '../../data/models/surah_model.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: const Text("Quran", style: TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                context.read<QuranCubit>().searchSurah(value);
              },

              style: const TextStyle(color: Colors.white),

              decoration: InputDecoration(
                hintText: "Search Surah",

                hintStyle: const TextStyle(color: Colors.grey),

                filled: true,

                fillColor: AppColors.cardColor,

                prefixIcon: const Icon(Icons.search, color: Colors.grey),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: BlocBuilder<QuranCubit, QuranState>(
                builder: (context, state) {
                  if (state is QuranLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is QuranError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  if (state is QuranLoaded) {
                    return ListView.builder(
                      itemCount: state.surahs.length,

                      itemBuilder: (context, index) {
                        final SurahModel surah = state.surahs[index];

                        return SurahTile(surah: surah, onReturn: () {});
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
