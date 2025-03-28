import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:jump_adventure/obstacle.dart';
import 'package:jump_adventure/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JumpGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Player player;
  late List<Obstacle> obstacles;
  late TextComponent scoreText;
  late TextComponent highScoreText;
  late AudioPool jumpSoundPool;
  bool isGameOver = false;
  double obstacleSpawnTimer = 0;

  // 스피드업 팝업
  bool speedUpVisible = false;
  double speedUpTimer = 0;

  // Speed and size thresholds
  double obstacleSpeed = 200.0;
  double obstacleSize = 40.0;
  double obstacleHeight = 40.0;

  static const double obstacleSpawnInterval = 2.0;
  static const double groundHeight = 100.0;
  static const double playerStartX = 50.0;
  static const String highScoreKey = 'highScore';

  int score = 0;
  int highScore = 0;

  JumpGame({required int initialHighScore}) {
    highScore = initialHighScore;
  }

  @override
  Future<void> onLoad() async {
    // 점프 사운드 로드
    jumpSoundPool = await AudioPool.create(
      source: AssetSource('sounds/jump.mp3'),
      maxPlayers: 3,
    );

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

    // 점수 텍스트 초기화
    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(20, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
    add(scoreText);

    highScoreText = TextComponent(
      text: 'High Score: $highScore',
      position: Vector2(size.x - 200, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
    add(highScoreText);





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
      obstacle.position.x -= obstacleSpeed * dt; // Update speed dynamically

      // 장애물이 플레이어를 통과했을 때 점수 증가
      if (!obstacle.isScored && obstacle.position.x < playerStartX - 30) {
        score++;
        scoreText.text = 'Score: $score';
        obstacle.isScored = true;
      }

      // 화면 밖으로 나간 장애물 제거
      if (obstacle.position.x < -50) {
        obstaclesToRemove.add(obstacle);
      }
    }

    // 점수에 따라 장애물 속도 및 크기 변경
    obstacleSpeed = 200.0 + (score * 10);  // Smoothly increase speed
    obstacleSize = 50.0 + (score * 5);     // Increase width with score
    obstacleHeight = 50.0 + (score * 5);   // Increase height with score

    // If speed has changed, display "Speed Up!" message for 1.5 seconds
    if (score >= 2 && score < 5 && !speedUpVisible) {
      speedUpVisible = true;
      addSpeedUpMessage();

      if(score == 5){
        speedUpVisible = false;
      }

    }

    if (speedUpVisible) {
      speedUpTimer += dt;
      if (speedUpTimer >= 1.5) {
        speedUpVisible = false;
        speedUpTimer = 0;
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
    // 장애물의 높이가 증가할 때 위로도 커지도록 y좌표 조정
    final obstacleY = size.y - groundHeight - 30 - (obstacleHeight - 40) / 2;

    final obstacle = Obstacle(
      position: Vector2(size.x, obstacleY),
      size: Vector2(obstacleSize, obstacleHeight),
    );
    add(obstacle);
    obstacles.add(obstacle);
  }

  void gameOver() async {
    isGameOver = true;

    // 최고 점수 업데이트
    if (score > highScore) {
      highScore = score;
      highScoreText.text = 'High Score: $highScore';

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

      // speedUp 제거
      speedUpVisible = false;

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
    score = 0;
    scoreText.text = 'Score: 0';
  }

  void playerJump() {
    if (!isGameOver) {
      player.jump();
      // 점프 사운드 재생
      jumpSoundPool.start();
    }
  }

  void playerLie() {
    if (!isGameOver) {
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

  void addSpeedUpMessage() {
    final speedUpText = TextComponent(
      text: 'Speed Up!',
      position: Vector2(size.x / 2 - 100, size.y / 2 - 50),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
    );
    add(speedUpText);
  }
}
