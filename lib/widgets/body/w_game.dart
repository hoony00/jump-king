import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:jump_adventure/widgets/body/w_obstacle.dart';
import 'package:jump_adventure/widgets/body/w_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JumpGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Player player;
  late List<Obstacle> obstacles;
  bool isGameOver = false;
  double obstacleSpawnTimer = 0;
  static const double obstacleSpawnInterval = 2.0;
  static const double groundHeight = 100.0;
  static const double playerStartX = 50.0;
  static const String highScoreKey = 'highScore';

  int score = 0;
  int highScore = 0;

  @override
  Future<void> onLoad() async {
    // 최고 점수 불러오기
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt(highScoreKey) ?? 0;

    // 배경 설정
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = const Color(0xFF87CEEB),
      ),
    );

    // 땅 추가
    final ground = RectangleComponent(
      size: Vector2(size.x, groundHeight),
      position: Vector2(0, size.y - groundHeight),
      paint: Paint()..color = const Color(0xFF8B4513),
    );
    add(ground);

    // 플레이어 초기화
    player = Player(
      groundY: size.y - groundHeight - 50,
      position: Vector2(playerStartX, size.y - groundHeight - 50),
    );
    add(player);

    // 장애물 리스트 초기화
    obstacles = [];

    // 게임 시작
    isGameOver = false;
    score = 0;
    obstacleSpawnTimer = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return;

    // 장애물 생성 타이머 업데이트
    obstacleSpawnTimer += dt;
    if (obstacleSpawnTimer >= obstacleSpawnInterval) {
      spawnObstacle();
      obstacleSpawnTimer = 0;
    }

    // 장애물 이동 및 제거, 점수 증가
    final obstaclesToRemove = <Obstacle>[];
    for (var obstacle in obstacles) {
      obstacle.position.x -= 200 * dt;
      
      // 장애물이 플레이어를 통과했을 때 점수 증가
      if (!obstacle.isScored && obstacle.position.x < playerStartX - 30) {  // 플레이어 크기를 고려한 위치
        score++;
        obstacle.isScored = true;
        print('Score increased: $score'); // 디버깅용 출력
      }

      // 화면 밖으로 나간 장애물 제거
      if (obstacle.position.x < -50) {
        obstaclesToRemove.add(obstacle);
      }
    }

    // 충돌 체크
    for (var obstacle in obstacles) {
      if (player.toRect().overlaps(obstacle.toRect())) {
        gameOver();
        break;
      }
    }

    // 장애물 제거
    for (var obstacle in obstaclesToRemove) {
      obstacles.remove(obstacle);
      obstacle.removeFromParent();
    }
  }

  void spawnObstacle() {
    final obstacle = Obstacle(
      position: Vector2(size.x, size.y - groundHeight - 30),
    );
    add(obstacle);
    obstacles.add(obstacle);
    print('Obstacle spawned'); // 디버깅용 출력
  }

  void gameOver() async {
    isGameOver = true;

    // 최고 점수 업데이트
    if (score > highScore) {
      highScore = score;

      // 최고 점수 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(highScoreKey, highScore);

      // 새로운 최고 점수 달성 메시지 표시
      add(
        TextComponent(
          text: 'New High Score!\nGame Over!\nTap to restart',
          position: Vector2(size.x / 2 - 100, size.y / 2),
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
        ),
      );
    } else {
      add(
        TextComponent(
          text: 'Game Over!\nTap to restart',
          position: Vector2(size.x / 2 - 100, size.y / 2),
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  void playerJump() {
    if (!isGameOver) {
      print("Game playerJump called");
      player.jump();
    }
  }

  void playerLie() {
    if (!isGameOver) {
      print("Game playerLie called");
      player.lie();
    }
  }

  @override
  void onTap() {
    if (isGameOver) {
      removeAll(children);
      onLoad();
    } else {
      playerJump();
    }
  }
}