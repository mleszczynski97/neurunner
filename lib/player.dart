import 'package:flame/components.dart';
import 'package:neurunner/game.dart';

const double gravity = 1000;

class NeurunnerPlayer extends SpriteAnimationComponent
    with HasGameRef<NeurunnerGame> {
  double velocityY = 0.0;
  int jumpCount = 0;

  NeurunnerPlayer()
      : super(
          size: Vector2.all(64),
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
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // We don't need to set the position and size in the constructor, we can set it directly here since it will
    // be called once before the first time it is rendered.
    super.position = Vector2(gameRef.size.x / 4, gameRef.size.y / 2);
    super.size = Vector2.all(gameRef.size.y / 8);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // v = u + at
    velocityY += gravity * dt;

    // d = d0 + v * t
    position.y += velocityY * dt;

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

  //
  void run() {
    // animation = SpriteAnimation.fromFrameData(
    //   game.images.fromCache('player/run.png'),
    //   SpriteAnimationData.sequenced(
    //     amount: 8,
    //     textureSize: Vector2(80, 80),
    //     stepTime: 0.1,
    //   ),
    // );
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

  //
  void hit() {}
}
