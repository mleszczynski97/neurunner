import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  static final sfx = ValueNotifier(true);
  static final bgm = ValueNotifier(true);

  static Future<void> init() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll([
      'Jump_8.wav',
    ]);
  }

  static void playSfx(String file) {
    FlameAudio.play(file);
  }

  static void playBgm(String file) {
    FlameAudio.bgm.play(file);
  }

  static void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  static void resumeBgm() {
    FlameAudio.bgm.resume();
  }

  static void stopBgm() {
    FlameAudio.bgm.stop();
  }
}
