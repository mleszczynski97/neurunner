import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:neurunner/game/components/ember.dart';
import 'package:neurunner/game/components/enemy.dart';
import 'package:neurunner/game/components/mushroom.dart';
import 'package:neurunner/game/components/spike.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/components/platform.dart';
import 'package:neurunner/game/components/coin.dart';
import 'package:neurunner/game/components/heart.dart';
import 'package:neurunner/game/game_constants.dart' as constants;

class PlatformModule extends PositionComponent with HasGameRef<NeurunnerGame> {
  final String platformName;
  final int moduleCounter;
  final double moduleWidth = 800.0;

  PlatformModule(this.platformName, this.moduleCounter) : super();

  @override
  Future<void>? onLoad() async {
    // Loading in the .tmx file with specified name
    var platformModule = await TiledComponent.load(
      platformName,
      Vector2.all(16),
    );

    platformModule.position.x = moduleWidth * moduleCounter;
    await add(platformModule);

    spawnPlatforms(platformModule.tileMap);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (gameRef.player.x >
        moduleWidth * moduleCounter +
            moduleWidth +
            constants.viewportWidth / 2) {
      removeFromParent();
      //print('Module removed');
    }
    super.update(dt);
  }

  // Spawning game components from the object layers of the tmx map
  void spawnPlatforms(RenderableTiledMap tileMap) {
    final platformsLayer = tileMap.getLayer<ObjectGroup>('Platforms');

    for (final platformObject in platformsLayer!.objects) {
      platformObject.visible = true;
      final platform = Platform(
        position: Vector2(
            platformObject.x + (moduleCounter * moduleWidth), platformObject.y),
        size: Vector2(platformObject.width, platformObject.height),
      );
      add(platform);
    }

    final spawnablesLayer = tileMap.getLayer<ObjectGroup>('Spawnables');
    for (final spawnable in spawnablesLayer!.objects) {
      final position =
          Vector2(spawnable.x + (moduleCounter * moduleWidth), spawnable.y);

      switch (spawnable.class_) {
        case 'Coin':
          final coin = Coin(
            position: position,
          );
          add(coin);
          break;
        case 'Ember':
          final ember = Ember(
            position: position,
          );
          add(ember);
          break;
        case 'Heart':
          final heart = Heart(
            position: position,
            size: Vector2.all(16),
          );
          add(heart);
          break;
        case 'Spike':
          final spike = Spike(
            position: position,
            size: Vector2.all(16),
          );
          add(spike);
          break;
          case 'Mushroom':
          final mushroom = Mushroom(
            position: position + Vector2(16, 32),
            size: Vector2.all(32),
          );
          add(mushroom);
          break;
        case 'FlyingEnemy':
          final enemy = Enemy(
            // Y + 32 to account for bottomLeft anchor
            position: position + Vector2(0, 32),
            size: Vector2.all(32),
            enemyType: "flying",
          );
          add(enemy);
          break;
        case 'GroundEnemy':
          final enemy = Enemy(
            // Y + 32 to account for bottomLeft anchor
            position: position + Vector2(0, 32),
            size: Vector2.all(32),
            enemyType: "ground",
          );
          add(enemy);
          break;
        case 'ShootingEnemy':
          final enemy = Enemy(
            // Y + 32 to account for bottomLeft anchor
            position: position + Vector2(0, 32),
            size: Vector2.all(32),
            enemyType: "shooting",
          );
          add(enemy);
          break;
        default:
      }
    }
  }
}
