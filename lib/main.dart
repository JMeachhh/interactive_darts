import 'package:flutter/material.dart';
import 'package:interactive_darts/Assets/player_manager.dart';
import 'package:interactive_darts/pages/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => PlayerManager(),
      child: InteractiveDarts(),
    ),
  );
}

class InteractiveDarts extends StatelessWidget {
  const InteractiveDarts({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Google Pixel 4 XL
      designSize: Size(411, 869),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        );
      },
    );
  }
}
