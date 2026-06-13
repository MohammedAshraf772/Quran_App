import 'package:flutter/material.dart';
import 'package:quran_app/features/bookmark/bookmark_model.dart';
import 'package:quran_app/features/surah_details/presentation/pages/surah_details_screen.dart';

import '../../../../core/services/local_storage_service.dart';
import '../../../quran/data/models/surah_model.dart';

class SurahTile extends StatelessWidget {
  final SurahModel surah;
  final List<SurahModel> allSurahs;
  final VoidCallback onReturn;
  final bool autoNextSurah;

  const SurahTile({
    super.key,
    required this.surah,
    required this.allSurahs,
    required this.onReturn,
    this.autoNextSurah = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => SurahDetailsScreen(
                  surah: surah,
                  allSurahs: allSurahs,
                  autoNextSurah: autoNextSurah,
                ),
          ),
        );

        onReturn();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xff014D40) : const Color(0xffE7F6F2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  surah.number.toString(),
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xff014D40),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.englishName,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "${surah.ayahs} Ayahs",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () async {
                await LocalStorageService.addBookmark(
                  BookmarkModel(
                    surahNumber: surah.number,
                    surahName: surah.name,
                    englishName: surah.englishName,
                  ),
                );

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${surah.name} added to bookmarks')),
                );
              },
              icon: Icon(
                Icons.bookmark_add,
                color: isDark ? Colors.white70 : const Color(0xff014D40),
              ),
            ),

            const SizedBox(width: 8),

            Flexible(
              child: Text(
                surah.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 24,
                  fontFamily: 'Amiri',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
