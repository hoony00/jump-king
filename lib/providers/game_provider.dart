import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/body/w_game.dart';  // JumpGame import

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

  @override
  JumpGame build() {
    final game = JumpGame();
    return game;
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
