import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../quran/data/models/ayah_model.dart';
import '../../../quran/data/models/surah_model.dart';
import '../../../quran/data/datasource/quran_remote_datasource.dart';
import '../../../quran/data/repositories/quran_repository.dart';
import '../../../../core/network/api_service.dart';

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

  Future<void> saveLastRead(int ayahNumber) async {
    await LocalStorageService.saveLastRead(
      surahName: widget.surah.englishName,
      ayahNumber: ayahNumber,
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
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),

                        itemCount: ayahs.length,

                        itemBuilder: (context, index) {
                          final ayah = ayahs[index];

                          return GestureDetector(
                            onTap: () async {
                              await saveLastRead(ayah.number);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Saved Ayah ${ayah.number}'),
                                ),
                              );
                            },

                            child: Container(
                              margin: EdgeInsets.only(bottom: 18.h),

                              padding: EdgeInsets.all(22.w),

                              decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(28.r),
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,

                                children: [
                                  Container(
                                    width: 44.w,
                                    height: 44.w,

                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),

                                    child: Center(
                                      child: Text(
                                        ayah.number.toString(),

                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 24.h),

                                  Text(
                                    ayah.text,

                                    textAlign: TextAlign.right,

                                    textDirection: TextDirection.rtl,

                                    style: TextStyle(
                                      fontSize: 30.sp,

                                      height: 2.4,

                                      color: AppColors.textPrimary,

                                      fontWeight: FontWeight.w500,
                                    ),
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

                child: const Icon(Icons.arrow_back, color: Colors.black),
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
