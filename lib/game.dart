import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:neurunner/player.dart';

class NeurunnerGame extends FlameGame with TapDetector, HasCollisionDetection {
  NeurunnerGame();
  late NeurunnerPlayer player;

  @override
  Future<void> onLoad() async {
    //Loading in the image assets
    await images.loadAll([
      'player/run.png',
    ]);

    //camera.viewport = FixedResolutionViewport(Vector2(1920, 1080));

    //Loading in the parallax background
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
      ParallaxImageData('background/010_grass.png'),
      ParallaxImageData('background/011_grass_shadow.png'),
      ParallaxImageData('background/012_leaves.png'),
    ],
        baseVelocity: Vector2(150.0, 0),
        velocityMultiplierDelta: Vector2(1.1, 1.0));
    add(forestBackground);

    //Loading in the player sprite
    player = NeurunnerPlayer();
    add(player);
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    player.jump();
    
  }
}
