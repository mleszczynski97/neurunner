import 'package:flutter/material.dart';

import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/managers/audio_manager.dart';
import 'package:neurunner/game/screens/main_menu.dart';

class SettingsMenu extends StatelessWidget {
  static const id = 'SettingsMenu';
  final NeurunnerGame gameRef;

  const SettingsMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: const Color.fromARGB(255, 80, 79, 77),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Screen title
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "SETTINGS",
                  style: TextStyle(
                    //color: Color.fromARGB(255, 169, 94, 238),
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
              ),
              // BGM Volume slider
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: 300,
                  child: ValueListenableBuilder<double>(
                    valueListenable: AudioManager.bgmVolume,
                    builder: (context, bgmVolume, child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Music Volume: ${(bgmVolume * 100).toInt()}%",
                              style: const TextStyle(
                                //color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.volume_up, 
                              //color: Colors.white,
                            ),
                            Slider(
                              value: bgmVolume,
                              onChanged: (value) =>
                                  AudioManager.bgmVolume.value = value,
                              //activeColor: Colors.white,
                              //inactiveColor: Colors.grey,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // SFX Volume Slider
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: 300,
                  child: ValueListenableBuilder<double>(
                    valueListenable: AudioManager.sfxVolume,
                    builder: (context, sfxVolume, child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "SFX Volume: ${(sfxVolume * 100).toInt()}%",
                              style: const TextStyle(
                                //color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.volume_up, 
                              //color: Colors.white,
                            ),
                            Slider(
                              value: sfxVolume,
                              onChanged: (value) =>
                                  AudioManager.sfxVolume.value = value,
                              //activeColor: Colors.white,
                              //inactiveColor: Colors.grey,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Button to go back to main menu screen
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      gameRef.overlays.remove(id);
                      gameRef.overlays.add(MainMenu.id);
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.grey, 
                      // foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'BACK',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
