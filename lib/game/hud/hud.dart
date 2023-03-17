import 'dart:async';

import 'package:flame/components.dart';
import 'package:neurunner/game/game.dart';

class Hud extends Component with HasGameRef<NeurunnerGame> {
  Hud({super.children, super.priority}) {
    positionType = PositionType.viewport;
  }

  @override
  FutureOr<void> onLoad() async {
    final scoreTextComponent = TextComponent(text: 'Score: 0');
    add(scoreTextComponent);
    return super.onLoad();
  }
}
