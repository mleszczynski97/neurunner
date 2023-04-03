import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:neurunner/game/components/projectile.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/components/platform.dart';

import '../managers/audio_manager.dart';

const double gravity = 20;

class NeurunnerPlayer extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<NeurunnerGame> {
  final Vector2 _up = Vector2(0, -1);
  double velocityY = 0.0;
  double velocityX = 100.0;
  double elapsedTime = 0.0;
  bool _isOnGround = false;
  bool _canJump = true;
  bool _isHurt = false;

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
    size = Vector2.all(32);
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('player/run.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(80, 64),
        stepTime: 0.1,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    elapsedTime += dt;
    if (elapsedTime > (1 / 60)) {
      elapsedTime = 0.0;
      gameRef.playerData.distance.value = position.x ~/ 10;
      // v = u + at
      velocityY += gravity;
      velocityY = velocityY.clamp(-300, 300);
    }

    // d = d0 + v * t
    position.y += velocityY * dt;
    position.x += velocityX * dt;

    if (position.y > gameRef.size.y) {
      gameRef.playerData.hp.value = 0;
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
        }

        // Resolve collision by moving player along
        // collision normal by separation distance.
        position += collisionNormal.scaled(separationDistance);
        velocityY = 0;
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  //Jump method, called when user taps on the screen
  void jump() {
    if (_isOnGround) {
      // First jump
      velocityY = -300;
      _isOnGround = false;
      _canJump = true;
      AudioManager.playSfx('Jump_17.wav');
    } else if (_canJump) {
      // Allow double jump
      velocityY = -250;
      _canJump = false;
      AudioManager.playSfx('Jump_8.wav');
    }
  }

  void attack() {
    if (gameRef.playerData.bullets.value > 0) {
      gameRef.playerData.bullets.value--;
      final projectile =
          Projectile(position: Vector2(position.x + 20, position.y + 5));
      gameRef.add(projectile);
      print(gameRef.playerData.bullets.value);
    }
  }

  void hit() {
    if (!_isHurt) {
      _isHurt = true;
      gameRef.playerData.hp.value -= 10;
      velocityY = -200;
      _isOnGround = false;
      _canJump = false;
      AudioManager.playSfx('Loose_15.wav');
      add(
        OpacityEffect.fadeOut(
          EffectController(duration: 0.2, alternate: true, repeatCount: 5),
          onComplete: () {
            _isHurt = false;
          },
        ),
      );
    }
  }
}
