import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/features/bookmark/bookmark_model.dart';
import 'package:quran_app/features/home/presentation/widgets/surah_title.dart';
import 'package:quran_app/features/quran/presentation/cubit/quran_cubit.dart';
import 'package:quran_app/features/quran/presentation/cubit/quran_state.dart';
import '../../../../core/services/local_storage_service.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<BookmarkModel> bookmarks = [];

  @override
  void initState() {
    super.initState();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    bookmarks = await LocalStorageService.getBookmarks();

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text(
          'Bookmarks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          if (state is QuranLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is QuranLoaded) {
            final bookmarkedSurahs =
                state.surahs.where((surah) {
                  return bookmarks.any((b) => b.surahNumber == surah.number);
                }).toList();

            if (bookmarkedSurahs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 90,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'No Bookmarked Surahs Yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Add your favorite surahs to access them quickly.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarkedSurahs.length,
              itemBuilder: (context, index) {
                final surah = bookmarkedSurahs[index];

                return Stack(
                  children: [
                    SurahTile(
                      surah: surah,
                      allSurahs: state.surahs,
                      autoNextSurah: false,
                      onReturn: () async {
                        await loadBookmarks();
                      },
                    ),

                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          await LocalStorageService.removeBookmark(
                            surah.number,
                          );

                          await loadBookmarks();
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
