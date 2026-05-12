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
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,

        title: Text(
          surah.englishName,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(24.w),

        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 24.h),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28.r),

                gradient: const LinearGradient(
                  colors: [Color(0xFF015248), Color(0xFF0A7B65)],
                ),
              ),

              child: Column(
                children: [
                  Text(
                    surah.name,

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    '${surah.verses} Verses',

                    style: TextStyle(color: Colors.white70, fontSize: 15.sp),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            Expanded(
              child: ListView.builder(
                itemCount: surah.verses,

                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.h),

                    padding: EdgeInsets.all(20.w),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(24.r),
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

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

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 18.w),

                        Expanded(
                          child: Text(
                            'هذه الآية رقم ${index + 1} من سورة ${surah.name}',

                            textAlign: TextAlign.right,

                            style: TextStyle(
                              color: AppColors.textPrimary,

                              fontSize: 22.sp,

                              height: 2,
                            ),
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
    );
  }
}
