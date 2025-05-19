import 'package:uuid/uuid.dart';

class Player {
  final String id;
  final String name;
  final String imagePath;

  Player({
    required this.id,
    required this.name,
    required this.imagePath,
  });

  // Factory to create a new player with a generated ID
  factory Player.create({required String name, required String imagePath}) {
    return Player(id: const Uuid().v4(), name: name, imagePath: imagePath);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imagePath': imagePath,
      };

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      imagePath: json['imagePath'],
    );
  }
}
