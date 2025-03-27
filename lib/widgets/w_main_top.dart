import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jump_adventure/providers/game_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'body/w_game.dart';

class ScoreWidget extends ConsumerStatefulWidget {
  const ScoreWidget({super.key});

  @override
  ConsumerState<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends ConsumerState<ScoreWidget> {
  int highScore = 0;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    // 주기적으로 점수 업데이트
    _updateTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameProvider);
    final currentScore = (game as JumpGame).score;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Score: $currentScore',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            'High Score: $highScore',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
        ],
      ),
    );
  }
} 