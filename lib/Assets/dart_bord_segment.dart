import 'package:flutter/material.dart';
import 'dart:math' as math;

class DartBoardSegment extends StatelessWidget {
  final int segmentNumber;
  final bool isFilledIn;
  final double boardSize;
  final Ring ring;
  final void Function(int segment, String ring) onTap;

  const DartBoardSegment({
    super.key,
    required this.segmentNumber,
    required this.isFilledIn,
    required this.boardSize,
    required this.ring,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (ring) {
      case Ring.single:
        color = isFilledIn
            ? const Color.fromARGB(150, 255, 205, 210)
            : const Color.fromARGB(0, 255, 205, 210);
        break;
      case Ring.triple:
        color = isFilledIn
            ? const Color.fromARGB(150, 102, 187, 106)
            : const Color.fromARGB(0, 102, 187, 106);
        break;
      case Ring.double:
        color = isFilledIn
            ? const Color.fromARGB(150, 211, 47, 47)
            : const Color.fromARGB(0, 211, 47, 47);
        break;
      case Ring.outerBull:
        color = isFilledIn
            ? const Color.fromARGB(150, 102, 187, 106)
            : const Color.fromARGB(0, 102, 187, 106);
        break;
      case Ring.bull:
        color = isFilledIn
            ? const Color.fromARGB(150, 229, 115, 115)
            : const Color.fromARGB(0, 229, 115, 115);
        break;
    }

    return SizedBox(
      width: boardSize,
      height: boardSize,
      child: ClipPath(
        clipper: SegmentClipper(segmentNumber: segmentNumber, ring: ring),
        child: GestureDetector(
          onTap: () => onTap(segmentNumber, ring.name),
          child: Container(color: color),
        ),
      ),
    );
  }
}

enum Ring { single, triple, double, outerBull, bull }

class SegmentClipper extends CustomClipper<Path> {
  final int segmentNumber;
  final Ring ring;

  SegmentClipper({
    required this.segmentNumber,
    required this.ring,
    super.reclip,
  });

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Handle bull rings separately
    if (ring == Ring.bull) {
      final bullRadius = radius * 0.035; // Bull radius
      return Path()
        ..addOval(Rect.fromCircle(center: center, radius: bullRadius));
    }

    if (ring == Ring.outerBull) {
      final outerBullInnerRadius = radius * 0.035;
      final outerBullOuterRadius = radius * 0.08;

      final outerRect =
          Rect.fromCircle(center: center, radius: outerBullOuterRadius);
      final innerRect =
          Rect.fromCircle(center: center, radius: outerBullInnerRadius);

      final path = Path()
        ..addOval(outerRect)
        ..addOval(innerRect)
        ..fillType = PathFillType.evenOdd; // Ring shape
      return path;
    }

    // Normal segment logic for single, triple, double

    // Map dart number to segment index (0-19)
    final segmentIndex = mapDartNumberToIndex(segmentNumber);

    const segmentCount = 20;
    const segmentAngle = 2 * math.pi / segmentCount;

    // Small correction to center segments nicely
    const angleCorrection = 2 * (math.pi / 180);

    final angleStart =
        (segmentIndex - 0.5) * segmentAngle - math.pi / 2 + angleCorrection;
    final angleEnd = angleStart + segmentAngle;

    // Radii for rings (as fractions of radius)
    final rings = {
      Ring.single: [radius * 0.08, radius * 0.72],
      Ring.triple: [radius * 0.41, radius * 0.52],
      Ring.double: [radius * 0.72, radius * 0.8],
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
