import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:neurunner/game/actors/player.dart';
import 'platform.dart';

class PlatformModule extends Component with HasGameRef {
  late NeurunnerPlayer player;
  late Rect levelBounds;
  final String platformName;

  PlatformModule(this.platformName) : super();

  @override
  Future<void>? onLoad() async {
    // Loading in the .tmx file with specified name
    final startModule = await TiledComponent.load(
      'platform_0.tmx',
      Vector2.all(16),
    );
    final startingModule = await TiledComponent.load(
      platformName,
      Vector2.all(16),
    );

    // Defining the bounds of the level to keep camera in place.
    levelBounds = Rect.fromLTWH(
      0,
      0,
      (startingModule.tileMap.map.width * startingModule.tileMap.map.tileWidth)
              .toDouble() *
          20,
      (startingModule.tileMap.map.height *
              startingModule.tileMap.map.tileHeight)
          .toDouble(),
    );

    await add(startModule);
    startingModule.position.x = startModule.width;
    await add(startingModule);

    player = NeurunnerPlayer(position: Vector2(64, 160), size: Vector2(32, 32));
    add(player);

    spawnPlatforms(startModule.tileMap);
    //spawnPlatforms(startingModule.tileMap);

    setupCamera();

    return super.onLoad();
  }

  // Spawning game Actors from the object layers of the TiledMap
  void spawnPlatforms(RenderableTiledMap tileMap) {
    final platformsLayer = tileMap.getLayer<ObjectGroup>('Platforms');

    for (final platformObject in platformsLayer!.objects) {
      final platform = Platform(
        position: Vector2(platformObject.x, platformObject.y),
        size: Vector2(platformObject.width, platformObject.height),
      );
      add(platform);
    }
  }

  // Method for making the camera follow the Player component
  void setupCamera() {
    gameRef.camera.followComponent(player);
    gameRef.camera.worldBounds = levelBounds;
  }
}
