import 'package:flutter/foundation.dart';

class PlayerData {
  final alive = ValueNotifier(true);
  final hp = ValueNotifier<int>(100);
  final distance = ValueNotifier<int>(0);
  final coins = ValueNotifier<int>(0);
  final bullets = ValueNotifier<int>(0);
}
