import 'package:flutter/material.dart';
import 'models/todo_model.dart';
import 'services/todo_api_service.dart';

void main() {
  runApp(
    const MaterialApp(
      home: TodoApp(),
    ),
  );
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final TodoApiService _apiService = TodoApiService();
  final TextEditingController _titleController = TextEditingController();

  List<Todo> _todos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _fetchTodos() async {
    setState(() => _isLoading = true);
    final list = await _apiService.getTodos();
    setState(() {
      _todos = list;
      _isLoading = false;
    });
  }

  void _addTodo() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    _titleController.clear();
    final newTodo = await _apiService.createTodo(title);

    setState(() {
      _todos.insert(0, newTodo);
    });
  }

  void _toggleComplete(Todo todo, bool? newValue) async {
    if (newValue == null) return;

    setState(() {
      todo.completed = newValue;
    });

    await _apiService.updateTodoStatus(todo.id, newValue);
  }

  void _deleteTodo(Todo todo) async {
    setState(() {
      _todos.removeWhere((t) => t.id == todo.id);
    });

    await _apiService.deleteTodo(todo.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo CRUD App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter title',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _addTodo,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      return CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        value: todo.completed,
                        onChanged: (val) => _toggleComplete(todo, val),
                        title: Text(todo.title),
                        secondary: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteTodo(todo),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
