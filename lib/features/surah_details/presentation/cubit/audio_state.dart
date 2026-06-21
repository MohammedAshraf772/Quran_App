import 'package:quran_app/features/quran/data/models/ayah_model.dart';

abstract class AudioState {}

class AudioInitial extends AudioState {}

class AudioLoading extends AudioState {}

class AudioPlaying extends AudioState {
  final int currentAyahIndex;
  final Duration position;
  final Duration total;
  final double playbackSpeed;
  final List<AyahModel> ayahs;

  AudioPlaying({
    required this.currentAyahIndex,
    required this.position,
    required this.total,
    required this.ayahs,
    this.playbackSpeed = 1.0,
  });
}

class AudioPaused extends AudioState {
  final int currentAyahIndex;
  final Duration position;
  final Duration total;
  final double playbackSpeed;
  final List<AyahModel> ayahs;

  AudioPaused({
    required this.currentAyahIndex,
    required this.position,
    required this.total,
    required this.ayahs,
    this.playbackSpeed = 1.0,
  });
}

class AudioCompleted extends AudioState {}

class AudioError extends AudioState {
  final String message;
  AudioError(this.message);
}
