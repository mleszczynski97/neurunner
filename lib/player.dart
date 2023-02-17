import 'package:flame/components.dart';
import 'package:neurunner/game.dart';

const double gravity = 2000;

class NeurunnerPlayer extends SpriteAnimationComponent
    with HasGameRef<NeurunnerGame> {
  double velocityY = 0.0;
  int jumpCount = 0;

  NeurunnerPlayer()
      : super(
          size: Vector2.all(60),
          anchor: Anchor.center,
          scale: Vector2.all(2),
          position: Vector2(0, 0),
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
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // We don't need to set the position in the constructor, we can set it directly here since it will
    // be called once before the first time it is rendered.
    super.position = Vector2(size.x / 2, size.y * 0.825);
    super.size = Vector2.all(size.y * 0.125);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // v = u + at
    velocityY += gravity * dt;

    // d = d0 + v * t
    position.y += velocityY * dt;

    if (isOnGround()) {
      position.y = gameRef.canvasSize.y * 0.825;
      velocityY = 0;
    }

    if (isMaxHeight()) {
      position.y = size.y / 1.9;
      velocityY = 0;
    }
  }

  bool isOnGround() {
    return (position.y >= gameRef.canvasSize.y * 0.825);
  }

  bool isMaxHeight() {
    return (position.y <= size.y / 1.9);
  }

  //
  void run() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('player/run.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(80, 80),
        stepTime: 0.1,
      ),
    );
  }

  //Jump method, called when user taps on the screen
  void jump() {
    if (isOnGround()) {
      velocityY = -700;
      jumpCount = 1; // Set jump count to 1 on first jump
    } else if (jumpCount < 2) {
      // Allow double jump if jump count is less than 2
      velocityY = -600;
      jumpCount += 1; // Increment jump count on second jump
    }
  }

  //
  void hit() {}
}
