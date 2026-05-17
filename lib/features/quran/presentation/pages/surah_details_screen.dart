import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/surah_model.dart';

class SurahDetailsScreen extends StatelessWidget {
  final SurahModel surah;

  const SurahDetailsScreen({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primary,

        centerTitle: true,

        title: Text(
          surah.englishName,

          style: const TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(24.w),

        child: Column(
          children: [
            Container(
              width: double.infinity,

              padding: EdgeInsets.all(24.w),

              decoration: BoxDecoration(
                color: AppColors.primary,

                borderRadius: BorderRadius.circular(24.r),
              ),

              child: Column(
                children: [
                  Text(
                    surah.name,

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 32.sp,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Text(
                    '${surah.ayahs} Verses',

                    style: TextStyle(color: Colors.white70, fontSize: 16.sp),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
