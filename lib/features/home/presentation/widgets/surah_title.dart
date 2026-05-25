import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../quran/data/models/surah_model.dart';
import '../../../surah_details/presentation/pages/surah_details_screen.dart';

class SurahTile extends StatelessWidget {
  final SurahModel surah;

  const SurahTile({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SurahDetailsScreen(surah: surah)),
        );
      },

      child: Container(
        padding: EdgeInsets.all(18.w),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
        ),

        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.w,

              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),

              child: Center(
                child: Text(
                  surah.number.toString(),

                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),

            SizedBox(width: 16.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    surah.englishName,

                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  Text(
                    "${surah.ayahs} Verses",

                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              surah.name,

              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 26.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
