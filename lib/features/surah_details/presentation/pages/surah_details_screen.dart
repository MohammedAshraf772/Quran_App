import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/services/local_storage_service.dart';

import '../../../quran/data/datasource/quran_remote_datasource.dart';
import '../../../quran/data/models/ayah_model.dart';
import '../../../quran/data/models/surah_model.dart';
import '../../../quran/data/repositories/quran_repository.dart';

class SurahDetailsScreen extends StatefulWidget {
  final SurahModel surah;
  final List<SurahModel> allSurahs;

  const SurahDetailsScreen({
    super.key,
    required this.surah,
    required this.allSurahs,
  });

  @override
  State<SurahDetailsScreen> createState() => _SurahDetailsScreenState();
}

class _SurahDetailsScreenState extends State<SurahDetailsScreen> {
  List<AyahModel> ayahs = [];

  bool isLoading = true;

  late PageController pageController;

  int currentPage = 0;

  List<List<AyahModel>> pages = [];

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

      final Map<int, List<AyahModel>> grouped = {};

      for (final ayah in ayahs) {
        grouped.putIfAbsent(ayah.page, () => []);

        grouped[ayah.page]!.add(ayah);
      }

      pages = grouped.values.toList();

      final lastRead = LocalStorageService.getLastRead();

      if (lastRead['surahName'] == widget.surah.englishName) {
        final savedPage = lastRead['pageNumber'];

        final index = grouped.keys.toList().indexOf(savedPage);

        if (index != -1) {
          currentPage = index;
        }
      }

      setState(() {
        isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          pageController.jumpToPage(currentPage);
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void goToNextSurah() {
    final currentIndex = widget.allSurahs.indexWhere(
      (s) => s.number == widget.surah.number,
    );

    if (currentIndex == widget.allSurahs.length - 1) {
      return;
    }

    final nextSurah = widget.allSurahs[currentIndex + 1];

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
    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f5ec),

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

                        onPageChanged: (index) {
                          currentPage = index;

                          final firstAyah = pages[index].first;

                          LocalStorageService.saveLastRead(
                            surahName: widget.surah.englishName,

                            ayahNumber: firstAyah.number,

                            pageNumber: firstAyah.page,
                          );

                          setState(() {});

                          if (index == pages.length - 1) {
                            Future.delayed(
                              const Duration(milliseconds: 500),
                              () {
                                if (mounted) {
                                  goToNextSurah();
                                }
                              },
                            );
                          }
                        },

                        itemCount: pages.length,

                        itemBuilder: (context, index) {
                          return SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 20.h,
                            ),

                            child: Container(
                              padding: EdgeInsets.all(22.w),

                              decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Text(
                                pages[index]
                                    .map((e) => '${e.text} ﴿${e.number}﴾')
                                    .join(' '),

                                textAlign: TextAlign.center,

                                textDirection: TextDirection.rtl,

                                style: TextStyle(
                                  fontSize: 30.sp,

                                  height: 2.2,

                                  color: Colors.black87,
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
                        "${currentPage + 1}",

                        style: const TextStyle(
                          fontSize: 24,

                          fontWeight: FontWeight.bold,
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

          SizedBox(height: 10.h),

          Text(
            widget.surah.englishName,

            style: TextStyle(color: Colors.white70, fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
}
