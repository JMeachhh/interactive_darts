import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interactive_darts/Assets/player.dart';
import 'package:interactive_darts/Assets/player_manager.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PlayerDetailPopUp {
  static final ImagePicker _picker = ImagePicker();

  static void edit(BuildContext context, Player player) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: player.name);
    File? imageFile;
    String imagePath = player.imagePath;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          Future<void> pickImage(ImageSource source) async {
            final pickedFile =
                await _picker.pickImage(source: source, maxWidth: 600);
            if (pickedFile != null) {
              imageFile = File(pickedFile.path);
              imagePath = pickedFile.path;
              setState(() {});
            }
          }

          return AlertDialog(
              title: Center(child: const Text("Edit Player")),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final source = await showModalBottomSheet<ImageSource>(
                          context: context,
                          builder: (context) => SafeArea(
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.camera_alt),
                                  title: Text('Take a Photo'),
                                  onTap: () => Navigator.of(context)
                                      .pop(ImageSource.camera),
                                ),
                                ListTile(
                                  leading: Icon(Icons.photo_library),
                                  title: Text('Choose from Gallery'),
                                  onTap: () => Navigator.of(context)
                                      .pop(ImageSource.gallery),
                                ),
                              ],
                            ),
                          ),
                        );
                        if (source != null) await pickImage(source);
                      },
                      child: CircleAvatar(
                        radius: 80.r,
                        backgroundImage: imageFile != null
                            ? FileImage(imageFile!)
                            : imagePath.startsWith('/')
                                ? FileImage(File(imagePath))
                                : AssetImage(imagePath) as ImageProvider,
                      ),
                    ),
                    SizedBox(height: 0.05.sw),
                    Form(
                      key: formKey,
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Player Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 0.05.sw),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            Provider.of<PlayerManager>(context, listen: false)
                                .removePlayer(player);
                            Navigator.of(context).pop();
                          },
                          child: Text('Remove Player'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final updatedPlayer = Player(
                                id: player.id,
                                name: nameController.text.trim(),
                                imagePath: imagePath,
                                score: player.score
                              );
                              Provider.of<PlayerManager>(context, listen: false)
                                  .updatePlayer(updatedPlayer);
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
      },
    );
  }

  static void create(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    File? imageFile;
    String imagePath = 'images/placeholder_user.png';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          Future<void> pickImage(ImageSource source) async {
            final pickedFile =
                await _picker.pickImage(source: source, maxWidth: 600);
            if (pickedFile != null) {
              imageFile = File(pickedFile.path);
              imagePath = pickedFile.path;
              setState(() {});
            }
          }

          return AlertDialog(
            title: Center(child: const Text("Edit Player")),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final source = await showModalBottomSheet<ImageSource>(
                        context: context,
                        builder: (context) => SafeArea(
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('Take a Photo'),
                                onTap: () => Navigator.of(context)
                                    .pop(ImageSource.camera),
                              ),
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('Choose from Gallery'),
                                onTap: () => Navigator.of(context)
                                    .pop(ImageSource.gallery),
                              ),
                            ],
                          ),
                        ),
                      );
                      if (source != null) await pickImage(source);
                    },
                    child: CircleAvatar(
                      radius: 80.r,
                      backgroundImage: imageFile != null
                          ? FileImage(imageFile!)
                          : AssetImage(imagePath) as ImageProvider,
                    ),
                  ),
                  SizedBox(height: 0.05.sw),
                  Form(
                    key: formKey,
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Player Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 0.05.sw),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final newPlayer = Player(
                          id: const Uuid().v4(),
                          name: nameController.text.trim(),
                          imagePath: imagePath,
                          score : 0
                        );
                        Provider.of<PlayerManager>(context, listen: false)
                            .addPlayer(newPlayer);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
