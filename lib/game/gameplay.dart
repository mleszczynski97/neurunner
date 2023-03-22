import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/managers/audio_manager.dart';
import 'game_constants.dart' as constants;
import 'components/player.dart';
import 'hud/hud.dart';
import 'managers/tmx_module_manager.dart';
import 'models/tiled_data.dart';

class GamePlay extends Component
    with HasGameRef<NeurunnerGame>, ParentIsA<NeurunnerGame> {
  //late NeurunnerPlayer player;
  PlatformModule? currentPlatform;
  late ParallaxComponent forestBackground;
  final hud = Hud(priority: 1);
  int moduleCounter = 0;

  @override
  Future<void> onLoad() async {
    AudioManager.playBgm('Glorious_morning.mp3');
    await initializeGame();
    gameRef.add(hud);
    gameRef.playerData.hp.value = 100;
    gameRef.playerData.points.value = 0;
    gameRef.resumeEngine();
  }

  // Setting the initial state of the game
  Future<void> initializeGame() async {
    // Loading in the image assets
    await gameRef.images.loadAll([
      'player/run.png',
      'hud/heart.png',
      'hud/jump.png',
      'hud/attack.png',
      'hud/pause.png',
    ]);

    // List of all platform modules
    

    // Loading in the parallax background
    ParallaxComponent forestBackground = await gameRef.loadParallaxComponent(
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
      baseVelocity: Vector2(25.0, 0),
      size: Vector2(640, 256),
      velocityMultiplierDelta: Vector2(1.1, 1.0),
      priority: -1,
    );

    //Adding the background component
    gameRef.add(forestBackground);

    // Loading in the player and setting up the camera
    gameRef.player = NeurunnerPlayer(position: constants.initPosition);
    add(gameRef.player);
    setupCamera();

    // Adding an initial platform segment
    loadPlatformModule(platformModules1.elementAt(0));
  }

  @override
  void onRemove() {
    //gameRef.remove(hud);
    super.onRemove();
  }

  @override
  void update(dt) {
    if (gameRef.player.position.x >
        constants.moduleWidth * moduleCounter - constants.moduleWidth / 2) {
      var platformIndex = moduleCounter ~/ 10;
      print(platformIndex);
      //Random().nextInt(platformModules.length - 1) + 1;
      loadNextModule(platformIndex);
    }

    super.update(dt);
  }

  void loadNextModule(int index) {
    switch (index) {
      case 0:
        {
          // First level
          loadPlatformModule(platformModules1.elementAt(index));
        }
        break;
      case 1:
        {
          // Second level
          loadPlatformModule(platformModules2.elementAt(index));
        }
        break;
      case 2:
        {
          // Third level
          loadPlatformModule(platformModules3.elementAt(index));
        }
        break;
      case 3:
        {
          // Fourth level
          loadPlatformModule(platformModules4.elementAt(index));
        }
        break;
      case 4:
        {
          // Fifth level
          loadPlatformModule(platformModules5.elementAt(index));
        }
        break;
      default:
        {
          // Game finished
          print("Game finished");
        }
        break;
    }
  }

  void loadPlatformModule(String platformName) async {
    currentPlatform = PlatformModule(platformName, moduleCounter);
    add(currentPlatform!);
    moduleCounter++;
  }

  void setupCamera() {
    gameRef.camera.followComponent(gameRef.player);
    gameRef.camera.worldBounds = constants.levelBounds;
  }
}
