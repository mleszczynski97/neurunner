import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:neurunner/game/components/player.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/game_constants.dart' as constants;
import 'package:neurunner/game/managers/audio_manager.dart';

class Heart extends SpriteComponent
    with CollisionCallbacks, HasGameRef<NeurunnerGame> {
  Heart({
    required Vector2 position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super(
          position: position,
          size: Vector2.all(16),
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        ) {
    //debugMode = true;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('hud/heart.png');
    add(CircleHitbox()..collisionType = CollisionType.passive);

    // Heartbeat animation
    await add(
      SizeEffect.by(
        Vector2.all(3),
        EffectController(
          duration: 0.4,
          alternate: true,
          infinite: true,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    if (gameRef.player.x > position.x + size.x + constants.viewportWidth / 2) {
      removeFromParent();
      //print('Heart removed');
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
            if (gameRef.playerData.hp.value < 100) {
              gameRef.playerData.hp.value += 10;
            }
          },
        ),
      );
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
