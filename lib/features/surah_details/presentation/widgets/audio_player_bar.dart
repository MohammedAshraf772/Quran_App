import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/audio_cubit.dart';
import '../cubit/audio_state.dart';

class AudioPlayerBar extends StatelessWidget {
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;

  const AudioPlayerBar({
    super.key,
    this.onBookmark,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18, left: 30, right: 30),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF015248),
            borderRadius: BorderRadius.circular(35),
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
              final cubit    = context.read<AudioCubit>();
              final position = _getPosition(state);
              final total    = _getTotal(state);
              final speed    = _getSpeed(state);
              final isLoading = state is AudioLoading;
              final isPlaying = state is AudioPlaying;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Seek Slider ──────────────────────────────────
                  _buildSlider(position, total, cubit),

                  // ── Control Buttons ──────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Previous Ayah
                        _iconBtn(
                          icon:  Icons.skip_previous_rounded,
                          onTap: cubit.previousAyah,
                        ),

                        // Play / Pause / Loading
                        _buildPlayPauseButton(
                          isLoading: isLoading,
                          isPlaying: isPlaying,
                          onTap:     cubit.togglePlayPause,
                        ),

                        // Next Ayah
                        _iconBtn(
                          icon:  Icons.skip_next_rounded,
                          onTap: cubit.nextAyah,
                        ),

                        // Speed
                        _SpeedButton(
                          currentSpeed:     speed,
                          onSpeedChanged:   cubit.setSpeed,
                        ),

                        // Bookmark
                        if (onBookmark != null)
                          _iconBtn(icon: Icons.bookmark_add, onTap: onBookmark!),

                        // Share
                        if (onShare != null)
                          _iconBtn(icon: Icons.share, onTap: onShare!),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
  Duration _getPosition(AudioState s) {
    if (s is AudioPlaying) return s.position;
    if (s is AudioPaused)  return s.position;
    return Duration.zero;
  }

  Duration _getTotal(AudioState s) {
    if (s is AudioPlaying) return s.total;
    if (s is AudioPaused)  return s.total;
    return Duration.zero;
  }

  double _getSpeed(AudioState s) {
    if (s is AudioPlaying) return s.playbackSpeed;
    if (s is AudioPaused)  return s.playbackSpeed;
    return 1.0;
  }

  Widget _buildSlider(
    Duration position,
    Duration total,
    AudioCubit cubit,
  ) {
    final pos = position.inSeconds.toDouble();
    final max = total.inSeconds == 0 ? 1.0 : total.inSeconds.toDouble();

    return SliderTheme(
      data: const SliderThemeData(
        activeTrackColor:   Colors.white,
        inactiveTrackColor: Colors.white24,
        thumbColor:         Colors.white,
        overlayColor:       Colors.white24,
        trackHeight:        2,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
      ),
      child: Slider(
        value:     pos.clamp(0, max),
        max:       max,
        onChanged: (v) => cubit.seekTo(Duration(seconds: v.toInt())),
      ),
    );
  }

  Widget _buildPlayPauseButton({
    required bool isLoading,
    required bool isPlaying,
    required VoidCallback onTap,
  }) {
    if (isLoading) {
      return const SizedBox(
        width:  38,
        height: 38,
        child:  CircularProgressIndicator(
          color:       Colors.white,
          strokeWidth: 2.5,
        ),
      );
    }
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        isPlaying ? Icons.pause_circle : Icons.play_circle_fill,
        color: Colors.white,
        size:  40,
      ),
    );
  }

  Widget _iconBtn({
    required IconData     icon,
    required VoidCallback onTap,
    double size = 26,
  }) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: size),
    );
  }
}
class _SpeedButton extends StatelessWidget {
  final double                  currentSpeed;
  final void Function(double)   onSpeedChanged;

  const _SpeedButton({
    required this.currentSpeed,
    required this.onSpeedChanged,
  });

  static const _speeds = [0.5, 0.75, 1.0, 1.25, 1.5];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color:        Colors.white24,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${currentSpeed}x',
          style: const TextStyle(
            color:      Colors.white,
            fontSize:   12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showSheet(BuildContext context) {
    showModalBottomSheet(
      context:         context,
      backgroundColor: const Color(0xFF015248),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Playback Speed',
              style: TextStyle(
                color:      Colors.white,
                fontSize:   16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _speeds.map((speed) {
                final selected = speed == currentSpeed;
                return GestureDetector(
                  onTap: () {
                    onSpeedChanged(speed);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical:   8,
                    ),
                    decoration: BoxDecoration(
                      color:        selected ? Colors.white : Colors.white24,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${speed}x',
                      style: TextStyle(
                        color: selected
                            ? const Color(0xFF015248)
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}