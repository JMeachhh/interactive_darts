import 'package:flutter/material.dart';
import 'dart:math' as math;

class DartBoardSegment extends StatelessWidget {
  final int segmentNumber;
  final double boardSize;
  final Ring ring;
  final Color segmentColour;
  final void Function(int segment, String ring) onTap;

  const DartBoardSegment({
    super.key,
    required this.segmentNumber,
    required this.boardSize,
    required this.ring,
    required this.onTap,
    required this.segmentColour,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: boardSize,
          height: boardSize,
          child: ClipPath(
            clipper: SegmentClipper(
                segmentNumber: segmentNumber, ring: ring, Gesture: true),
            child: GestureDetector(
              onTap: () => onTap(segmentNumber, ring.name),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        SizedBox(
          width: boardSize,
          height: boardSize,
          child: ClipPath(
            clipper: SegmentClipper(
                segmentNumber: segmentNumber, ring: ring, Gesture: false),
            child: GestureDetector(
              onTap: () => onTap(segmentNumber, ring.name),
              child: Container(
                color: segmentColour,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum Ring { single, triple, double, outerBull, bull }

class SegmentClipper extends CustomClipper<Path> {
  final int segmentNumber;
  final Ring ring;
  final bool Gesture;

  SegmentClipper(
      {required this.segmentNumber, required this.ring, required this.Gesture});

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    if (ring == Ring.bull) {
      final bullRadius = radius * 0.035;

      return Path()
        ..addOval(Rect.fromCircle(center: center, radius: bullRadius));
    }

    if (ring == Ring.outerBull) {
      final outerBullInnerRadius = radius * 0.035;
      // final outerBullOuterRadius = radius * 0.08;
      final outerBullOuterRadius = radius * 0.04;

      final outerRect =
          Rect.fromCircle(center: center, radius: outerBullOuterRadius);
      final innerRect =
          Rect.fromCircle(center: center, radius: outerBullInnerRadius);

      final path = Path()
        ..addOval(outerRect)
        ..addOval(innerRect)
        ..fillType = PathFillType.evenOdd;
      return path;
    }

    const segmentCount = 20;
    const segmentAngle = 2 * math.pi / segmentCount;
    const angleCorrection = 2 * (math.pi / 180);

    final segmentIndex = mapDartNumberToIndex(segmentNumber);
    final angleStart =
        (segmentIndex - 0.5) * segmentAngle - math.pi / 2 + angleCorrection;
    final angleEnd = angleStart + segmentAngle;

    final rings = {
      Ring.single: [Gesture ? radius * 0.08 : radius * 0.065, radius * 0.72],
      Ring.triple: [
        Gesture ? radius * 0.41 : radius * 0.44,
        Gesture ? radius * 0.52 : radius * 0.48
      ],
      Ring.double: [radius * 0.72, Gesture ? radius * 0.8 : radius * 0.77],
    };

    final innerRadius = rings[ring]![0];
    final outerRadius = rings[ring]![1];

    final outerRect = Rect.fromCircle(center: center, radius: outerRadius);
    final innerRect = Rect.fromCircle(center: center, radius: innerRadius);

    final path = Path()
      ..moveTo(center.dx + innerRadius * math.cos(angleStart),
          center.dy + innerRadius * math.sin(angleStart))
      ..lineTo(center.dx + outerRadius * math.cos(angleStart),
          center.dy + outerRadius * math.sin(angleStart))
      ..arcTo(outerRect, angleStart, segmentAngle, false)
      ..lineTo(center.dx + innerRadius * math.cos(angleEnd),
          center.dy + innerRadius * math.sin(angleEnd))
      ..arcTo(innerRect, angleEnd, -segmentAngle, false)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

int mapDartNumberToIndex(int segmentNumber) {
  switch (segmentNumber) {
    case 20:
      return 0;
    case 1:
      return 1;
    case 18:
      return 2;
    case 4:
      return 3;
    case 13:
      return 4;
    case 6:
      return 5;
    case 10:
      return 6;
    case 15:
      return 7;
    case 2:
      return 8;
    case 17:
      return 9;
    case 3:
      return 10;
    case 19:
      return 11;
    case 7:
      return 12;
    case 16:
      return 13;
    case 8:
      return 14;
    case 11:
      return 15;
    case 14:
      return 16;
    case 9:
      return 17;
    case 12:
      return 18;
    case 5:
      return 19;
    default:
      return 0;
  }
}
