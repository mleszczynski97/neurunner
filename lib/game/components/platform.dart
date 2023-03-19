import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/game_constants.dart' as constants;

// Represents a platform in the game world.
class Platform extends PositionComponent
    with CollisionCallbacks, HasGameRef<NeurunnerGame> {
  Platform({
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
          anchor: anchor,
          priority: priority,
        ) {
    //debugMode = true;
  }

  @override
  Future<void> onLoad() async {
    // Passive, because we don't want platforms to collide with each other.
    await add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void update(double dt) {
    if (gameRef.player.x > position.x + size.x + constants.viewportWidth / 2) {
      removeFromParent();
      //print('platform removed');
    }
    super.update(dt);
  }
}
