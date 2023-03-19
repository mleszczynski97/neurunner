import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:neurunner/game/game.dart';
import 'game_constants.dart' as constants;
import 'components/player.dart';
import 'hud/hud.dart';
import 'managers/tmx_module_manager.dart';

class GamePlay extends Component
    with HasGameRef<NeurunnerGame>, ParentIsA<NeurunnerGame> {
  //late NeurunnerPlayer player;
  PlatformModule? currentPlatform;
  late ParallaxComponent forestBackground;
  List<String> platformModules = [];
  int moduleCounter = 0;
  final hud = Hud(priority: 1);

  @override
  Future<void> onLoad() async {
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
    platformModules = [
      'platform_0.tmx',
      'platform_1.tmx',
      'platform_2.tmx',
      'platform_3.tmx',
      'platform_4.tmx',
      'platform_5.tmx',
    ];

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
    loadPlatformModule(platformModules.elementAt(0));
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
      var platformIndex = Random().nextInt(platformModules.length - 1) + 1;
      loadPlatformModule(platformModules.elementAt(platformIndex));
    }
    super.update(dt);
  }

  void loadPlatformModule(String platformName) async {
    //currentPlatform?.priority = 1;
    currentPlatform = PlatformModule(platformName, moduleCounter);
    add(currentPlatform!);
    moduleCounter++;
  }

  void setupCamera() {
    gameRef.camera.followComponent(gameRef.player);
    gameRef.camera.worldBounds = constants.levelBounds;
  }
}
