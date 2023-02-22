import 'package:flame/components.dart';

class Platform extends SpriteComponent with HasGameRef {
  static Vector2 kTileSize = Vector2.all(64);
  static const double velocity = 250;

  Platform({
    required Vector2 pos,
  }) : super(
          size: kTileSize,
          position: pos,
        );

  @override
  Future<void> onLoad() async {
    final groundImage = game.images.fromCache('platforms/grass_tile_32x32.png');
    sprite = Sprite(groundImage);
    size = Vector2(64, gameRef.size.y/8) ;
    
  }

  @override
  void update(double dt) {
    super.update(dt);

    // move left at constant velocity
    position.x -= velocity * dt;
  }

  static List<Platform> generateGroundTiles(int distance, double ySize) {
    //Empty list for ground tiles
    final groundTiles = <Platform>[];

    for (int i = 0; i < distance; i++) {
      // Calculate the position of the block
      double xPos = i * 64;
      double yPos = ySize - ySize/8;

      // Create a horizontal platform block using the tile sprite
      final groundTile = Platform(
        pos: Vector2(xPos, yPos),
      );
      groundTiles.add(groundTile);
    }
    return groundTiles;
  }
}
