import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:neurunner/game/components/player.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/game_constants.dart' as constants;
import 'package:neurunner/game/managers/audio_manager.dart';

class Enemy extends SpriteComponent
    with CollisionCallbacks, HasGameRef<NeurunnerGame> {
  Enemy({
    required Vector2 position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super(
          position: position,
          size: Vector2.all(32),
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        ) {
    debugMode = true;
  }
  double velocityX = -50.0;

  @override
  Future<void> onLoad() async {
    add(CircleHitbox()..collisionType = CollisionType.passive);
    sprite = await Sprite.load('enemies/bat.png');

    await add(
      MoveEffect.by(
        Vector2(0, -6),
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
    position.x += velocityX * dt;

    if (gameRef.player.x > position.x + size.x + constants.viewportWidth / 2) {
      removeFromParent();
      print('Enemy removed');
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is NeurunnerPlayer) {
      add(
        OpacityEffect.fadeOut(
          LinearEffectController(0.2),
          onComplete: () {
            add(RemoveEffect());
            AudioManager.playSfx('Click_12.wav');
            gameRef.player.hit(); 
          },
        ),
      );
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
