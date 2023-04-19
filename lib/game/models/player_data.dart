import 'package:flutter/foundation.dart';

class PlayerData {
  final distance = ValueNotifier<int>(0);
  final hp = ValueNotifier<int>(100);
  final coins = ValueNotifier<int>(0);
  final bullets = ValueNotifier<int>(0);
}
