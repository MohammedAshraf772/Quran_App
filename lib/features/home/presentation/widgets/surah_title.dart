import 'package:flutter/material.dart';
import 'package:quran_app/features/surah_details/presentation/pages/surah_details_screen.dart';

import '../../../../core/constants/app_colors.dart';

import '../../../quran/data/models/surah_model.dart';

class SurahTile extends StatelessWidget {
  final SurahModel surah;

  const SurahTile({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SurahDetailsScreen(surah: surah)),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(18),
        ),

        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary,

              child: Text(
                surah.number.toString(),

                style: const TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    surah.englishName,

                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "${surah.ayahs} Ayahs",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            Text(
              surah.name,

              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
