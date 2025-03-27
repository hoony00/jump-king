import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jump_adventure/providers/game_provider.dart';
import 'package:jump_adventure/widgets/w_main_bottom.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GameWidget(
                game: game,
              ),
            ),
            const ControlsWidget(),
          ],
        ),
      ),
    );
  }
}