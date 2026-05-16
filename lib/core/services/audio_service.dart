import 'package:just_audio/just_audio.dart';

class AudioService {
  final player = AudioPlayer();

  Future<void> playAudio(String url) async {
    await player.setUrl(url);

    player.play();
  }

  Future<void> stopAudio() async {
    await player.stop();
  }
}
