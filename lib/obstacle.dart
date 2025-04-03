import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';  // 이미지 로딩을 위해 필요

class Obstacle extends PositionComponent with CollisionCallbacks {
  bool isScored = false;  // 점수 계산 여부를 추적하는 변수
  late Sprite sprite;  // 이미지로 사용될 스프라이트 변수

  Obstacle({
    required Vector2 position,
    required Vector2 size,  // Accept dynamic size
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // 이미지 로딩
    sprite = await Sprite.load('dummy.png');

    // 장애물의 크기와 색상 대신 이미지로 렌더링
    add(
      SpriteComponent(
        sprite: sprite,
        size: size,
      ),
    );

    // Hitbox 설정 (장애물의 충돌 범위)
    add(RectangleHitbox(
      size: size,
      position: Vector2.zero(),
    ));
  }
}
