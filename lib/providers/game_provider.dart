import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game.dart';
import '../services/local_storage.dart';

/// 게임 상태를 나타내는 Enum
/// - `initial`: 게임 시작 전 상태
/// - `playing`: 게임이 진행 중인 상태
/// - `paused`: 게임이 일시 정지된 상태
/// - `gameOver`: 게임 오버 상태
enum GameState {
  initial,
  playing,
  paused,
  gameOver,
}

/// 플레이어 상태를 나타내는 Enum
/// - `idle`: 플레이어가 대기 중인 상태
/// - `jumping`: 플레이어가 점프 중인 상태
/// - `doubleJumping`: 플레이어가 이단 점프 중인 상태
/// - `lying`: 플레이어가 엎드려 있는 상태
enum PlayerState {
  idle,
  jumping,
  doubleJumping,
  lying,
}

/// JumpGame을 관리하는 Notifier 클래스
/// 하나의 Notifier에서 게임 상태, 플레이어 상태, 점수를 모두 관리
class GameNotifier extends Notifier<JumpGame> {
  GameState gameState = GameState.initial;
  PlayerState playerState = PlayerState.idle;
  int score = 0;
  int highScore = 0;

  @override
  JumpGame build() {
    // 초기 최고 점수는 0으로 설정
    highScore = 0;
    
    // JumpGame을 초기화
    final game = JumpGame(initialHighScore: highScore);
    
    // 비동기로 최고 점수를 로드
    _loadHighScore();
    
    return game;
  }

  Future<void> _loadHighScore() async {
    final loadedHighScore = await LocalStorage.instance.readInt(key: 'highScore') ?? 0;
    highScore = loadedHighScore;
    state = JumpGame(initialHighScore: highScore);
  }

  void playerJump() {
    if (gameState == GameState.playing) {
      playerState = PlayerState.jumping;
      state.playerJump();
    }
  }

  void playerLie() {
    if (gameState == GameState.playing) {
      playerState = PlayerState.lying;
      state.playerLie();
    }
  }

  void startGame() {
    gameState = GameState.playing;
    score = 0;
    state.onLoad();
  }

  void gameOver() {
    gameState = GameState.gameOver;
    state.gameOver();
  }

  void incrementScore() {
    if (gameState == GameState.playing) {
      score++;
    }
  }
}

final gameProvider = NotifierProvider<GameNotifier, JumpGame>(
  GameNotifier.new,
  name: 'gameProvider[JumpGame]',
);
