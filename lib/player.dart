import 'dart:ui';

import 'package:flame/components.dart';
import 'package:neurunner/neurunner.dart';

class NeurunnerPlayer extends SpriteAnimationComponent
    with HasGameRef<NeurunnerGame> {
  NeurunnerPlayer({
    required super.position,
  }) : super(
            size: Vector2.all(80),
            anchor: Anchor.center,
            scale: Vector2.all(2));

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
}
