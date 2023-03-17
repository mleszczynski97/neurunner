import 'dart:ui';

import 'package:flame/components.dart';

// Platform module and level bounds dimensions
const double moduleHeight = 256.0;
const double moduleWidth = 800.0;
const int moduleMax = 100000;
const Rect levelBounds =
    Rect.fromLTWH(0, 0, moduleWidth * moduleMax, moduleHeight);

// Initial position for player
const double initialPosition = 80.0;
final Vector2 initPosition = Vector2(initialPosition, initialPosition);
