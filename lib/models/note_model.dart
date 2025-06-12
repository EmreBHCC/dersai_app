import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final int color;

  @HiveField(3)
  final DateTime? reminderTime; // Bildirim/Alarm zamanı

  @HiveField(4)
  final List<String> tags;

  NoteModel({
    required this.title,
    required this.content,
    required this.color,
    this.reminderTime,
    this.tags = const [],
  });
}
