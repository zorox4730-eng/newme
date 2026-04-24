import 'package:uuid/uuid.dart';

enum TaskPriority { high, medium, low }

class Task {
  final String id;
  String title;
  bool isCompleted;
  TaskPriority priority;
  DateTime createdAt;

  Task({
    String? id,
    required this.title,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
        'priority': priority.index,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        isCompleted: json['isCompleted'],
        priority: TaskPriority.values[json['priority']],
        createdAt: DateTime.parse(json['createdAt']),
      );
}

class JournalEntry {
  final String id;
  String content;
  DateTime timestamp;

  JournalEntry({
    String? id,
    required this.content,
    DateTime? timestamp,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
        id: json['id'],
        content: json['content'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
