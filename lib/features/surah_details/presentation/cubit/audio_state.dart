import 'package:equatable/equatable.dart';

class AudioState extends Equatable {
  final bool isLoading;
  final bool isPlaying;
  final int currentAyahIndex;
  final bool isCompleted;
  final String? errorMessage;

  const AudioState({
    this.isLoading = false,
    this.isPlaying = false,
    this.currentAyahIndex = 0,
    this.isCompleted = false,
    this.errorMessage,
  });

  AudioState copyWith({
    bool? isLoading,
    bool? isPlaying,
    int? currentAyahIndex,
    bool? isCompleted,
    String? errorMessage,
  }) {
    return AudioState(
      isLoading: isLoading ?? this.isLoading,
      isPlaying: isPlaying ?? this.isPlaying,
      currentAyahIndex: currentAyahIndex ?? this.currentAyahIndex,
      isCompleted: isCompleted ?? this.isCompleted,
      errorMessage: errorMessage,
    );
  }

  List<Object?> get props => [
    isLoading,
    isPlaying,
    currentAyahIndex,
    isCompleted,
    errorMessage,
  ];
}
