import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interactive_darts/Assets/dart_bord_segment.dart';

class DartBoard extends StatefulWidget {
  final String type;
  final void Function(int segment, String ring) onScoreChanged;

  const DartBoard({
    required this.type,
    required this.onScoreChanged,
    super.key,
  });

  @override
  State<DartBoard> createState() => _DartBoardState();
}

class _DartBoardState extends State<DartBoard> {
  final List<int> allSegments = [
    20,
    1,
    18,
    4,
    13,
    6,
    10,
    15,
    2,
    17,
    3,
    19,
    7,
    16,
    8,
    11,
    14,
    9,
    12,
    5,
  ];

  @override
  Widget build(BuildContext context) {
    final double boardSize = 1.sw;
    if (widget.type == 'normal'){
    return Stack(
      children: [
        GestureDetector(
          onTap: () => widget.onScoreChanged(0, 'outside'),
          child: Image(
            height: boardSize,
            width: boardSize,
            image: AssetImage('images/dart_board.png'),
          ),
        ),

        // Draw all segments for single, triple, double rings
        for (final segment in allSegments)
          for (final ring in [Ring.single, Ring.triple, Ring.double])
            DartBoardSegment(
              boardSize: boardSize,
              isFilledIn: false,
              segmentNumber: segment,
              ring: ring,
              onTap: (segment, ring) => widget.onScoreChanged(segment, ring),
            ),

        // Outer Bull (25)
        DartBoardSegment(
          boardSize: boardSize,
          isFilledIn: false,
          segmentNumber: 25,
          ring: Ring.outerBull,
          onTap: (segment, ring) => widget.onScoreChanged(segment, ring),
        ),

        // Bullseye (50)
        DartBoardSegment(
          boardSize: boardSize,
          isFilledIn: false,
          segmentNumber: 50,
          ring: Ring.bull,
          onTap: (segment, ring) => widget.onScoreChanged(segment, ring),
        ),
      ],
    );
  }

  return Container();
  }
}
