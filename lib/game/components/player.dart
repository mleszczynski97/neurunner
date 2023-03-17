import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/components/platform.dart';

const double gravity = 8;

class NeurunnerPlayer extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<NeurunnerGame> {
  int jumpCount = 0;
  double velocityY = 150.0;
  double velocityX = 100.0;
  bool _isOnGround = false;
  bool _canJump = true;
  final Vector2 _up = Vector2(0, -1);

  NeurunnerPlayer({
    required Vector2 position,
    Vector2? size,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.topCenter,
          priority: 1,
        ) {
    //debugMode = true;
  }

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('player/run.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(80, 64),
        stepTime: 0.1,
      ),
    );
    size = Vector2.all(32);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // v = u + at
    if (!_isOnGround) {
      velocityY += gravity;
    }

    velocityY = velocityY.clamp(-400, 200);
    velocityX *= 1.00001;

    // d = d0 + v * t
    position.y += velocityY * dt;

    if (position.y < gameRef.size.y - 16) {
      position.x += velocityX * dt;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Platform) {
      if (intersectionPoints.length == 2) {
        // Calculate the collision normal and separation distance.
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // If collision normal is almost upwards,
        // player must be on ground.
        if (_up.dot(collisionNormal) > 0.9) {
          _isOnGround = true;
        } else {
          _isOnGround = false;
        }

        // Resolve collision by moving player along
        // collision normal by separation distance.
        position += collisionNormal.scaled(separationDistance);
        velocityY = 0;
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Platform) {
      _isOnGround = false;
    }
    super.onCollisionEnd(other);
  }

  //Jump method, called when user taps on the screen
  void jump() {
    if (_isOnGround) {
      // First jump
      velocityY = -350;
      _canJump = true;

    } else if (_canJump) {
      // Allow double jump 
      velocityY = -300;
      _canJump = false;
    }
  }
}
