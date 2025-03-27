import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Obstacle extends PositionComponent with CollisionCallbacks {
  bool isScored = false;  // 점수 계산 여부를 추적하는 변수

  Obstacle({
    required Vector2 position,
    required Vector2 size,  // Accept dynamic size
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // 장애물의 크기와 색상 설정
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = Colors.green,
      ),
    );

    // Hitbox 설정 (장애물의 충돌 범위)
    add(RectangleHitbox(
      size: size,
      position: Vector2.zero(),
    ));
  }
}
