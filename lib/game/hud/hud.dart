import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/managers/audio_manager.dart';
import 'package:neurunner/game/screens/game_over.dart';
import 'package:neurunner/game/screens/pause_menu.dart';

class Hud extends PositionComponent with HasGameRef<NeurunnerGame> {
  late final TextComponent pointsTextComponent;
  late final TextComponent healthTextComponent;
  late final TextComponent coinsTextComponent;
  late final TextComponent scoreTextComponent;
  late final SpriteComponent heartComponent;
  late final SpriteComponent coinComponent;
  late final SpriteButtonComponent pauseButtonComponent;
  late final SpriteButtonComponent attackButtonComponent;
  late final SpriteButtonComponent jumpButtonComponent;

  Hud({super.children, super.priority}) {
    positionType = PositionType.viewport;
  }

  @override
  FutureOr<void> onLoad() async {
    scoreTextComponent = TextComponent(
      text: 'SCORE',
      position: Vector2(320, 0),
      anchor: Anchor.topCenter,
      scale: Vector2.all(0.6),
    );
    add(scoreTextComponent);

    pointsTextComponent = TextComponent(
      text: '0',
      position: Vector2(320, 15),
      anchor: Anchor.topCenter,
      scale: Vector2.all(0.5),
    );
    add(pointsTextComponent);

    pauseButtonComponent = SpriteButtonComponent(
      onPressed: () {
        AudioManager.pauseBgm();
        gameRef.pauseEngine();
        gameRef.overlays.add(PauseMenu.id);
      },
      button: Sprite(game.images.fromCache('hud/pause.png')),
      position: Vector2(638, 2),
      anchor: Anchor.topRight,
      size: Vector2.all(32),
    )..positionType = PositionType.viewport;
    add(pauseButtonComponent);

    heartComponent = SpriteComponent.fromImage(
      game.images.fromCache('hud/heart.png'),
      position: Vector2(0, 0),
      anchor: Anchor.topLeft,
      size: Vector2.all(60),
    );
    add(heartComponent);

    healthTextComponent = TextComponent(
      text: '100',
      position: Vector2(30, 20),
      anchor: Anchor.topCenter,
      scale: Vector2.all(0.5),
    );
    add(healthTextComponent);

    coinComponent = SpriteComponent.fromImage(
      game.images.fromCache('items/coin.png'),
      position: Vector2(60, 10),
      anchor: Anchor.topLeft,
      size: Vector2.all(20),
    );
    add(coinComponent);

    coinsTextComponent = TextComponent(
      text: 'x0',
      position: Vector2(80, 12),
      anchor: Anchor.topLeft,
      scale: Vector2.all(0.6),
    );
    add(coinsTextComponent);

    jumpButtonComponent = SpriteButtonComponent(
      onPressed: () {
        gameRef.player.jump();
      },
      button: Sprite(game.images.fromCache('hud/jump.png')),
      position: Vector2(10, 256),
      anchor: Anchor.bottomLeft,
      size: Vector2(320, 200),
    )..positionType = PositionType.viewport;
    add(jumpButtonComponent);

    attackButtonComponent = SpriteButtonComponent(
      onPressed: () {
        //print('attack!');
      },
      button: Sprite(game.images.fromCache('hud/attack.png')),
      position: Vector2(630, 256),
      anchor: Anchor.bottomRight,
      size: Vector2(320, 200),
    )..positionType = PositionType.viewport;
    add(attackButtonComponent);

    // Listeners for player data
    gameRef.playerData.points.addListener(onPointsChange);
    gameRef.playerData.hp.addListener(onHpChange);
    gameRef.playerData.coins.addListener(onCoinsChange);
    gameRef.playerData.currentLevel.addListener(onCurrLevelChange);

    return super.onLoad();
  }

  @override
  void onRemove() {
    gameRef.playerData.points.removeListener(onPointsChange);
    gameRef.playerData.hp.removeListener(onHpChange);
    gameRef.playerData.coins.removeListener(onCoinsChange);
    gameRef.playerData.currentLevel.removeListener(onCurrLevelChange);
    super.onRemove();
  }

  void onPointsChange() {
    pointsTextComponent.text = '${gameRef.playerData.points.value}';
  }

  void onHpChange() {
    healthTextComponent.text = '${gameRef.playerData.hp.value}';

    if (gameRef.playerData.hp.value == 0) {
      removeAll([
        pointsTextComponent,
        scoreTextComponent,
        // healthTextComponent,
        // heartComponent,
        pauseButtonComponent,
        attackButtonComponent,
        jumpButtonComponent,
      ]);
      AudioManager.stopBgm();
      gameRef.pauseEngine();
      gameRef.overlays.add(GameOver.id);
    }
  }

  void onCoinsChange() {
    coinsTextComponent.text = 'x${gameRef.playerData.coins.value}';
  }

  void onCurrLevelChange() {
    if (gameRef.playerData.currentLevel.value == 1) {
      gameRef.player.velocityX = 100;
    } else {
      gameRef.player.velocityX += 25;
    }
  }
}
