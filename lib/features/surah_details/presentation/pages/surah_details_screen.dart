import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/network/api_service.dart';
import 'package:quran_app/features/quran/data/datasource/quran_remote_datasource.dart';
import 'package:quran_app/features/quran/data/models/ayah_model.dart';
import 'package:quran_app/features/quran/data/models/surah_model.dart';
import 'package:quran_app/features/quran/data/repositories/quran_repository.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/local_storage_service.dart';

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

    getDetails();
  }

  Future<void> getDetails() async {
    final repo = QuranRepository(QuranRemoteDataSource(ApiService()));
    ayahs = await repo.getSurahDetails(widget.surah.number);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 250.h,
                    pinned: true,
                    backgroundColor: AppColors.primary,

                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        padding: EdgeInsets.only(
                          top: 90.h,
                          left: 24.w,
                          right: 24.w,
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF015248), Color(0xFF0A7B65)],
                          ),
                        ),

                        child: Column(
                          children: [
                            Text(
                              widget.surah.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 10.h),

                            Text(
                              widget.surah.englishName,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18.sp,
                              ),
                            ),

                            SizedBox(height: 14.h),

                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                '${widget.surah.ayahs} Ayahs',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding: EdgeInsets.all(20.w),

                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: ayahs.length,

                        (context, index) {
                          final ayah = ayahs[index];

                          return GestureDetector(
                            onTap: () async {
                              await LocalStorageService.saveLastRead(
                                surahNumber: widget.surah.number,
                                ayahNumber: ayah.number,
                                surahName: widget.surah.englishName,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Saved Ayah ${ayah.number}'),
                                ),
                              );
                            },

                            child: Container(
                              margin: EdgeInsets.only(bottom: 18.h),

                              padding: EdgeInsets.all(20.w),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24.r),
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,

                                children: [
                                  Container(
                                    width: 42.w,
                                    height: 42.w,

                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),

                                    child: Center(
                                      child: Text(
                                        ayah.number.toString(),

                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 20.h),

                                  Text(
                                    ayah.text,

                                    textAlign: TextAlign.right,

                                    style: TextStyle(
                                      fontSize: 25.sp,
                                      height: 2.1,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
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
    );
  }
}
