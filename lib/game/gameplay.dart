import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/managers/audio_manager.dart';
import 'package:neurunner/game/screens/game_over.dart';
import 'game_constants.dart' as c;
import 'components/player.dart';
import 'hud/hud.dart';
import 'managers/tmx_module_manager.dart';
import 'models/tiled_data.dart';

class GamePlay extends Component
    with HasGameRef<NeurunnerGame>, ParentIsA<NeurunnerGame> {
  PlatformModule? currentPlatform;
  late ParallaxComponent forestBackground;
  final hud = Hud(priority: 1);
  int moduleCounter = 0;
  bool gameOver = false;
  int levelIndex = 0;

  @override
  Future<void> onLoad() async {
    // AudioManager.playBgm('Glorious_morning.mp3');
    await initializeGame();

    // Reset the player data
    resetPlayerData();

    // Initialize HUD and resume the engine
    gameRef.add(hud);
    gameRef.resumeEngine();
  }

  @override
  void update(dt) {
    // Start moving the parallax background
    if (gameRef.playerData.distance.value == 32) {
      forestBackground.parallax?.baseVelocity = Vector2(30, 0);
    }

    // Start moving the parallax background slower on final level 
    if (gameRef.playerData.distance.value >= 4000) {
      forestBackground.parallax?.baseVelocity = Vector2(12, 0);
    }

    // Stop the background if player is dead or finish reached
    if (!gameRef.playerData.alive.value || gameRef.playerData.distance.value == 4040) {
      forestBackground.parallax?.baseVelocity = Vector2(0, 0);
    }

    if (gameRef.player.position.x >
        c.moduleWidth * moduleCounter - c.moduleWidth / 2) {
      levelIndex = moduleCounter ~/ 10;
      loadNextModule(levelIndex, moduleCounter);
    }

    if (gameRef.playerData.distance.value % 800 == 0 &&
        gameRef.playerData.distance.value != 0) {
      forestBackground.parallax?.baseVelocity =
          Vector2(20 * (levelIndex + 1) - levelIndex * 5.toDouble(), 0);
    }

    super.update(dt);
  }

  // Setting the initial state of each game
  Future<void> initializeGame() async {
    // Loading in the image assets
    await gameRef.images.loadAllImages();

    // Loading in the parallax background
    forestBackground = await gameRef.loadParallaxComponent(
      [
        ParallaxImageData('background/001_sky.png'),
        ParallaxImageData('background/002_shadow.png'),
        ParallaxImageData('background/003_far_shadow.png'),
        ParallaxImageData('background/004_shadow_trees.png'),
        ParallaxImageData('background/005_trees_shadow.png'),
        ParallaxImageData('background/006_lights.png'),
        ParallaxImageData('background/007_trees_back.png'),
        ParallaxImageData('background/008_lights2.png'),
        ParallaxImageData('background/009_trees_front.png'),
        ParallaxImageData('background/012_leaves.png'),
      ],
      baseVelocity: Vector2(0, 0),
      size: Vector2(640, 256),
      velocityMultiplierDelta: Vector2(1.1, 1.0),
      priority: -1,
    );
    gameRef.add(forestBackground);

    // Loading in the player
    gameRef.player = NeurunnerPlayer(position: c.initPosition);
    add(gameRef.player);
    // Focusing the camera on the player character
    setupCamera();

    // Adding an initial platform segment
    loadPlatformModule(platformModules1.elementAt(0));
  }

  // Method used to reset the player data for each game
  void resetPlayerData() {
    gameRef.playerData.alive.value = true;
    gameRef.playerData.hp.value = 100;
    gameRef.playerData.distance.value = 0;
    gameRef.playerData.coins.value = 0;
    gameRef.playerData.bullets.value = 0;
  }

  // Switch for loading the proper level modules
  void loadNextModule(int levelIndex, int moduleCounter) {
    switch (levelIndex) {
      case 0:
        {
          // First level
          nextPlatform(platformModules1, levelIndex);
        }
        break;
      case 1:
        {
          // Second level
          nextPlatform(platformModules2, levelIndex);
        }
        break;
      case 2:
        {
          // Third level
          nextPlatform(platformModules3, levelIndex);
        }
        break;
      case 3:
        {
          // Fourth level
          nextPlatform(platformModules4, levelIndex);
        }
        break;
      case 4:
        {
          // Fifth level
          nextPlatform(platformModules5, levelIndex);
        }
        break;
      case 5:
        {
          if (!gameOver) {
            loadPlatformModule(platformModulesFinish.elementAt(0));
            gameOver = true;
          } else {
            //AudioManager.stopBgm();
            forestBackground.parallax?.baseVelocity = Vector2(0, 0);
            //gameRef.pauseEngine();
            //gameRef.overlays.add(GameOver.id);
          }
        }
        break;
    }
  }

  // Method for randomizing and selecting the next module to be loaded
  void nextPlatform(List<String> moduleList, int levelIndex) {
    final nextModule = Random().nextInt(moduleList.length - 1) + 1;
    moduleCounter == levelIndex * 10
        ? loadPlatformModule(moduleList.elementAt(0))
        : loadPlatformModule(moduleList.elementAt(nextModule));
  }

  // Method for loading the next module
  void loadPlatformModule(String platformName) async {
    currentPlatform = PlatformModule(platformName, moduleCounter);
    add(currentPlatform!);
    moduleCounter++;
  }

  // Method for setting camera to follow the player
  void setupCamera() {
    gameRef.camera.followComponent(gameRef.player);
    gameRef.camera.worldBounds = c.levelBounds;
  }
}
