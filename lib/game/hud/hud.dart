import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:neurunner/game/components/projectile.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/managers/audio_manager.dart';
import 'package:neurunner/game/screens/game_over.dart';
import 'package:neurunner/game/screens/pause_menu.dart';

class Hud extends PositionComponent with HasGameRef<NeurunnerGame> {
  late final TextComponent metersTextComponent;
  late final TextComponent healthTextComponent;
  late final TextComponent coinsTextComponent;
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

    metersTextComponent = TextComponent(
      text: '0m',
      position: Vector2(320, 0),
      anchor: Anchor.topCenter,
      scale: Vector2.all(0.7),  
    );
    add(metersTextComponent);

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
        gameRef.player.attack();
      },
      button: Sprite(game.images.fromCache('hud/attack.png')),
      position: Vector2(630, 256),
      anchor: Anchor.bottomRight,
      size: Vector2(320, 200),
    )..positionType = PositionType.viewport;
    add(attackButtonComponent);

    // Listeners for player data
    gameRef.playerData.distance.addListener(onPointsChange);
    gameRef.playerData.hp.addListener(onHpChange);
    gameRef.playerData.coins.addListener(onCoinsChange);
    gameRef.playerData.currentLevel.addListener(onCurrLevelChange);
    gameRef.playerData.bullets.addListener(onBulletsChange);

    return super.onLoad();
  }

  @override
  void onRemove() {
    gameRef.playerData.distance.removeListener(onPointsChange);
    gameRef.playerData.hp.removeListener(onHpChange);
    gameRef.playerData.coins.removeListener(onCoinsChange);
    gameRef.playerData.currentLevel.removeListener(onCurrLevelChange);
    gameRef.playerData.bullets.removeListener(onBulletsChange);
    super.onRemove();
  }

  void onPointsChange() {
    metersTextComponent.text = '${gameRef.playerData.distance.value}m';
  }

  void onHpChange() {
    healthTextComponent.text = '${gameRef.playerData.hp.value}';

    if (gameRef.playerData.hp.value == 0) {
      removeAll([
        metersTextComponent,
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

  void onBulletsChange() {
    //
  }
}
