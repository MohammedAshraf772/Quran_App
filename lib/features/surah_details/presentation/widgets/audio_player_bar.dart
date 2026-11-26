import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/audio_cubit.dart';
import '../cubit/audio_state.dart';

class AudioPlayerBar extends StatelessWidget {
  final int surahNumber;
  final VoidCallback onBookmarkPressed;
  final VoidCallback onSharePressed;

  const AudioPlayerBar({
    super.key,
    required this.surahNumber,
    required this.onBookmarkPressed,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AudioCubit>();

    return Padding(
      padding: EdgeInsets.only(bottom: 18.h, left: 30.w, right: 30.w),
      child: Container(
        height: 110.h,
        decoration: BoxDecoration(
          color: const Color(0xff015248),
          borderRadius: BorderRadius.circular(35.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: BlocBuilder<AudioCubit, AudioState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder<Duration>(
                  stream: cubit.player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final total = cubit.player.duration ?? Duration.zero;
                    final maxSeconds =
                        total.inSeconds > 0 ? total.inSeconds.toDouble() : 1.0;
                    final currentSeconds =
                        position.inSeconds
                            .clamp(0, maxSeconds.toInt())
                            .toDouble();

                    return Slider(
                      value: currentSeconds,
                      max: maxSeconds,
                      onChanged: (value) {
                        cubit.seekTo(Duration(seconds: value.toInt()));
                      },
                    );
                  },
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed:
                            state.isLoading
                                ? null
                                : () => cubit.togglePlaySurah(surahNumber),
                        icon:
                            state.isLoading
                                ? SizedBox(
                                  width: 30.w,
                                  height: 30.w,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Icon(
                                  state.isPlaying
                                      ? Icons.pause_circle
                                      : Icons.play_circle_fill,
                                  color: Colors.white,
                                  size: 34.sp,
                                ),
                      ),
                      IconButton(
                        onPressed: onBookmarkPressed,
                        icon: Icon(
                          Icons.bookmark_add,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                      ),
                      IconButton(
                        onPressed: onSharePressed,
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
