import 'package:cotrak/BackgroundPainter.dart';
import 'package:flutter/material.dart';

const CURVE_HEIGHT = 300.0;

class CurvedShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: CURVE_HEIGHT,
      child: CustomPaint(
        painter: BackgroundPainter(),
      ),
    );
  }
}
