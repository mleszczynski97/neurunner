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
  double jumpTime = 0;

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
    add(CircleHitbox()..collisionType = CollisionType.active);

    enemyType == "flying"
        ? animation = SpriteAnimation.fromFrameData(
            game.images.fromCache('enemies/${enemyType}1.png'),
            SpriteAnimationData.sequenced(
              amount: 7,
              textureSize: Vector2(32, 32),
              stepTime: 0.1,
            ),
          )
        : animation = SpriteAnimation.fromFrameData(
            game.images.fromCache('enemies/${enemyType}1.png'),
            SpriteAnimationData.sequenced(
              amount: 1,
              textureSize: Vector2(32, 32),
              stepTime: 0.1,
            ),
          );

    //await Sprite.load('enemies/$enemyType.png');

    if (enemyType == "flying") {
      size = Vector2.all(24);
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
  }

  @override
  void update(double dt) {
    // Choosing movement pattern based on the type of the enemy
    if (enemyType == "flying") {
      flying(dt);
    } else if (enemyType == "ground") {
      jumping(dt);
    }

    // Remove the component whenever it moves out of the screeen
    if (gameRef.player.x > position.x + size.x + constants.viewportWidth / 2) {
      removeFromParent();
      //print('Enemy removed');
    }

    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is NeurunnerPlayer) {
      gameRef.player.hit();
    }
    if (other is Projectile) {
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
      add(
        MoveEffect.by(
          Vector2(0, -48),
          EffectController(
            duration: 0.75,
            curve: Curves.elasticOut,
          ),
          onComplete: () {
            add(
              MoveEffect.by(
                Vector2(0, 48),
                EffectController(
                  duration: 0.75,
                  curve: Curves.elasticIn,
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
            duration: 1.5,
          ),
        ),
      );
    }
  }
}
