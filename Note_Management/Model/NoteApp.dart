import 'dart:convert';

class Note {
  final int? id;
  final String title;
  final String content;
  final int priority;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final List<String>? tags;
  final String? color;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.createdAt,
    required this.modifiedAt,
    this.tags,
    this.color,
  });

  factory Note.fromMap(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    priority: json['priority'],
    createdAt: DateTime.parse(json['createdAt']),
    modifiedAt: DateTime.parse(json['modifiedAt']),
    tags: json['tags'] != null
        ? List<String>.from(json['tags'])
        : null,
    color: json['color'],
  );


  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'priority': priority,
    'createdAt': createdAt.toIso8601String(),
    'modifiedAt': modifiedAt.toIso8601String(),
    'tags': tags != null ? jsonEncode(tags) : null,
    'color': color,
  };

  // JSON encode for API or storage
  String toJSON() => jsonEncode(toMap());

  Note copyWith({
    int? id,
    String? title,
    String? content,
    int? priority,
    DateTime? createdAt,
    DateTime? modifiedAt,
    List<String>? tags,
    String? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      tags: tags ?? this.tags,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return 'Note(id: \$id, title: \$title, priority: \$priority, tags: \$tags, color: \$color)';
  }
}