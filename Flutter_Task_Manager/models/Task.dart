class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final int priority;
  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String assignedTo;
  final List<String> attachments;
  final String category;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    required this.assignedTo,
    required this.attachments,
    required this.category,
    required this.completed,
  });

  // ✅ Thêm copyWith ở đây
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    int? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? assignedTo,
    List<String>? attachments,
    String? category,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedTo: assignedTo ?? this.assignedTo,
      attachments: attachments ?? this.attachments,
      category: category ?? this.category,
      completed: completed ?? this.completed,
    );
  }

  // ✅ fromJson
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'] ?? "",
      title: json['title'] ?? "Chưa có tiêu đề",
      description: json['description'] ?? "",
      status: json['status'] ?? "Chưa xác định",
      priority: json['priority'] is int
          ? json['priority']
          : int.tryParse(json['priority'].toString()) ?? 0,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      assignedTo: json['assignedTo'] ?? "",
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : [],
      category: json['category'] ?? 'Chưa phân loại',
      completed: json['completed'] is bool
          ? json['completed']
          : json['completed'].toString().toLowerCase() == "true",
    );
  }

  // ✅ toJson
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status,
    'priority': priority,
    'dueDate': dueDate.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'assignedTo': assignedTo,
    'attachments': attachments,
    'category': category,
    'completed': completed,
  };
}
