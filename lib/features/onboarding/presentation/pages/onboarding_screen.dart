import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
          child: Column(
            children: [
              const Spacer(),

              Container(
                height: 320.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF0C5E4F),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Center(
                  child: Image.asset(AppAssets.quran, width: 180.w),
                ),
              ),

              SizedBox(height: 40.h),

              Text(
                'Hafiz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 16.h),

              Text(
                'Learn Quran and\nRecite everyday',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.sp,
                  height: 1.7,
                ),
              ),

              SizedBox(height: 40.h),

              AppButton(
                title: 'Get Started',
                onTap: () {
                  context.go('/home');
                },
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
