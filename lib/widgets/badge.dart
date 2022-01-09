import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Badge extends StatelessWidget {
  final double top;
  final double right;
  final Widget child;
  final String value;

  const Badge({
    Key? key,
    required this.child,
    required this.value,
    this.top = 0.0,
    this.right = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.00),
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          Positioned(
            right: right,
            top: top,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Container(
                key: ValueKey(value),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xffff738e),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
