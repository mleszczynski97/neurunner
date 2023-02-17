import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:neurunner/player.dart';

class NeurunnerGame extends FlameGame {
  NeurunnerGame();
  late NeurunnerPlayer _neurunner;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'player/run.png',
      'background/001_sky.png',
      'background/002_shadow.png',
      'background/003_far_shadow.png',
      'background/004_shadow_trees.png',
      'background/005_trees_shadow.png',
      'background/006_lights.png',
      'background/007_trees_back.png',
      'background/008_lights2.png',
      'background/009_trees_front.png',
      'background/010_grass.png',
      'background/011_grass_shadow.png',
      'background/012_leaves.png',
    ]);

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
        baseVelocity: Vector2(50.0, 0),
        velocityMultiplierDelta: Vector2(1.1, 1.0));
    add(forestBackground);

    //Loading in the player sprite
    _neurunner = NeurunnerPlayer(
      position: Vector2(canvasSize.x / 2, canvasSize.y * 0.9 - 80),
    );
    add(_neurunner);
  }
}
