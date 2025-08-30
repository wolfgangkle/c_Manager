import 'package:hive/hive.dart';

part 'certificate.g.dart';

@HiveType(typeId: 0)
class Certificate extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime expiry;

  @HiveField(2)
  String filePath;

  @HiveField(3)
  List<String> tags;

  @HiveField(4)
  bool notifications;

  @HiveField(5) // ✅ Add a new Hive field index
  String issuer;

  Certificate({
    required this.title,
    required this.expiry,
    required this.filePath,
    required this.tags,
    required this.notifications,
    required this.issuer, // ✅ Include in constructor
  });
}
