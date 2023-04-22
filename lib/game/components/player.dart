import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
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
  bool _isAttacking = false;
  late SpriteAnimation jumpUp;
  late SpriteAnimation run;
  late SpriteAnimation jumpDown;
  late SpriteAnimation swing;

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
    size = Vector2(128, 32);
    add(CircleHitbox());

    // Run animation
    run = SpriteAnimation.fromFrameData(
      game.images.fromCache('player/fire_run.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(192, 48),
        stepTime: 0.1,
      ),
    );

    // Jump up animation
    jumpUp = SpriteAnimation.fromFrameData(
      game.images.fromCache('player/fire_jump.png'),
      SpriteAnimationData.sequenced(
        amount: 3,
        textureSize: Vector2(192, 48),
        stepTime: 0.1,
      ),
    );

    // Fall down animation
    jumpDown = SpriteAnimation.fromFrameData(
      game.images.fromCache('player/fire_fall.png'),
      SpriteAnimationData.sequenced(
        amount: 3,
        textureSize: Vector2(192, 48),
        stepTime: 0.1,
      ),
    );

    // Sword swing animation
    swing = SpriteAnimation.fromFrameData(
      game.images.fromCache('player/fire_attack.png'),
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: Vector2(192, 48),
        stepTime: 0.1,
      ),
    );

    // Setting initial animation to running
    animation = run;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (animation == swing && animation?.currentIndex == 5) {
      animation?.currentIndex = 0;
      _isAttacking = false;
    }

    if (velocityY != 0 && !_isAttacking) {
      velocityY > 0 ? animation = jumpDown : animation = jumpUp;
    }

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
        final separationDistance = (size.y / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // If collision normal is almost upwards,
        // player must be on ground.
        if (_up.dot(collisionNormal) > 0.9) {
          _isOnGround = true;
          if (!_isAttacking) animation = run;
        }

        // Resolve collision by moving player along
        // collision normal by separation distance.
        position += collisionNormal.scaled(separationDistance);
        velocityY = 0;
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  //Jump method, called when user taps on the left side of the screen
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

  //Attack method, called when user taps on the right side of the screen
  void attack() {
    if (gameRef.playerData.bullets.value > 0 && !_isAttacking) {
      
      _isAttacking = true;
      animation = swing;

      gameRef.playerData.bullets.value--;
      final projectile = Projectile(
        position: Vector2(position.x + 48, position.y-5),
      );
      gameRef.add(projectile);
    }
  }

  // Hit method, called when player collides with a spike or enemy
  void hit() {
    if (!_isHurt) {
      gameRef.playerData.hp.value -= 10;
      velocityY = -200;
      _isHurt = true;
      _isOnGround = false;
      _canJump = false;
      AudioManager.playSfx('Loose_15.wav');
      add(ColorEffect(
          Colors.red,
          const Offset(0.0, 0.6),
          EffectController(
            duration: 1,
            alternate: true,
          )));
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
