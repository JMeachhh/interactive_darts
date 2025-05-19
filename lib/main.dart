import 'package:flutter/material.dart';
import 'package:interactive_darts/pages/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const InteractiveDarts());
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
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        );
      },
    );
  }
}
