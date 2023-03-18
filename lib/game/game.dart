import 'dart:math';
import 'game_constants.dart' as constants;
import 'package:neurunner/game/models/player_data.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:neurunner/game/managers/tmx_module_manager.dart';
import 'components/player.dart';
import 'hud/hud.dart';

class NeurunnerGame extends FlameGame with HasCollisionDetection, HasTappables {
  NeurunnerGame();
  late NeurunnerPlayer player;
  PlatformModule? currentPlatform, nextPlatform;
  late ParallaxComponent forestBackground;
  List<String> platformModules = [];
  int moduleCounter = 0;
  final playerData = PlayerData();

  @override
  Future<void> onLoad() async {
    // Method for setting up initial game state
    await initializeGame();
    // Device and camera setup
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    camera.viewport = FixedResolutionViewport(Vector2(640, 256));

    return super.onLoad();
  }

  @override
  void update(dt) {
    if (overlays.isActive('MainMenu')) {
      pauseEngine();
    }

    if (player.position.x >
        constants.moduleWidth * moduleCounter - constants.moduleWidth / 2) {
      var platformIndex = Random().nextInt(platformModules.length - 1) + 1;
      loadPlatformModule(platformModules.elementAt(platformIndex));
    }
    super.update(dt);
  }

  //Calling the jump method of the player class when the screen is tapped
  // @override
  // void onTapDown(TapDownInfo info) {
  //   super.onTapDown(info);
  //   //if (info.raw.globalPosition.dx < size.x) {
  //   player.jump();
  //   //} else if (info.raw.globalPosition.dx > size.x) {
  //   //player.attack();
  //   //}
  // }

  // Setting the initial state of the game
  Future<void> initializeGame() async {
    // Loading in the image assets
    await images.loadAll([
      'player/run.png',
      'hud/heart.png',
      'hud/jump.png',
      'hud/attack.png',
      'hud/pause.png',
    ]);

    // List of all platform modules
    platformModules = [
      'platform_0.tmx',
      'platform_1.tmx',
      'platform_2.tmx',
      'platform_3.tmx',
      'platform_4.tmx',
      'platform_5.tmx',
    ];

    // Loading in the parallax background
    ParallaxComponent forestBackground = await loadParallaxComponent([
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
        velocityMultiplierDelta: Vector2(1.1, 1.0));

    // Adding the background component
    add(forestBackground);

    // Adding an initial platform segment
    loadPlatformModule(platformModules.elementAt(0));

    add(Hud(priority: 1));

    // Loading in the player and setting up the camera
    player = NeurunnerPlayer(position: constants.initPosition);
    add(player);
    setupCamera();
  }

  void loadPlatformModule(String platformName) async {
    currentPlatform = PlatformModule(platformName, moduleCounter);
    add(currentPlatform!);
    moduleCounter++;
  }

  // Method for making the camera follow the Player component
  void setupCamera() {
    camera.followComponent(player);
    camera.worldBounds = constants.levelBounds;
  }
}
