import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:neurunner/game/components/player.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/game_constants.dart' as constants;

// Represents a platform in the game world.
class Saw extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<NeurunnerGame> {
  double velocityX = -50.0;
  Saw({
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
    // Loading the sprite animation
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('items/saw.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(38, 38),
        stepTime: 0.03,
        loop: true,
      ),
    );

    // Adding collision box
    await add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // Player gets hurt when touching saws
    if (other is NeurunnerPlayer) {
      gameRef.player.hit();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    position.x += velocityX * dt;

    if (gameRef.player.x > position.x + size.x + constants.viewportWidth / 2) {
      removeFromParent();
    }
    super.update(dt);
  }
}
