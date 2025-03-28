import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jump_adventure/providers/game_provider.dart';

class ControlsWidget extends ConsumerWidget {
  const ControlsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 점프 버튼
          ElevatedButton(
            onPressed: () {
              print("Jump button pressed");
              game.playerJump();
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(24),
              backgroundColor: Colors.blue,
              elevation: 5,
            ),
            child: const Icon(
              Icons.keyboard_arrow_up,
              size: 48,
              color: Colors.white,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
              backgroundColor: Colors.red,
              elevation: 5,
            ),
            child: const Icon(
              Icons.home,
              size: 24,
              color: Colors.white,
            ),
          ),
          // 엎드리기/일어서기 버튼
          ElevatedButton(
            onPressed: () {
              print("Slide button pressed");
              game.playerLie();
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(24),
              backgroundColor: Colors.green,
              elevation: 5,
            ),
            child: const Icon(
              Icons.keyboard_arrow_down,
              size: 48,
              color: Colors.white,
            ),
          ),



        ],
      ),
    );
  }
}
