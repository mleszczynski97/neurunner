import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:neurunner/game/components/mushroom.dart';
import 'package:neurunner/game/components/projectile.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/components/platform.dart';

import '../managers/audio_manager.dart';

const double gravity = 20;

class NeurunnerPlayer extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<NeurunnerGame> {
  final Vector2 _up = Vector2(0, -1);
  double velocityY = 0.0;
  double velocityX = 120.0;
  double elapsedTime = 0.0;
  double burnTick = 0.0;
  bool _isOnGround = false;
  bool _canJump = true;
  bool _isHurt = false;
  bool _isAttacking = false;
  late SpriteAnimation jumpUp;
  late SpriteAnimation run;
  late SpriteAnimation walk;
  late SpriteAnimation idle;
  late SpriteAnimation death;
  late SpriteAnimation jumpDown;
  late SpriteAnimation swordSwing;

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

    // Idle animation
    idle = SpriteAnimation.fromFrameData(
      game.images.fromCache('player/fire_idle.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(192, 48),
        stepTime: 0.1,
      ),
    );

    // Death animation
    death = SpriteAnimation.fromFrameData(
      game.images.fromCache('player/fire_death.png'),
      SpriteAnimationData.sequenced(
        amount: 13,
        textureSize: Vector2(192, 48),
        stepTime: 0.1,
        loop: false,
      ),
    );

    // Run animation
    run = SpriteAnimation.fromFrameData(
      game.images.fromCache('player/fire_run.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(192, 48),
        stepTime: 0.1,
      ),
    );

    // Walk animation
    walk = SpriteAnimation.fromFrameData(
      game.images.fromCache('player/fire_run.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(192, 48),
        stepTime: 0.2,
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
    swordSwing = SpriteAnimation.fromFrameData(
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

    // Resetting the attack animation
    if (animation == swordSwing && animation?.currentIndex == 5) {
      animation?.currentIndex = 0;
      _isAttacking = false;
    }

    // Jumping animation check
    if (velocityY != 0 && !_isAttacking && gameRef.playerData.alive.value) {
      velocityY > 0 ? animation = jumpDown : animation = jumpUp;
    }

    // Burn condition at distance 3200 (level 5)
    if (_isOnGround && position.x > 32000 && position.x < 40000) {
      burnTick += dt;
      //print(burnTick);
      burn();
    }

    elapsedTime += dt;
    // Updating every 60 ticks
    if (elapsedTime > (1 / 60)) {
      elapsedTime = 0.0;
      // Position /10 is equal to distance traveled in meters
      gameRef.playerData.distance.value = position.x ~/ 10;
      // Updating the vertical velocity according to v = u + at
      velocityY += gravity;
      velocityY = velocityY.clamp(-500, 300);
    }

    // Updating the position of the player according to d = d0 + v * t
    position.y += velocityY * dt;
    position.x += velocityX * dt;
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

        // If collision normal is almost upwards, player must be on ground.
        if (_up.dot(collisionNormal) > 0.9) {
          _isOnGround = true;
          if (!_isAttacking && gameRef.playerData.alive.value && position.x < 40000) {
            animation = run;
          }
        }

        // Resolve collision by moving player along collision normal by separation distance.
        position += collisionNormal.scaled(separationDistance);
        velocityY = 0;
      }
    }

    if (other is Mushroom) {
      if (intersectionPoints.length == 2) {
        // Calculate the collision normal and separation distance.
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        final collisionNormal = absoluteCenter - mid;
        collisionNormal.normalize();

        // If collision normal is almost upwards, player must be on ground.
        if (_up.dot(collisionNormal) > 0.6) {
          _isOnGround = true;
          if (velocityY > 100) {
            shroomJump();
          }
        }
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  //Jump method, called when user taps on the left side of the screen
  void jump() {
    // Only initialize jump sequence when on ground
    if (_isOnGround && position.x < 40000) {
      // First jump
      burnTick = 0;
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

  //Jump method, called when user taps on the left side of the screen
  void shroomJump() {
    // Only initialize jump sequence when on ground
    if (_isOnGround && position.x < 40000) {
      // First jump
      burnTick = 0;
      velocityY = -470;
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
      animation = swordSwing;

      gameRef.playerData.bullets.value--;

      // Create an instance of projectile class
      final projectile = Projectile(
        position: Vector2(position.x + 48, position.y - 5),
        projectileType: "player",
      );
      gameRef.add(projectile);
    }
  }

  // Burn method called whenever player steps on lava
  void burn() {
    if (burnTick > 2) {
      burnTick = 0;
      gameRef.playerData.hp.value -= 3;
      add(
        ColorEffect(
          Colors.orange,
          const Offset(0.0, 0.6),
          EffectController(
            duration: 0.15,
            alternate: true,
            repeatCount: 3,
          ),
        ),
      );
    }
  }

  // Hit method, called when player collides with a spike or enemy
  void hit() {
    if (!_isHurt) {
      gameRef.playerData.hp.value -= 1;
      if (gameRef.playerData.hp.value > 0 && position.x < 40000) {
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
}
