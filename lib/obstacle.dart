import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Obstacle extends PositionComponent with CollisionCallbacks {
  bool isScored = false;  // 점수 계산 여부를 추적하는 변수

  Obstacle({required Vector2 position}) : super(position: position, size: Vector2(30, 30)) {
 //   debugMode = true;  // 충돌 박스 시각화 (디버깅용)
  }

  @override
  Future<void> onLoad() async {
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = Colors.green,
      ),
    );
    add(RectangleHitbox(
      size: size,
      position: Vector2.zero(),
    ));
  }
}