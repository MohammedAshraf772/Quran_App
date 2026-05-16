import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/features/home/presentation/widgets/surah_title.dart';
import 'package:quran_app/features/quran/presentation/cubit/quran_cubit.dart';
import 'package:quran_app/features/quran/presentation/cubit/quran_state.dart';

import '../../../../core/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    context.read<QuranCubit>().getSurahs();
  }

  int currentIndex = 0;

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
            navItem(Icons.home_filled, 0),

            navItem(Icons.search, 1),

            navItem(Icons.bookmark, 2),

            navItem(Icons.person, 3),
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

              header(),

              SizedBox(height: 28.h),

              searchField(),

              SizedBox(height: 28.h),

              lastReadCard(),

              SizedBox(height: 30.h),

              Text(
                'Surah',

                style: TextStyle(
                  color: AppColors.primary,

                  fontSize: 22.sp,

                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 24.h),

              Expanded(
                child: BlocBuilder<QuranCubit, QuranState>(
                  builder: (context, state) {
                    if (state is QuranLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is QuranError) {
                      return Center(child: Text(state.message));
                    }

                    if (state is QuranLoaded) {
                      return ListView.separated(
                        itemCount: state.surahs.length,

                        separatorBuilder: (_, __) => SizedBox(height: 16.h),

                        itemBuilder: (context, index) {
                          return SurahTile(surah: state.surahs[index]);
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Assalamualaikum',

              style: TextStyle(color: AppColors.textSecondary, fontSize: 18.sp),
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
    );
  }

  Widget searchField() {
    return Container(
      height: 60.h,

      padding: EdgeInsets.symmetric(horizontal: 18.w),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20.r),
      ),

      child: const TextField(
        decoration: InputDecoration(
          border: InputBorder.none,

          hintText: 'Search surah...',

          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget lastReadCard() {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(24.w),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),

        gradient: const LinearGradient(
          colors: [Color(0xFF015248), Color(0xFF0A7B65)],
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(Icons.menu_book, color: Colors.white70),

              SizedBox(width: 8.w),

              Text('Last Read', style: TextStyle(color: Colors.white70)),
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

          Text('Ayah No: 1', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget navItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },

      child: Icon(
        icon,

        color: currentIndex == index ? Colors.white : Colors.white70,

        size: 28.sp,
      ),
    );
  }
}
