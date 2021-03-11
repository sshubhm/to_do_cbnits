class Task {
  String? description;
  DateTime? createdAt;
  DateTime? completedAt;
  bool? isCompleted;
  DateTime? updatedAt;
  int? id;

  Task();

  Map<String, dynamic> toJson() => {'description': description, 'id': id};

  Task.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        id = json['id'],
        createdAt = DateTime.parse(json['created_at']),
        completedAt = json['completed_at'] == null
            ? null
            : DateTime.parse(json['completed_at']),
        isCompleted = json['completed_at'] == null ? false : true;
}
