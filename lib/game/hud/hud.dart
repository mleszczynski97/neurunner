import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:neurunner/game/game.dart';
import 'package:neurunner/game/managers/audio_manager.dart';
import 'package:neurunner/game/screens/game_over.dart';
import 'package:neurunner/game/screens/pause_menu.dart';

class Hud extends PositionComponent with HasGameRef<NeurunnerGame> {
  late final TextComponent distanceTextComponent;
  late final TextComponent healthTextComponent;
  late final TextComponent coinsTextComponent;
  late final SpriteComponent heartComponent;
  late final SpriteComponent coinComponent;
  late final SpriteComponent levelComponent;
  late final SpriteComponent embersComponent;
  late final SpriteButtonComponent pauseButtonComponent;
  late final SpriteButtonComponent attackButtonComponent;
  late final SpriteButtonComponent jumpButtonComponent;

  Hud({super.children, super.priority}) {
    positionType = PositionType.viewport;
  }

  @override
  FutureOr<void> onLoad() async {
    distanceTextComponent = TextComponent(
      text: '0m',
      position: Vector2(320, 0),
      anchor: Anchor.topCenter,
      scale: Vector2.all(0.7),
    );
    add(distanceTextComponent);

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

    embersComponent = SpriteComponent.fromImage(
      game.images.fromCache('hud/embers_hud.png'),
      position: Vector2(320, 256),
      anchor: Anchor.bottomCenter,
      size: Vector2(90,36),
    );
    add(embersComponent);

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

    levelComponent = SpriteComponent.fromImage(
      game.images.fromCache('hud/level1.png'),
      position: Vector2(320, 128),
      anchor: Anchor.center,
    );
    add(levelComponent);
    levelComponent.add(OpacityEffect.fadeOut(EffectController(duration: 5)));

    // Listeners for player data
    gameRef.playerData.distance.addListener(onDistanceChange);
    gameRef.playerData.hp.addListener(onHpChange);
    gameRef.playerData.coins.addListener(onCoinsChange);
    gameRef.playerData.bullets.addListener(onBulletsChange);

    return super.onLoad();
  }

  @override
  void onRemove() {
    gameRef.playerData.distance.removeListener(onDistanceChange);
    gameRef.playerData.hp.removeListener(onHpChange);
    gameRef.playerData.coins.removeListener(onCoinsChange);
    gameRef.playerData.bullets.removeListener(onBulletsChange);
    super.onRemove();
  }

  void onDistanceChange() {
    distanceTextComponent.text = '${gameRef.playerData.distance.value}m';
    if (gameRef.playerData.distance.value % 800 == 0) {
      final int level = (gameRef.playerData.distance.value ~/ 800) + 1;
      final String path = 'hud/level$level.png';
      levelComponent.sprite = Sprite(game.images.fromCache(path));
      level == 1
          ? gameRef.player.velocityX = 100
          : gameRef.player.velocityX += 25;
      levelComponent.add(OpacityEffect.fadeIn(EffectController(
        duration: 3,
        alternate: true,
      )));
    }
  }

  void onHpChange() {
    if (gameRef.playerData.hp.value > 100) {
      // Keeping hp max at 100
      gameRef.playerData.hp.value = 100;
    } else {
      // Heart component pulsing effect
      heartComponent.add(
        OpacityEffect.fadeOut(
          EffectController(
            duration: 0.3,
            alternate: true,
          ),
          onComplete: () {},
        ),
      );
    }

    // Updating the hp values displayed
    healthTextComponent.text = '${gameRef.playerData.hp.value}';

    if (gameRef.playerData.hp.value == 0) {
      removeAll([
        distanceTextComponent,
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
    coinComponent.add(SizeEffect.by(
        Vector2.all(3),
        EffectController(
          duration: 0.1,
          alternate: true,
        )));
  }

  void onBulletsChange() {
    //
  }
}
