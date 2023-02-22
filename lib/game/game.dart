import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:neurunner/game/platforms/platform_module.dart';
import 'package:neurunner/game/actors/player.dart';

class NeurunnerGame extends FlameGame with TapDetector, HasCollisionDetection {
  NeurunnerGame();
  //late NeurunnerPlayer player;
  PlatformModule? currentPlatform;
  List<String> platformModules = [];

  @override
  Future<void> onLoad() async {
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
        velocityMultiplierDelta: Vector2(1.1, 1.0));

    add(forestBackground);

    // Adding an initial platform segment
    for(var platformModule in platformModules){
      loadPlatform(platformModule);
    }
    

    // Loading in the player
    // player = NeurunnerPlayer();
    // add(player);
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    //player.jump();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void loadPlatform(String platformName) async {
    currentPlatform?.removeFromParent();
    currentPlatform = PlatformModule(platformName);
    add(currentPlatform!);
  }
}
