import 'package:flutter/foundation.dart';

class PlayerData {
  final points = ValueNotifier<int>(0);
  final hp = ValueNotifier<int>(100);
  final coins = ValueNotifier<int>(0);
  final currentLevel = ValueNotifier<int>(1);
  final bullets = ValueNotifier<int>(3);
}
