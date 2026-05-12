import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/features/quran/data/models/surah_model.dart';

import '../../../../core/constants/app_colors.dart';

class SurahDetailsScreen extends StatelessWidget {
  final SurahModel surah;

  const SurahDetailsScreen({super.key, required this.surah});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(Icons.arrow_back_ios_new, size: 18.sp),
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Text(
                        'Al-Fatihah',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(Icons.bookmark_border, size: 22.sp),
                  ),
                ],
              ),

              SizedBox(height: 28.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28.r),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF014D40), Color(0xFF0B6B5B)],
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'الفاتحة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    Text(
                      'Makkiyah • 7 Verses',
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),

                    SizedBox(height: 24.h),

                    Divider(color: Colors.white24),

                    SizedBox(height: 24.h),

                    Text(
                      '﷽',
                      style: TextStyle(color: Colors.white, fontSize: 36.sp),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              Expanded(
                child: ListView.separated(
                  itemCount: 7,
                  separatorBuilder: (_, __) {
                    return SizedBox(height: 20.h);
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36.w,
                                height: 36.w,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const Spacer(),

                              Icon(
                                Icons.play_arrow,
                                color: AppColors.primary,
                                size: 24.sp,
                              ),

                              SizedBox(width: 16.w),

                              Icon(
                                Icons.bookmark_border,
                                color: AppColors.primary,
                                size: 22.sp,
                              ),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          Text(
                            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              height: 2,
                              color: AppColors.textPrimary,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
