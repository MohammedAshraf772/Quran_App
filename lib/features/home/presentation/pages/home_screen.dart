import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/features/home/presentation/widgets/surah_title.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/dummy_surahs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  List filteredSurahs = dummySurahs;

  void searchSurah(String value) {
    final result =
        dummySurahs.where((surah) {
          final english = surah.englishName.toLowerCase();

          final arabic = surah.name;

          return english.contains(value.toLowerCase()) ||
              arabic.contains(value);
        }).toList();

    setState(() {
      filteredSurahs = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
        height: 74.h,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_filled, true),
            _navItem(Icons.search, false),
            _navItem(Icons.bookmark, false),
            _navItem(Icons.person, false),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SizedBox(height: 18.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Assalamualaikum',

                        style: TextStyle(
                          color: AppColors.textSecondary,

                          fontSize: 18.sp,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        'Mohamed',

                        style: TextStyle(
                          color: AppColors.textPrimary,

                          fontSize: 34.sp,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    width: 56.w,
                    height: 56.w,

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(18.r),
                    ),

                    child: Icon(Icons.notifications_none, size: 28.sp),
                  ),
                ],
              ),

              SizedBox(height: 28.h),

              Container(
                height: 60.h,

                padding: EdgeInsets.symmetric(horizontal: 18.w),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(20.r),
                ),

                child: TextField(
                  controller: searchController,

                  onChanged: searchSurah,

                  decoration: InputDecoration(
                    border: InputBorder.none,

                    icon: Icon(Icons.search, color: AppColors.textSecondary),

                    hintText: 'Search surah...',

                    hintStyle: TextStyle(
                      color: AppColors.textSecondary,

                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              Container(
                width: double.infinity,

                padding: EdgeInsets.all(24.w),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),

                  gradient: const LinearGradient(
                    colors: [Color(0xFF015248), Color(0xFF0A7B65)],
                  ),
                ),

                child: Stack(
                  children: [
                    Positioned(
                      right: -10,
                      bottom: -10,

                      child: Icon(
                        Icons.menu_book_rounded,

                        color: Colors.white.withValues(alpha: 0.08),

                        size: 130.sp,
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book,

                              color: Colors.white70,

                              size: 18.sp,
                            ),

                            SizedBox(width: 8.w),

                            Text(
                              'Last Read',

                              style: TextStyle(
                                color: Colors.white70,

                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24.h),

                        Text(
                          'Al-Fatihah',

                          style: TextStyle(
                            color: Colors.white,

                            fontSize: 32.sp,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        Text(
                          'Ayah No: 1',

                          style: TextStyle(
                            color: Colors.white70,

                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              Row(
                children: [
                  Text(
                    'Surah',

                    style: TextStyle(
                      color: AppColors.primary,

                      fontSize: 20.sp,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(width: 26.w),

                  Text(
                    'Para',

                    style: TextStyle(
                      color: AppColors.textSecondary,

                      fontSize: 18.sp,
                    ),
                  ),

                  SizedBox(width: 26.w),

                  Text(
                    'Page',

                    style: TextStyle(
                      color: AppColors.textSecondary,

                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              Container(
                width: 42.w,
                height: 4.h,

                decoration: BoxDecoration(
                  color: AppColors.primary,

                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              SizedBox(height: 22.h),

              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,

                  itemCount: filteredSurahs.length,

                  separatorBuilder: (_, __) {
                    return SizedBox(height: 16.h);
                  },

                  itemBuilder: (context, index) {
                    return SurahTile(surah: filteredSurahs[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, bool active) {
    return Icon(
      icon,

      color: active ? Colors.white : Colors.white70,

      size: 28.sp,
    );
  }
}
