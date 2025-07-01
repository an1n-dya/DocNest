import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'folder_model.g.dart';

@HiveType(typeId: 2)
class Folder extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  final IconData icon;

  @HiveField(3)
  List<String> documentIds;

  Folder({
    required this.id,
    required this.name,
    this.icon = Icons.folder_rounded,
    required this.documentIds,
  });
}

// Hive cannot store IconData directly, so we create a serializable adapter.
@HiveType(typeId: 3)
class IconDataAdapter extends TypeAdapter<IconData> {
  @override
  final int typeId = 3;

  @override
  IconData read(BinaryReader reader) {
    return IconData(reader.readInt(), fontFamily: 'MaterialIcons');
  }

  @override
  void write(BinaryWriter writer, IconData obj) {
    writer.writeInt(obj.codePoint);
  }
}
