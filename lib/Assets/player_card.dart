import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// assets
import 'package:interactive_darts/Assets/player.dart';
import 'package:interactive_darts/Assets/player_detail_pop_up.dart';

class PlayerCard extends StatelessWidget {
  Player? player;
  PlayerCard({super.key, this.player});

  @override
  Widget build(BuildContext context) {
    Color? backgroundColour = Colors.blue[300];
    Color? fontColour = Colors.white;

    ImageProvider imageProvider;

    if (player != null && player!.imagePath.startsWith('/')) {
      imageProvider = FileImage(File(player!.imagePath));
    } else {
      imageProvider = AssetImage(
        player != null ? player!.imagePath : 'images/placeholder_user.png',
      );
    }
    return GestureDetector(
      onTap: () {
        if (player != null) {
          PlayerDetailPopUp.edit(context, player!);
        } else {
          PlayerDetailPopUp.create(context);
        }
      },
      child: Container(
        height: 0.35.sw,
        width: 0.75.sw,
        color: backgroundColour,
        child: Row(
          children: [
            SizedBox(width: 0.05.sw),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image(
                image: imageProvider,
                height: 0.25.sw,
                width: 0.25.sw,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 0.05.sw,
            ),
            Expanded(
              child: player != null
                  ? Column(
                      children: [
                        Text(
                          player!.name,
                          style: TextStyle(
                              fontSize: 0.05.sw,
                              fontWeight: FontWeight.bold,
                              color: fontColour),
                        ),
                        Text(
                          "Tap to edit",
                          style: TextStyle(
                              fontSize: 0.05.sw,
                              fontWeight: FontWeight.bold,
                              color: fontColour),
                        ),
                      ],
                    )
                  : Text(
                      "Tap to add player",
                      style: TextStyle(
                          fontSize: 0.05.sw,
                          fontStyle: FontStyle.italic,
                          color: fontColour),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
