import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  static final sfx = ValueNotifier(true);
  static final bgm = ValueNotifier(true);
  static final sfxVolume = ValueNotifier(0.5);
  static final bgmVolume = ValueNotifier(0.5);

  static Future<void> init() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll([
      'Jump_8.wav',
      'Click_12.wav',
      'Glorious_morning.mp3',
    ]);
  }

  static void playSfx(String file) {
    if (sfx.value) {
      FlameAudio.play(file, volume: sfxVolume.value);
    }
  }

  static void playBgm(String file) {
    if (bgm.value) {
      FlameAudio.bgm.play(file, volume: bgmVolume.value);
    }
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
