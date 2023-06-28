import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:neurunner/game/components/player.dart';
import 'package:neurunner/game/components/projectile.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/game_constants.dart' as constants;
import 'package:neurunner/game/managers/audio_manager.dart';

class Enemy extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<NeurunnerGame> {
  String enemyType;
  double velocityX = -50.0;
  double jumpVelocity = -100.0;
  double jumpTime = 0, shootTime = 0;
  late SpriteAnimation groundJump, groundIdle, groundDeath;
  late SpriteAnimation flyingFly, flyingDeath;
  late SpriteAnimation shootingAttack;

  Enemy({
    required Vector2 position,
    required this.enemyType,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super(
          position: position,
          size: Vector2.all(24),
          scale: scale,
          angle: angle,
          anchor: Anchor.bottomLeft,
          priority: priority,
        ) {
    //debugMode = true;
  }

  @override
  Future<void> onLoad() async {
    // Adding a circular active hitbox
    add(CircleHitbox()..collisionType = CollisionType.active);

    // Loading all necessary animations for all types of enemies
    loadAnimations();

    // Checking which enemy was loaded and initializing their idle animation
    enemyType == "flying"
        ? animation = flyingFly
        : enemyType == "ground"
            ? animation = groundIdle
            : enemyType == "shooting"
                ? animation = shootingAttack
                : groundIdle;

    // Adding a midair wobble effect to enemies of 'flying' type
    if (enemyType == "flying") {
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

    if (enemyType == "shooting") {
      size = Vector2.all(32);
      await add(
        MoveEffect.by(
          Vector2(0, -150),
          EffectController(
            alternate: true,
            infinite: true,
            duration: 2,
            curve: Curves.linear,
          ),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    // Choosing movement pattern method based on the type of the enemy
    if (enemyType == "flying") {
      flying(dt);
    } else if (enemyType == "ground") {
      jumping(dt);
    } else {
      shooting(dt);
    }

    // Remove the component whenever it moves out of the screeen
    if (gameRef.player.x > position.x + size.x + constants.viewportWidth / 2) {
      removeFromParent();
    }

    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // Player collision -> player receives damage
    if (other is NeurunnerPlayer) {
      gameRef.player.hit();
    }
    // Projectile collision -> enemy removed after fade out time
    if (other is Projectile && other.projectileType == "player") {
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

  // Move enemy constantly left
  void flying(double dt) {
    position.x += velocityX * dt;
  }

  void jumping(double dt) {
    jumpTime += dt;
    if (jumpTime > 3) {
      jumpTime = 0;
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('enemies/${enemyType}1.png'),
        SpriteAnimationData.sequenced(
          amount: 8,
          textureSize: Vector2(24, 24),
          stepTime: 0.1,
          loop: false,
        ),
      );
      add(
        MoveEffect.by(
          Vector2(0, -48),
          EffectController(
            duration: 0.5,
            //curve: Curves.elasticOut,
            curve: Curves.decelerate,
          ),
          onComplete: () {
            add(
              MoveEffect.by(
                Vector2(0, 48),
                EffectController(
                  duration: 0.3,
                  //curve: Curves.elasticIn,
                  curve: Curves.easeIn,
                ),
              ),
            );
          },
        ),
      );
      add(
        MoveEffect.by(
          Vector2(-100, 0),
          EffectController(
            duration: 0.8,
          ),
          onComplete: () {
            animation = SpriteAnimation.fromFrameData(
              game.images.fromCache('enemies/${enemyType}1_idle.png'),
              SpriteAnimationData.sequenced(
                amount: 4,
                textureSize: Vector2(24, 24),
                stepTime: 0.1,
              ),
            );
          },
        ),
      );
    }
  }

  void shooting(double dt) {
    shootTime += dt;
    if (shootTime > 3) {
      shootTime = 0;
      final projectile = Projectile(
        position: Vector2(position.x + 48, position.y - 5),
        projectileType: "enemy",
      );
      gameRef.add(projectile);
    }
  }

  void loadAnimations() {
    // Idle animation for ground enemies
    groundIdle = SpriteAnimation.fromFrameData(
      game.images.fromCache('enemies/ground1_idle.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(24, 24),
        stepTime: 0.1,
      ),
    );

    // Jump animation for ground enemies
    groundJump = SpriteAnimation.fromFrameData(
      game.images.fromCache('enemies/ground1.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(24, 24),
        stepTime: 0.1,
        loop: false,
      ),
    );

    // Fly animation for flying enemies
    flyingFly = SpriteAnimation.fromFrameData(
      game.images.fromCache('enemies/flying1.png'),
      SpriteAnimationData.sequenced(
        amount: 7,
        textureSize: Vector2(32, 32),
        stepTime: 0.1,
      ),
    );

    // Attack animation for shooting enemies
    shootingAttack = SpriteAnimation.fromFrameData(
      game.images.fromCache('enemies/shootingAttack.png'),
      SpriteAnimationData.sequenced(
        amount: 10,
        textureSize: Vector2(32, 32),
        stepTime: 0.1,
      ),
    );
  }
}
