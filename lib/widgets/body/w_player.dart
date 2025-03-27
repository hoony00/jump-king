import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent with CollisionCallbacks {
  static const double jumpForce = 600;
  static const double gravity = 1500;
  double verticalVelocity = 0;
  bool isJumping = false;
  bool isLying = false;
  final Vector2 originalSize = Vector2(50, 50);
  final Vector2 lyingSize = Vector2(50, 25);
  final double groundY;
  late SpriteComponent playerSprite;

  Player({
    required Vector2 position,
    required this.groundY,
  }) : super(position: position, size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    // 이미지 로드 (파일 경로는 assets 폴더에 추가된 이미지 경로로 수정)
    final spriteImage = await Flame.images.load('player.png'); // 이미지 로드
    playerSprite = SpriteComponent()
      ..sprite = Sprite(spriteImage)  // Sprite 생성
      ..size = size;

    add(playerSprite);
    add(RectangleHitbox()); // 충돌 처리
  }

  void jump() {
    print("Jump called, isJumping: $isJumping, isLying: $isLying");
    if (!isJumping && position.y >= groundY) {
      print("Starting jump from y: ${position.y}");
      verticalVelocity = -jumpForce;
      isJumping = true;
      if (isLying) {
        standUp();
      }
    }
  }

  void lie() {
    print("Lie called, isJumping: $isJumping, isLying: $isLying");
    if (!isJumping && !isLying && position.y >= groundY) {
      isLying = true;
      size = lyingSize;
      playerSprite.size = lyingSize;  // lying 상태에서의 크기 변경
      position.y = groundY + (originalSize.y - lyingSize.y);
      print("Player lying down at y: ${position.y}");
    } else if (isLying) {
      standUp();
    }
  }

  void standUp() {
    if (isLying) {
      isLying = false;
      size = originalSize;
      playerSprite.size = originalSize;  // stand 상태에서의 크기 변경
      position.y = groundY;
      print("Player standing up at y: ${position.y}");
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isJumping) {
      position.y += verticalVelocity * dt;
      verticalVelocity += gravity * dt;

      if (position.y >= groundY) {
        position.y = groundY;
        verticalVelocity = 0;
        isJumping = false;
        print("Landing at y: ${position.y}");
      }
    }
  }
}
