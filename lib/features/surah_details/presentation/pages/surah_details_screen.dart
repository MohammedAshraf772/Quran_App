import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/services/local_storage_service.dart';

import '../../../quran/data/datasource/quran_remote_datasource.dart';
import '../../../quran/data/models/ayah_model.dart';
import '../../../quran/data/models/surah_model.dart';
import '../../../quran/data/repositories/quran_repository.dart';

class SurahDetailsScreen extends StatefulWidget {
  final SurahModel surah;

  const SurahDetailsScreen({super.key, required this.surah});

  @override
  State<SurahDetailsScreen> createState() => _SurahDetailsScreenState();
}

class _SurahDetailsScreenState extends State<SurahDetailsScreen> {
  List<AyahModel> ayahs = [];

  bool isLoading = true;

  final ScrollController scrollController = ScrollController();

  int currentPage = 1;

  @override
  void initState() {
    super.initState();

    getSurahDetails();
  }

  Future<void> getSurahDetails() async {
    try {
      final repository = QuranRepository(QuranRemoteDataSource(ApiService()));

      final result = await repository.getSurahDetails(widget.surah.number);

      ayahs = result;

      if (ayahs.isNotEmpty) {
        currentPage = ayahs.first.page;
      }

      scrollController.addListener(() {
        if (ayahs.isEmpty) return;

        final index = (scrollController.offset / 250).floor();

        if (index >= 0 && index < ayahs.length) {
          LocalStorageService.saveLastRead(
            surahName: widget.surah.englishName,
            ayahNumber: ayahs[index].number,
            pageNumber: ayahs[index].page,
          );

          setState(() {
            currentPage = ayahs[index].page;
          });
        }
      });

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f5ec),

      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Column(
                  children: [
                    topHeader(),

                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,

                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),

                        itemCount: ayahs.length,

                        itemBuilder: (context, index) {
                          final ayah = ayahs[index];

                          return Container(
                            margin: EdgeInsets.only(bottom: 18.h),

                            child: Text(
                              '${ayah.text} ﴿${ayah.number}﴾',

                              textAlign: TextAlign.center,

                              textDirection: TextDirection.rtl,

                              style: TextStyle(
                                fontSize: 28.sp,
                                height: 2.2,
                                color: Colors.black87,
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
        bottom: 20.h,
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
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ],
          ),

          Text(
            widget.surah.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 10.h),

          Text(
            widget.surah.englishName,
            style: TextStyle(color: Colors.white70, fontSize: 18.sp),
          ),

          SizedBox(height: 15.h),

          Text(
            "Page $currentPage",
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
}
