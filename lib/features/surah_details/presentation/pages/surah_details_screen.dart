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

  @override
  void initState() {
    super.initState();

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

  Future<void> saveLastRead(int ayahNumber, int pageNumber) async {
    await LocalStorageService.saveLastRead(
      surahName: widget.surah.englishName,

      ayahNumber: ayahNumber,

      pageNumber: pageNumber,
    );
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
                      child: PageView.builder(
                        itemCount: (ayahs.length / 8).ceil(),

                        itemBuilder: (context, pageIndex) {
                          final start = pageIndex * 8;

                          final end =
                              (start + 8 > ayahs.length)
                                  ? ayahs.length
                                  : start + 8;

                          final pageAyahs = ayahs.sublist(start, end);

                          return Container(
                            margin: EdgeInsets.all(16.w),

                            padding: EdgeInsets.all(22.w),

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.circular(24.r),

                              border: Border.all(
                                color: Colors.green.shade100,

                                width: 2,
                              ),
                            ),

                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    'Page ${pageIndex + 1}',

                                    style: TextStyle(
                                      color: AppColors.primary,

                                      fontWeight: FontWeight.bold,

                                      fontSize: 18.sp,
                                    ),
                                  ),

                                  SizedBox(height: 20.h),

                                  RichText(
                                    textAlign: TextAlign.center,

                                    textDirection: TextDirection.rtl,

                                    text: TextSpan(
                                      children:
                                          pageAyahs.map((ayah) {
                                            return TextSpan(
                                              text:
                                                  '${ayah.text} ﴿${ayah.number}﴾ ',

                                              style: TextStyle(
                                                color: Colors.black,

                                                fontSize: 30.sp,

                                                height: 2.2,
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  ),

                                  SizedBox(height: 30.h),

                                  ElevatedButton(
                                    onPressed: () async {
                                      await saveLastRead(
                                        pageAyahs.last.number,

                                        pageIndex + 1,
                                      );

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Last Read Saved'),
                                        ),
                                      );
                                    },

                                    child: const Text('Save Last Read'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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

          SizedBox(height: 24.h),

          Text(
            widget.surah.name,

            style: TextStyle(
              color: Colors.white,

              fontSize: 40.sp,

              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8.h),

          Text(
            widget.surah.englishName,

            style: TextStyle(color: Colors.white70, fontSize: 20.sp),
          ),

          SizedBox(height: 18.h),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),

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
