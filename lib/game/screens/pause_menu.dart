import 'package:flutter/material.dart';
import 'package:neurunner/game/screens/main_menu.dart';
import '../game.dart';
import '../managers/audio_manager.dart';

class PauseMenu extends StatefulWidget {
  static const id = 'PauseMenu';
  final NeurunnerGame gameRef;

  const PauseMenu({super.key, required this.gameRef});

  @override
  PauseMenuState createState() => PauseMenuState();
}

class PauseMenuState extends State<PauseMenu> {
  static const id = 'PauseMenu';
  bool _sfxOn = AudioManager.sfx.value;
  bool _bgmOn = AudioManager.bgm.value;

  @override
  void initState() {
    super.initState();
    AudioManager.sfx.addListener(_onSfxChanged);
    AudioManager.bgm.addListener(_onBgmChanged);
  }

  @override
  void dispose() {
    AudioManager.sfx.removeListener(_onSfxChanged);
    AudioManager.bgm.removeListener(_onBgmChanged);
    super.dispose();
  }

  void _onSfxChanged() {
    setState(() {
      _sfxOn = AudioManager.sfx.value;
    });
  }

  void _onBgmChanged() {
    setState(() {
      _bgmOn = AudioManager.bgm.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          height: 220,
          width: 320,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [
              BoxShadow(
                //color: Colors.black26,
                spreadRadius: 2.0,
                blurRadius: 2.0,
                offset: Offset(4, 4),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Two IconButtons for toggling the background music and SFX
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 16),
                    const Text("BGM:",
                        style: TextStyle(
                          //color: Colors.white,
                          fontSize: 20,
                        )),
                    IconButton(
                      onPressed: () {
                        AudioManager.bgm.value = !AudioManager.bgm.value;
                      },
                      icon: Icon(
                        _bgmOn ? Icons.music_note : Icons.music_off,
                        color: _bgmOn ? Colors.deepPurple : Colors.grey[800],
                      ),
                    ),
                    const Text(
                      "SFX:",
                      style: TextStyle(
                        //color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        AudioManager.sfx.value = !AudioManager.sfx.value;
                      },
                      icon: Icon(
                        _sfxOn ? Icons.volume_up : Icons.volume_off,
                        color: _sfxOn ? Colors.deepPurple : Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              // Button for resuming the game
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    if (_bgmOn) {
                      AudioManager.resumeBgm();
                    }
                    widget.gameRef.overlays.remove(id);
                    widget.gameRef.resumeEngine();
                  },
                  style: ElevatedButton.styleFrom(
                    //backgroundColor: Colors.grey, // Change the button color
                    //foregroundColor: Colors.black, // Change the text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('RESUME'),
                ),
              ),
              const SizedBox(height: 16),
              // Button for exiting to main menu
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    AudioManager.stopBgm();
                    widget.gameRef.overlays.remove(id);
                    widget.gameRef.removeAll(widget.gameRef.children);
                    widget.gameRef.overlays.add(MainMenu.id);
                  },
                  style: ElevatedButton.styleFrom(
                    //backgroundColor: Colors.grey, // Change the button color
                    //foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('EXIT'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
