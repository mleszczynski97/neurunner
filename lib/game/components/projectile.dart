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
  Projectile({
    required Vector2 position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super(
          position: position,
          size: Vector2(32, 16),
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
    animation = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('items/fireball.png'),
      SpriteAnimationData.sequenced(
        amount: 3,
        textureSize: Vector2(64, 32),
        stepTime: 0.1,
      ),
    );

    await add(
      MoveEffect.by(
        Vector2(0, -2),
        EffectController(
          alternate: true,
          infinite: true,
          duration: 0.5,
          curve: Curves.ease,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    velocityX = gameRef.player.velocityX + 150;
    position.x += velocityX * dt;
    if (position.x > gameRef.player.x + size.x + constants.viewportWidth / 2) {
      removeFromParent();
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Enemy) {
      add(
        OpacityEffect.fadeOut(
          LinearEffectController(0.2),
          onComplete: () {
            add(RemoveEffect());
            AudioManager.playSfx('Click_12.wav');
          },
        ),
      );
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
