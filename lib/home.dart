import 'package:flame/components.dart';
import 'package:flame/events.dart';

class HomeIcon extends SpriteComponent {
  final Function onTapCallback;

  HomeIcon({
    required Vector2 position,
    required Vector2 size,
    required this.onTapCallback,  // Callback function for navigation
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    // 홈 아이콘 로딩
    sprite = await Sprite.load('home.png');

    add(
      SpriteComponent(
        sprite: sprite,
        size: size,
      ),
    );
  }

  // Implement onTapDown manually for tap detection
  void onTapDown(TapDownInfo info) {
    onTapCallback();  // Navigate or perform another action
  }
}
