import 'package:flutter/cupertino.dart';

class AnimatedFlowerBackground extends StatefulWidget {
  @override
  _AnimatedFlowerBackgroundState createState() => _AnimatedFlowerBackgroundState();
}

class _AnimatedFlowerBackgroundState extends State<AnimatedFlowerBackground> {
  final int flowerCount = 15;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(flowerCount, (index) {
        // 각 벚꽃 이미지의 애니메이션 시작 위치와 끝 위치를 설정
        double startPosition = (index * 30) % MediaQuery.of(context).size.width.toDouble();
        double endPosition = -100.0;  // 벚꽃이 화면을 지나가면 끝나는 위치

        return AnimatedPositioned(
          left: startPosition,
          top: -50.0 + index * 20.0,  // 벚꽃이 화면에 랜덤하게 배치되도록
          duration: Duration(seconds: 5 + index % 3),  // 애니메이션 지속 시간
          curve: Curves.linear,
          child: Image.asset(
            'assets/images/flower.png',
            width: 30.0 + (index % 3) * 10,  // 각 벚꽃 크기 랜덤
            height: 30.0 + (index % 3) * 10,
          ),
        );
      }),
    );
  }
}