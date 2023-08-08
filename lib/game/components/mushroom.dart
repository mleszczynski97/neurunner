import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:neurunner/game/components/player.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/game_constants.dart' as constants;
import 'package:neurunner/game/managers/audio_manager.dart';

class Mushroom extends SpriteComponent
    with CollisionCallbacks, HasGameRef<NeurunnerGame> {
  Mushroom({
    required Vector2 position,
    required Vector2 size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super(
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: Anchor.bottomCenter,
          priority: priority,
        ) {
    //debugMode = true;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('items/mushroom.png');
    add(RectangleHitbox()..collisionType = CollisionType.passive);

    // Keeps the coin bouncing
    await add(SizeEffect.by(
        Vector2(5, -7),
        EffectController(
          duration: 0.3,
          alternate: true,
          infinite: true,
        )));
  }

  @override
  void update(double dt) {
    if (gameRef.player.x > position.x + size.x + constants.viewportWidth / 2) {
      removeFromParent();
      //print('Coin removed');
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is NeurunnerPlayer) {
      //bounce
    }

    super.onCollisionStart(intersectionPoints, other);
  }
}
