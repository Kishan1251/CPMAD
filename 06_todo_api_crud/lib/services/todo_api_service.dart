import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/todo_model.dart';

/// TodoApiService implementing GET, POST, PUT, DELETE (Section 18)
class TodoApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/todos';

  // In-memory cache for instant feedback and offline responsiveness
  static final List<Todo> _localCache = [
    Todo(id: 1, title: 'Learn Dart fundamental OOP concepts', completed: true),
    Todo(
      id: 2,
      title: 'Build Flutter Stateful & Stateless widgets',
      completed: true,
    ),
    Todo(
      id: 3,
      title: 'Master SQLite Database with MVC pattern',
      completed: false,
    ),
    Todo(
      id: 4,
      title: 'Integrate Cloud Firestore real-time streams',
      completed: false,
    ),
  ];

  Future<List<Todo>> getTodos() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl?_limit=10'))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        final remote = list.map((item) => Todo.fromJson(item)).toList();
        if (remote.isNotEmpty) {
          _localCache.clear();
          _localCache.addAll(remote);
        }
      } else {
        throw Exception('Unable to load todos (${response.statusCode})');
      }
    } catch (_) {
      // Keep the local cache available when the API is unreachable.
    }
    return List.from(_localCache);
  }

  Future<Todo> createTodo(String title) async {
    final newId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final newTodo = Todo(id: newId, title: title, completed: false);

    try {
      final response = await http
          .post(
            Uri.parse(baseUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(newTodo.toJson()),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final created = Todo.fromJson(jsonDecode(response.body));
        if (created.title.isNotEmpty) {
          newTodo.title = created.title;
        }
      } else {
        throw Exception('Unable to create todo (${response.statusCode})');
      }
    } catch (_) {
      // Add locally when the API is unreachable.
    }

    _localCache.insert(0, newTodo);
    return newTodo;
  }

  Future<bool> updateTodoStatus(int id, bool completed) async {
    try {
      await http
          .put(
            Uri.parse('$baseUrl/$id'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'completed': completed}),
          )
          .timeout(const Duration(seconds: 4));
    } catch (_) {
      // Continue offline
    }

    final index = _localCache.indexWhere((t) => t.id == id);
    if (index != -1) {
      _localCache[index].completed = completed;
      return true;
    }
    return false;
  }

  Future<bool> deleteTodo(int id) async {
    try {
      await http
          .delete(Uri.parse('$baseUrl/$id'))
          .timeout(const Duration(seconds: 4));
    } catch (_) {
      // Continue offline
    }

    _localCache.removeWhere((t) => t.id == id);
    return true;
  }
}
