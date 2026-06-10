import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/features/profail/presentation/pages/profile_screen.dart';
import 'package:quran_app/features/surah_details/presentation/pages/surah_details_screen.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/local_storage_service.dart';

import '../../../quran/presentation/cubit/quran_cubit.dart';
import '../../../quran/presentation/cubit/quran_state.dart';

import '../widgets/surah_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final TextEditingController searchController = TextEditingController();

  String lastReadSurah = '';

  String lastReadAyahText = '';

  int lastReadAyah = 1;

  int lastReadPage = 1;

  int lastReadSurahNumber = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadLastRead();
    });

    context.read<QuranCubit>().getSurahs();
  }

  Future<void> loadLastRead() async {
    final data = LocalStorageService.getLastRead();

    if (!mounted) return;

    setState(() {
      lastReadSurah = data['surahName'];

      lastReadAyah = data['ayahNumber'];

      lastReadPage = data['pageNumber'];

      lastReadAyahText = data['ayahText'];

      lastReadSurahNumber = data['surahNumber'];
    });
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                'surah'.tr(),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
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
                      final query = searchController.text.trim().toLowerCase();

                      final surahs =
                          query.isEmpty
                              ? state.surahs
                              : state.surahs.where((surah) {
                                return surah.name.toLowerCase().contains(
                                      query,
                                    ) ||
                                    surah.englishName.toLowerCase().contains(
                                      query,
                                    ) ||
                                    surah.englishNameTranslation
                                        .toLowerCase()
                                        .contains(query) ||
                                    surah.number.toString().contains(query);
                              }).toList();

                      if (surahs.isEmpty) {
                        return Center(
                          child: Text(
                            'No Surah Found',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: EdgeInsets.only(bottom: 20.h),

                        itemCount: surahs.length,

                        separatorBuilder: (_, __) => SizedBox(height: 16.h),

                        itemBuilder: (context, index) {
                          return SurahTile(
                            surah: surahs[index],
                            allSurahs: state.surahs,
                            onReturn: () async {
                              await loadLastRead();
                            },
                          );
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
              'assalamualaikum'.tr(),

              style: TextStyle(color: AppColors.textSecondary, fontSize: 18.sp),
            ),

            SizedBox(height: 8.h),
          ],
        ),

        Container(
          width: 56.w,
          height: 56.w,

          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
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
        color: Theme.of(context).cardColor,

        borderRadius: BorderRadius.circular(20.r),
      ),

      child: TextField(
        controller: searchController,

        onChanged: (_) {
          setState(() {});
        },

        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),

        decoration: InputDecoration(
          border: InputBorder.none,

          hintText: 'search_surah'.tr(),

          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),

          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),

          suffixIcon:
              searchController.text.isEmpty
                  ? null
                  : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      setState(() {});
                    },
                  ),
        ),
      ),
    );
  }

  Widget lastReadCard() {
    return GestureDetector(
      onTap: () {
        final state = context.read<QuranCubit>().state;

        if (state is! QuranLoaded) return;

        final surah = state.surahs.firstWhere(
          (s) => s.number == lastReadSurahNumber,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) =>
                    SurahDetailsScreen(surah: surah, allSurahs: state.surahs),
          ),
        );
      },

      child: Container(
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
                const Icon(Icons.menu_book, color: Colors.white70),

                SizedBox(width: 8.w),

                const Text(
                  'Last Read',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            Text(
              lastReadSurah,

              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10.h),

            Text(
              '${'ayah'.tr()} $lastReadAyah',

              style: const TextStyle(color: Colors.white70),
            ),

            SizedBox(height: 10.h),

            Text(
              lastReadAyahText,

              maxLines: 2,

              overflow: TextOverflow.ellipsis,

              textDirection: Directionality.of(context),

              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                height: 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget navItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );

          return;
        }

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
