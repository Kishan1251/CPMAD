/// Todo Model matching Udemy Section 18
class Todo {
  final int id;
  String title;
  bool completed;

  Todo({required this.id, required this.title, this.completed = false});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      title: (json['title'] ?? json['todo'] ?? '').toString(),
      completed: json['completed'] is bool
          ? json['completed'] as bool
          : json['completed'].toString().toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'completed': completed,
  };
}
