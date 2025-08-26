import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interactive_darts/Assets/dart_board_segment.dart';

class DartBoard extends StatefulWidget {
  final String type;
  final void Function(int segment, String ring) onScoreChanged;

  const DartBoard({
    required this.type,
    required this.onScoreChanged,
    super.key,
  });

  @override
  State<DartBoard> createState() => DartBoardState();
}

class DartBoardState extends State<DartBoard> {
  // Changing colours
  void changeColours(List<Map<String, dynamic>> updates) {
    setState(() {
      for (var update in updates) {
        final int number = update['number'];
        final Color colour = update['colour'];
        for (var segment in allSegments) {
          if (segment['number'] == number) {
            segment['colour'] = colour.withOpacity(0.7);
            break;
          }
        }
      }
    });
  }

  void resetBoard() {
    for (var segment in allSegments) {
      segment['colour'] = Colors.transparent;
    }
    setState(() {});
  }

  List<Map<String, dynamic>> allSegments = [
    {'number': 20, 'colour': Colors.transparent},
    {'number': 1, 'colour': Colors.transparent},
    {'number': 18, 'colour': Colors.transparent},
    {'number': 4, 'colour': Colors.transparent},
    {'number': 13, 'colour': Colors.transparent},
    {'number': 6, 'colour': Colors.transparent},
    {'number': 10, 'colour': Colors.transparent},
    {'number': 15, 'colour': Colors.transparent},
    {'number': 2, 'colour': Colors.transparent},
    {'number': 17, 'colour': Colors.transparent},
    {'number': 3, 'colour': Colors.transparent},
    {'number': 19, 'colour': Colors.transparent},
    {'number': 7, 'colour': Colors.transparent},
    {'number': 16, 'colour': Colors.transparent},
    {'number': 8, 'colour': Colors.transparent},
    {'number': 11, 'colour': Colors.transparent},
    {'number': 14, 'colour': Colors.transparent},
    {'number': 9, 'colour': Colors.transparent},
    {'number': 12, 'colour': Colors.transparent},
    {'number': 5, 'colour': Colors.transparent},
  ];

  @override
  Widget build(BuildContext context) {
    final double boardSize = 1.sw;
    if (widget.type == 'normal') {
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
                segmentNumber: segment['number'],
                segmentColour: segment['colour'],
                ring: ring,
                onTap: (segment, ring) => widget.onScoreChanged(segment, ring),
              ),

          // Outer Bull (25)
          DartBoardSegment(
            boardSize: boardSize,
            segmentNumber: 25,
            segmentColour: Colors.transparent,
            ring: Ring.outerBull,
            onTap: (segment, ring) => widget.onScoreChanged(segment, ring),
          ),

          // Bullseye (50)
          DartBoardSegment(
            boardSize: boardSize,
            segmentNumber: 50,
            segmentColour: Colors.transparent,
            ring: Ring.bull,
            onTap: (segment, ring) => widget.onScoreChanged(segment, ring),
          ),
        ],
      );
    }

    return Container();
  }
}
