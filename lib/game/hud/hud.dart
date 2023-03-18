import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/screens/pause_menu.dart';

class Hud extends Component with HasGameRef<NeurunnerGame> {
  Hud({super.children, super.priority}) {
    positionType = PositionType.viewport;
  }

  @override
  FutureOr<void> onLoad() async {
    final scoreTextComponent = TextComponent(
      text: 'SCORE',
      position: Vector2(gameRef.camera.position.x + 320, 0),
      anchor: Anchor.topCenter,
      scale: Vector2.all(0.6),
    );
    add(scoreTextComponent);

    final pointsTextComponent = TextComponent(
      text: '0',
      position: Vector2(gameRef.camera.position.x + 320, 15),
      anchor: Anchor.topCenter,
      scale: Vector2.all(0.5),
    );
    add(pointsTextComponent);

    final pauseButtonComponent = SpriteButtonComponent(
      onPressed: () {
        gameRef.pauseEngine();
        gameRef.overlays.add(PauseMenu.id);
      },
      button: Sprite(game.images.fromCache('hud/pause.png')),
      position: Vector2(gameRef.camera.position.x + 638, 2),
      anchor: Anchor.topRight,
      size: Vector2.all(32),
    )..positionType = PositionType.viewport;
    add(pauseButtonComponent);

    final heartComponent = SpriteComponent.fromImage(
      game.images.fromCache('hud/heart.png'),
      position: Vector2(gameRef.camera.position.x, 0),
      anchor: Anchor.topLeft,
      size: Vector2.all(60),
    );
    add(heartComponent);

    final healthTextComponent = TextComponent(
      text: '100',
      position: Vector2(gameRef.camera.position.x + 30, 20),
      anchor: Anchor.topCenter,
      scale: Vector2.all(0.5),
    );
    add(healthTextComponent);

    final jumpButtonComponent = SpriteButtonComponent(
      onPressed: () {
        gameRef.player.jump();
        //print('pressed');
      },
      button: Sprite(game.images.fromCache('hud/jump.png')),
      position: Vector2(gameRef.camera.position.x + 10, 256),
      anchor: Anchor.bottomLeft,
      size: Vector2(320, 200),
    )..positionType = PositionType.viewport;
    add(jumpButtonComponent);

    final attackButtonComponent = SpriteButtonComponent(
      onPressed: () {
        //print('attack!');
      },
      button: Sprite(game.images.fromCache('hud/attack.png')),
      position: Vector2(gameRef.camera.position.x + 630, 256),
      anchor: Anchor.bottomRight,
      size: Vector2(320, 200),
    )..positionType = PositionType.viewport;
    add(attackButtonComponent);

    gameRef.playerData.points.addListener(() {
      pointsTextComponent.text = '${gameRef.playerData.points.value}';
    });

    gameRef.playerData.hp.addListener(() {
      healthTextComponent.text = '${gameRef.playerData.hp.value}';
    });

    return super.onLoad();
  }
}
