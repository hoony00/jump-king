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
          AnimatedButton(
            onPressed: () {
              print("Jump button pressed");
              game.playerJump();
            },
            icon: Icons.keyboard_arrow_up,
            color: Colors.blue,
            size: 48,
            scale: 1.2,
          ),
          // 홈 버튼
          AnimatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icons.home,
            color: Colors.red,
            size: 24,
            scale: 1.0,
          ),
          // 엎드리기/일어서기 버튼
          AnimatedButton(
            onPressed: () {
              print("Slide button pressed");
              game.playerLie();
            },
            icon: Icons.keyboard_arrow_down,
            color: Colors.green,
            size: 48,
            scale: 1.2,
          ),
        ],
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;
  final double size;
  final double scale;

  const AnimatedButton({
    required this.onPressed,
    required this.icon,
    required this.color,
    required this.size,
    required this.scale,
  });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _scale = widget.scale;
        });
      },
      onTapUp: (_) {
        setState(() {
          _scale = 1.0;
        });
      },
      onTapCancel: () {
        setState(() {
          _scale = 1.0;
        });
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _scale,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(24),
            backgroundColor: widget.color,
            elevation: 5,
          ),
          child: Icon(
            widget.icon,
            size: widget.size,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
