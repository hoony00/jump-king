import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jump_adventure/providers/game_provider.dart';
import 'package:jump_adventure/widgets/w_main_top.dart';
import 'package:jump_adventure/widgets/w_main_bottom.dart';

import '../widgets/body/w_game.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScoreWidget(),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final game = ref.watch(gameProvider);
                  final jumpGame = game as JumpGame;

                  return GameWidget(
                    game: jumpGame,
                  );
                }
              ),
            ),
            const ControlsWidget(),
          ],
        ),
      ),
    );
  }
}