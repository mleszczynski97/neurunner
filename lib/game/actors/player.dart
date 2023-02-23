import 'package:flame/components.dart';
import 'package:neurunner/game/game.dart';

const double gravity = 1000;

class NeurunnerPlayer extends SpriteAnimationComponent
    with HasGameRef<NeurunnerGame> {
  
  int jumpCount = 0;
  double velocityY = 0.0;

  NeurunnerPlayer({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.topCenter,
        );

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('player/run.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(80, 80),
        stepTime: 0.1,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // v = u + at
    velocityY += gravity * dt;

    // d = d0 + v * t
    position.y += velocityY * dt;

    position.x += 50 * dt;

    if (isOnGround()) {
      position.y = (gameRef.size.y - gameRef.size.y / 9 - gameRef.size.y / 10);
      velocityY = 0;
    }

    if (isMaxHeight()) {
      position.y = 0;
      velocityY = 0;
    }
  }

  bool isOnGround() {
    return (position.y >=
        (gameRef.size.y - gameRef.size.y / 9 - gameRef.size.y / 10));
  }

  bool isMaxHeight() {
    return (position.y <= 0);
  }

  //Jump method, called when user taps on the screen
  void jump() {
    if (isOnGround()) {
      // First jump
      velocityY = -400;
      // Set jump count to 1 on first jump
      jumpCount = 1;
    } else if (jumpCount < 2) {
      // Allow double jump if jump count is less than 2
      velocityY = -350;
      // Increment jump count on second jump
      jumpCount += 1;
    }
  }
}
