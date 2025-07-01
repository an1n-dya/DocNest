import 'package:hive/hive.dart';

part 'document_model.g.dart';

@HiveType(typeId: 1)
class Document extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  final String path;

  @HiveField(3)
  final DateTime addedDate;

  @HiveField(4)
  final String thumbnailPath;

  Document({
    required this.id,
    required this.name,
    required this.path,
    required this.addedDate,
    required this.thumbnailPath,
  });
}
