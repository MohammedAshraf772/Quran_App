import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/services/audio_service.dart';
import 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  final AudioService _audioService;
  final AudioPlayer _player;

  StreamSubscription<int?>? _indexSubscription;
  StreamSubscription<bool>? _playingSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  AudioCubit({required AudioService audioService, AudioPlayer? player})
    : _audioService = audioService,
      _player = player ?? AudioPlayer(),
      super(const AudioState()) {
    _bindPlayerStreams();
  }

  void _bindPlayerStreams() {
    _indexSubscription = _player.currentIndexStream.listen((index) {
      if (index == null || isClosed) return;
      emit(state.copyWith(currentAyahIndex: index));
    });

    _playingSubscription = _player.playingStream.listen((playing) {
      if (isClosed) return;
      emit(state.copyWith(isPlaying: playing));
    });

    _playerStateSubscription = _player.playerStateStream.listen((playerState) {
      if (isClosed) return;
      if (playerState.processingState == ProcessingState.completed) {
        emit(
          state.copyWith(
            isPlaying: false,
            currentAyahIndex: 0,
            isCompleted: true,
          ),
        );
      }
    });
  }

  Future<void> togglePlaySurah(int surahNumber) async {
    if (state.isLoading || isClosed) return;

    if (_player.audioSource == null) {
      emit(
        state.copyWith(isLoading: true, isCompleted: false, errorMessage: null),
      );
      try {
        final urls = await _audioService.getSurahAudio(surahNumber);
        if (urls.isEmpty) {
          throw StateError('No audio streams available for surah $surahNumber');
        }

        final playlist = ConcatenatingAudioSource(
          children: urls.map((url) => AudioSource.uri(Uri.parse(url))).toList(),
        );

        await _player.setAudioSource(playlist);
        await _player.seek(Duration.zero, index: 0);
        await _player.play();

        if (!isClosed) {
          emit(state.copyWith(isLoading: false, isPlaying: true));
        }
      } catch (e) {
        if (!isClosed) {
          emit(
            state.copyWith(
              isLoading: false,
              isPlaying: false,
              errorMessage: e.toString(),
            ),
          );
        }
      }
      return;
    }

    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
  }

  Future<void> stop() async {
    await _player.stop();
    if (!isClosed) {
      emit(state.copyWith(isPlaying: false, currentAyahIndex: 0));
    }
  }

  AudioPlayer get player => _player;

  @override
  Future<void> close() async {
    await _indexSubscription?.cancel();
    await _playingSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _player.dispose();
    return super.close();
  }
}
