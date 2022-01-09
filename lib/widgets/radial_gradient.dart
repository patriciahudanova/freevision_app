import 'package:flutter/cupertino.dart';

class RadiantGradientMask extends StatelessWidget {
  const RadiantGradientMask({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          const RadialGradient(center: Alignment.topRight, radius: 1, colors: [
        Color(0xfffffa8e),
        Color(0xffff8f8e),
        Color(0xffff738e),
        // Color(0xff5ee9ff),
        // Color(0xff64ffc8),
      ], stops: [
        0.2,
        0.6,
        // 0.9,
        // 0.95,
        1
      ]).createShader(bounds),
      child: child,
    );
  }
}
