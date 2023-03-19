import 'game_constants.dart' as constants;
import 'package:neurunner/game/models/player_data.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'components/player.dart';

class NeurunnerGame extends FlameGame with HasCollisionDetection, HasTappables {
  NeurunnerGame();
  NeurunnerPlayer player = NeurunnerPlayer(position: constants.initPosition);
  final playerData = PlayerData();

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    camera.viewport = FixedResolutionViewport(Vector2(640, 256));

    return super.onLoad();
  }


  @override
  void update(dt) {
    super.update(dt);
  }
}
