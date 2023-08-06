import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:neurunner/game/components/enemy.dart';
import 'package:neurunner/game/components/player.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/game_constants.dart' as constants;
import 'package:neurunner/game/managers/audio_manager.dart';

class Projectile extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<NeurunnerGame> {
  String projectileType;
  late SpriteAnimation playerProjectile, enemyProjectile;

  Projectile({
    required Vector2 position,
    required this.projectileType,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super(
          position: position,
          size: Vector2(48, 32),
          scale: scale,
          angle: angle,
          anchor: Anchor.topCenter,
          priority: priority,
        ) {
    //debugMode = true;
  }
  double velocityX = 250;

  @override
  Future<void> onLoad() async {
    add(CircleHitbox()..collisionType = CollisionType.active);

    // Loading all necessary animations for all types of projectiles
    loadAnimations();

    // Choosing an animation according to the projectile type
    projectileType == "player"
        ? {
            animation = playerProjectile,
            await add(
              MoveEffect.by(
                Vector2(0, -10),
                EffectController(
                  alternate: true,
                  infinite: true,
                  duration: 0.3,
                  curve: Curves.ease,
                ),
              ),
            )
          }
        : {
            animation = enemyProjectile,
            size = Vector2(32, 20),
          };

  }

  @override
  void update(double dt) {
    projectileType == "player"
        ? velocityX = gameRef.player.velocityX + 150
        : velocityX = -150;

    position.x += velocityX * dt;

    if (position.x > gameRef.player.x + size.x + constants.viewportWidth / 2) {
      //removeFromParent();
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Enemy && projectileType == "player") {
      add(
        OpacityEffect.fadeOut(
          LinearEffectController(0.1),
          onComplete: () {
            add(RemoveEffect());
            AudioManager.playSfx('Click_12.wav');
          },
        ),
      );
    }
    if (other is NeurunnerPlayer && projectileType == "enemy") {
      gameRef.player.hit();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void loadAnimations() {
    //Animation for player projectiles
    playerProjectile = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('items/bolt.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(48, 32),
        stepTime: 0.1,
      ),
    );

    //Animation for enemy projectiles
    enemyProjectile = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('items/enemyProjectile.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(64, 32),
        stepTime: 0.1,
      ),
    );
  }
}
