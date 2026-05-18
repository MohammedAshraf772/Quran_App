import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

import '../../data/models/ayah_model.dart';
import '../../data/models/surah_model.dart';

import '../../data/repositories/quran_repository.dart';

import '../../../../core/network/api_service.dart';
import '../../data/datasource/quran_remote_datasource.dart';

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
    final repo = QuranRepository(QuranRemoteDataSource(ApiService().dio));

    ayahs = await repo.getSurahDetails(widget.surah.number);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.surah.englishName,
          style: const TextStyle(color: Colors.white),
        ),
      ),

      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(20.w),

                    padding: EdgeInsets.all(24.w),

                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF015248), Color(0xFF0A7B65)],
                      ),

                      borderRadius: BorderRadius.circular(28.r),
                    ),

                    child: Column(
                      children: [
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
                          '${widget.surah.ayahs} Ayahs',

                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),

                      itemCount: ayahs.length,

                      itemBuilder: (context, index) {
                        final ayah = ayahs[index];

                        return Container(
                          margin: EdgeInsets.only(bottom: 14.h),

                          padding: EdgeInsets.all(18.w),

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(20.r),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,

                            children: [
                              Container(
                                padding: EdgeInsets.all(10.w),

                                decoration: BoxDecoration(
                                  color: AppColors.primary,

                                  shape: BoxShape.circle,
                                ),

                                child: Text(
                                  ayah.number.toString(),

                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),

                              SizedBox(height: 20.h),

                              Text(
                                ayah.text,

                                textAlign: TextAlign.right,

                                style: TextStyle(
                                  fontSize: 24.sp,

                                  height: 2,

                                  color: AppColors.textPrimary,
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
    );
  }
}
