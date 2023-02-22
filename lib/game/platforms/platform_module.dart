import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:neurunner/game/actors/player.dart';
import '../actors/platform.dart';

class PlatformModule extends Component with HasGameRef {
  final String platformName;
  late NeurunnerPlayer player;
  late Rect levelBounds;

  PlatformModule(this.platformName) : super();

  @override
  Future<void>? onLoad() async {
    // Tiled component
    final platformModule = await TiledComponent.load(
      platformName,
      Vector2.all(16),
    );

    levelBounds = Rect.fromLTWH(
      0,
      0,
      (platformModule.tileMap.map.width * platformModule.tileMap.map.tileWidth)
          .toDouble(),
      (platformModule.tileMap.map.height *
              platformModule.tileMap.map.tileHeight)
          .toDouble(),
    );

    await add(platformModule);
    spawnActors(platformModule.tileMap);
    setupCamera();
    return super.onLoad();
  }

  void spawnActors(RenderableTiledMap tileMap) {
    final platformsLayer = tileMap.getLayer<ObjectGroup>('Platforms');

    for (final platformObject in platformsLayer!.objects) {
      final platform = Platform(
        position: Vector2(platformObject.x, platformObject.y),
        size: Vector2(platformObject.width, platformObject.height),
      );
      add(platform);
    }

    final spawnPointsLayer = tileMap.getLayer<ObjectGroup>('SpawnPoints');

    for (final spawnPoint in spawnPointsLayer!.objects) {
      final position = Vector2(spawnPoint.x, spawnPoint.y - spawnPoint.height);
      final size = Vector2(spawnPoint.width, spawnPoint.height);

      switch (spawnPoint.class_) {
        case 'Player':
          player = NeurunnerPlayer(
            position: position,
            size: size,
          );
          add(player);

          break;
      }
    }
  }

  void setupCamera() {
    gameRef.camera.followComponent(player);
    gameRef.camera.worldBounds = levelBounds;
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
