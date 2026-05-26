import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
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

  late PageController pageController;

  @override
  void initState() {
    super.initState();

    pageController = PageController();

    getSurahDetails();
  }

  Future<void> getSurahDetails() async {
    try {
      final repository = QuranRepository(QuranRemoteDataSource(ApiService()));

      final result = await repository.getSurahDetails(widget.surah.number);

      setState(() {
        ayahs = result;

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveLastRead({
    required int ayahNumber,
    required int pageNumber,
  }) async {
    await LocalStorageService.saveLastRead(
      surahName: widget.surah.name,
      ayahNumber: ayahNumber,
      pageNumber: pageNumber,
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
      backgroundColor: AppColors.background,

      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Column(
                  children: [
                    topHeader(),

                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          final currentPage = pageController.page?.round() ?? 0;

                          if (ayahs.isNotEmpty) {
                            saveLastRead(
                              ayahNumber: ayahs[currentPage].number,

                              pageNumber: currentPage + 1,
                            );
                          }

                          return false;
                        },

                        child: PageView.builder(
                          controller: pageController,

                          reverse: true,

                          itemCount: ayahs.length,

                          itemBuilder: (context, index) {
                            final ayah = ayahs[index];

                            final pageNumber = index + 1;

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,

                                vertical: 20.h,
                              ),

                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xfff8f5ec),

                                  borderRadius: BorderRadius.circular(24.r),
                                ),

                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(24.w),

                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Text(
                                                widget.surah.name,

                                                style: TextStyle(
                                                  fontSize: 32.sp,

                                                  fontWeight: FontWeight.bold,

                                                  color: Colors.black87,
                                                ),
                                              ),

                                              SizedBox(height: 24.h),

                                              Text(
                                                ayah.text,

                                                textAlign: TextAlign.center,

                                                textDirection:
                                                    TextDirection.rtl,

                                                style: TextStyle(
                                                  fontSize: 30.sp,

                                                  height: 2.4,

                                                  color: Colors.black87,

                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(bottom: 24.h),

                                      child: Container(
                                        width: 46.w,

                                        height: 46.w,

                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.primary,
                                          ),

                                          shape: BoxShape.circle,
                                        ),

                                        child: Center(
                                          child: Text(
                                            pageNumber.toString(),

                                            style: TextStyle(
                                              fontSize: 16.sp,

                                              fontWeight: FontWeight.bold,

                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
        left: 24.w,
        right: 24.w,
        bottom: 30.h,
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
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },

                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ],
          ),

          SizedBox(height: 30.h),

          Text(
            widget.surah.name,

            style: TextStyle(
              color: Colors.white,
              fontSize: 42.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 10.h),

          Text(
            widget.surah.englishName,

            style: TextStyle(color: Colors.white70, fontSize: 22.sp),
          ),

          SizedBox(height: 22.h),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 12.h),

            decoration: BoxDecoration(
              color: Colors.white24,

              borderRadius: BorderRadius.circular(30.r),
            ),

            child: Text(
              '${widget.surah.ayahs} Ayahs',

              style: TextStyle(color: Colors.white, fontSize: 18.sp),
            ),
          ),
        ],
      ),
    );
  }
}
