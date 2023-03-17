import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:neurunner/game/platforms/platform_module.dart';

import 'actors/player.dart';

class NeurunnerGame extends FlameGame with TapDetector, HasCollisionDetection {
  NeurunnerGame();
  late NeurunnerPlayer player;
  late Rect levelBounds;
  PlatformModule? currentPlatform, nextPlatform;
  List<String> platformModules = [];
  int moduleCounter = 0;

  @override
  Future<void> onLoad() async {
    // Device and camera setup
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    camera.viewport = FixedResolutionViewport(Vector2(640, 256));

    // Loading in the image assets
    await images.loadAll([
      'player/run.png',
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

    // Loading in the player and setting up the camera
    player = NeurunnerPlayer(position: Vector2(64, 50), size: Vector2(32, 32));
    add(player);
    setupCamera();

    return super.onLoad();
  }

  @override
  void update(dt) {
    if (overlays.isActive('MainMenu')) {
      pauseEngine();  
    }

    if (player.position.x > 800 * moduleCounter - 400) {
      var platformIndex = Random().nextInt(platformModules.length - 1) + 1;
      loadPlatformModule(platformModules.elementAt(platformIndex));
    }
    super.update(dt);
  }

  //Calling the jump method of the player class when the screen is tapped
  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    //if (info.raw.globalPosition.dx < size.x) {
    player.jump();
    //} else if (info.raw.globalPosition.dx > size.x) {
    //player.attack();
    //}
  }

  void loadPlatformModule(String platformName) async {
    //currentPlatform?.removeFromParent();
    currentPlatform = PlatformModule(platformName, moduleCounter);
    add(currentPlatform!);
    moduleCounter++;
  }

  // Method for making the camera follow the Player component
  void setupCamera() {
    levelBounds = const Rect.fromLTWH(0, 0, 800 * 200000, 256);
    camera.followComponent(player);
    camera.worldBounds = levelBounds;
  }
}
