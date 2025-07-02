import 'package:hive/hive.dart';

part 'document_type.g.dart';

@HiveType(typeId: 4)
enum DocumentType {
  @HiveField(0)
  pdf,
  @HiveField(1)
  image,
}
