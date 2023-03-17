import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'platform.dart';

class PlatformModule extends PositionComponent with HasGameRef{
  final String platformName;
  int moduleCounter;

  PlatformModule(this.platformName, this.moduleCounter) : super();

  @override
  Future<void>? onLoad() async {
    // Loading in the .tmx file with specified name
    var platformModule = await TiledComponent.load(
      platformName,
      Vector2.all(16),
    );

    platformModule.position.x = 800.0 * moduleCounter;
    await add(platformModule);

    spawnPlatforms(platformModule.tileMap);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (gameRef.camera.position.x > 800 * moduleCounter + 800) {
      removeFromParent();
    }
    super.update(dt);
  }

  // Spawning game Actors from the object layers of the TiledMap
  void spawnPlatforms(RenderableTiledMap tileMap) {
    final platformsLayer = tileMap.getLayer<ObjectGroup>('Platforms');

    for (final platformObject in platformsLayer!.objects) {
      platformObject.visible = true;
      final platform = Platform(
        position:
            Vector2(platformObject.x + (moduleCounter * 800), platformObject.y),
        size: Vector2(platformObject.width, platformObject.height),
      );
      add(platform);
    }
  }
}
