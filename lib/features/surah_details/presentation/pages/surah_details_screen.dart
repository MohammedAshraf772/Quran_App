import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/services/local_storage_service.dart';

import '../../../quran/data/datasource/quran_remote_datasource.dart';
import '../../../quran/data/models/ayah_model.dart';
import '../../../quran/data/models/surah_model.dart';
import '../../../quran/data/repositories/quran_repository.dart';

class SurahDetailsScreen extends StatefulWidget {
  final SurahModel surah;

  const SurahDetailsScreen({super.key, required this.surah});

  @override
  State<SurahDetailsScreen> createState() => _SurahDetailsScreenState();
}

class _SurahDetailsScreenState extends State<SurahDetailsScreen> {
  List<AyahModel> ayahs = [];

  bool isLoading = true;

  final ScrollController scrollController = ScrollController();

  int currentPage = 1;

  @override
  void initState() {
    super.initState();

    loadSurah();
  }

  Future<void> loadSurah() async {
    try {
      final repository = QuranRepository(QuranRemoteDataSource(ApiService()));

      ayahs = await repository.getSurahDetails(widget.surah.number);

      if (ayahs.isNotEmpty) {
        currentPage = ayahs.first.page;
      }

      scrollController.addListener(saveReadingProgress);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveReadingProgress() async {
    if (ayahs.isEmpty) return;

    if (!scrollController.hasClients) return;

    int index = (scrollController.offset / 120).floor();

    if (index < 0) {
      index = 0;
    }

    if (index >= ayahs.length) {
      index = ayahs.length - 1;
    }

    await LocalStorageService.saveLastRead(
      surahName: widget.surah.name,
      ayahNumber: ayahs[index].number,
      pageNumber: ayahs[index].page,
    );

    if (mounted) {
      setState(() {
        currentPage = ayahs[index].page;
      });
    }
  }

  @override
  void dispose() {
    if (scrollController.hasClients) {
      saveReadingProgress();
    }

    scrollController.dispose();

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
                    buildHeader(),

                    Expanded(
                      child: ListView(
                        controller: scrollController,

                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 20.h,
                        ),

                        children: [
                          Text(
                            ayahs
                                .map((e) => '${e.text} ﴿${e.number}﴾')
                                .join(' '),

                            textDirection: TextDirection.rtl,

                            textAlign: TextAlign.justify,

                            style: TextStyle(
                              fontSize: 28.sp,

                              height: 2.3,

                              color: Colors.black87,
                            ),
                          ),

                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),

                    Container(
                      width: double.infinity,

                      padding: EdgeInsets.symmetric(vertical: 15.h),

                      color: const Color(0xfff8f5ec),

                      child: Text(
                        currentPage.toString(),

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 18.sp,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.only(top: 20.h, bottom: 20.h),

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
