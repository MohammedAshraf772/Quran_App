import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/services/audio_service.dart';
import 'package:quran_app/features/bookmark/bookmark_model.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../quran/data/datasource/quran_remote_datasource.dart';
import '../../../quran/data/models/ayah_model.dart';
import '../../../quran/data/models/surah_model.dart';
import '../../../quran/data/repositories/quran_repository.dart';

class SurahDetailsScreen extends StatefulWidget {
  final SurahModel surah;
  final List<SurahModel> allSurahs;
  final bool autoNextSurah;

  const SurahDetailsScreen({
    super.key,
    required this.surah,
    required this.allSurahs,
    this.autoNextSurah = true,
  });

  @override
  State<SurahDetailsScreen> createState() => _SurahDetailsScreenState();
}

class _SurahDetailsScreenState extends State<SurahDetailsScreen> {
  final AudioPlayer player = AudioPlayer();

  final AudioService audioService = AudioService();
  bool isPlaying = false;
  List<AyahModel> ayahs = [];
  bool isLoading = true;
  late PageController pageController;
  int currentPageIndex = 0;
  List<List<AyahModel>> pages = [];
  List<int> pageNumbers = [];
  @override
  void initState() {
    super.initState();

    pageController = PageController();

    loadSurah();
  }

  Future<void> loadSurah() async {
    try {
      final repository = QuranRepository(QuranRemoteDataSource(ApiService()));

      ayahs = await repository.getSurahDetails(widget.surah.number);
      if (ayahs.isNotEmpty) {
        await LocalStorageService.saveLastRead(
          surahNumber: widget.surah.number,
          surahName: widget.surah.englishName,
          ayahNumber: ayahs.first.number,
          pageNumber: ayahs.first.page,
          ayahText: ayahs.first.text,
        );
      }
      debugPrint(
        'Surah: ${widget.surah.englishName} - Ayahs Count: ${ayahs.length}',
      );
      final Map<int, List<AyahModel>> grouped = {};
      for (final ayah in ayahs) {
        grouped.putIfAbsent(ayah.page, () => []);
        grouped[ayah.page]!.add(ayah);
      }
      final sortedPages = grouped.keys.toList()..sort();
      pageNumbers = sortedPages;
      pages =
          sortedPages.map((page) {
            return grouped[page]!;
          }).toList();
      final lastRead = LocalStorageService.getLastRead();
      if (lastRead['surahNumber'] == widget.surah.number) {
        final savedPage = lastRead['pageNumber'];
        final savedIndex = pageNumbers.indexOf(savedPage);
        if (savedIndex != -1) {
          currentPageIndex = savedIndex;
        }
      }

      setState(() {
        isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          pageController.jumpToPage(currentPageIndex);
        }
      });
    } catch (e, s) {
      debugPrint(
        'Failed Surah => ${widget.surah.number} | ${widget.surah.englishName}',
      );

      debugPrint('ERROR => $e');

      debugPrintStack(stackTrace: s);

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveCurrentPage(int index) async {
    final firstAyah = pages[index].first;

    await LocalStorageService.saveLastRead(
      surahNumber: widget.surah.number,

      surahName: widget.surah.englishName,

      ayahNumber: firstAyah.number,

      pageNumber: firstAyah.page,

      ayahText: firstAyah.text,
    );
  }

  Future<void> goToNextSurah() async {
    final currentIndex = widget.allSurahs.indexWhere(
      (s) => s.number == widget.surah.number,
    );

    if (currentIndex == widget.allSurahs.length - 1) {
      return;
    }

    final nextSurah = widget.allSurahs[currentIndex + 1];

    await LocalStorageService.saveLastRead(
      surahName: nextSurah.englishName,
      ayahNumber: 1,
      pageNumber: 1,
      surahNumber: 1,
      ayahText: '',
    );
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => SurahDetailsScreen(
              surah: nextSurah,
              allSurahs: widget.allSurahs,
            ),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();

    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 18, left: 30, right: 30),
          child: Container(
            height: 65,
            decoration: BoxDecoration(
              color: const Color(0xff015248),
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Play
                IconButton(
                  onPressed: () async {
                    if (!isPlaying) {
                      final url = await audioService.getSurahAudio(
                        widget.surah.number,
                      );

                      await player.setUrl(url);

                      player.play();

                      setState(() {
                        isPlaying = true;
                      });

                      player.playerStateStream.listen((state) {
                        if (state.processingState ==
                            ProcessingState.completed) {
                          setState(() {
                            isPlaying = false;
                          });
                        }
                      });
                    } else {
                      player.stop();

                      setState(() {
                        isPlaying = false;
                      });
                    }
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle_fill,
                    color: Colors.white,
                    size: 34,
                  ),
                ),

                /// Bookmark
                IconButton(
                  onPressed: () async {
                    await LocalStorageService.addBookmark(
                      BookmarkModel(
                        surahNumber: widget.surah.number,
                        surahName: widget.surah.name,
                        englishName: widget.surah.englishName,
                      ),
                    );

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Added to bookmarks")),
                    );
                  },
                  icon: const Icon(
                    Icons.bookmark_add,
                    color: Colors.white,
                    size: 30,
                  ),
                ),

                /// Share
                IconButton(
                  onPressed: () {
                    Share.share(
                      "${widget.surah.name}\n\n"
                      "${ayahs.map((e) => e.text).join(" ")}",
                    );
                  },
                  icon: const Icon(Icons.share, color: Colors.white, size: 30),
                ),
              ],
            ),
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Column(
                  children: [
                    topHeader(),
                    Expanded(
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: pages.isEmpty ? 0 : pages.length + 1,
                        onPageChanged: (index) async {
                          if (index < pages.length) {
                            currentPageIndex = index;
                            await saveCurrentPage(index);
                            setState(() {});
                          } else {
                            if (widget.autoNextSurah) {
                              goToNextSurah();
                            }
                          }
                        },
                        itemBuilder: (context, index) {
                          if (index == pages.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Padding(
                            padding: EdgeInsets.all(16.w),

                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,

                                borderRadius: BorderRadius.circular(24),
                              ),

                              padding: EdgeInsets.all(24.w),

                              child: SingleChildScrollView(
                                child: SelectableText(
                                  pages[index]
                                      .map(
                                        (e) => '${e.text} ﴿${e.numberInSurah}﴾',
                                      )
                                      .join(' '),

                                  textAlign: TextAlign.center,

                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    height: 2.3,
                                    fontFamily: 'Amiri',
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(bottom: 20),

                      child: Text(
                        pageNumbers.isEmpty
                            ? '${'page'.tr()} 1'
                            : '${'page'.tr()} ${pageNumbers[currentPageIndex]}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget topHeader() {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.only(
        top: 20.h,
        left: 20.w,
        right: 20.w,
        bottom: 20.h,
      ),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF015248), Color(0xFF0A7B65)],
        ),
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ],
          ),

          Text(
            widget.surah.name,

            style: TextStyle(
              color: Colors.white,
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            widget.surah.englishName,
            style: TextStyle(color: Colors.white70, fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
}
