import 'package:flutter/material.dart';

import 'models/todo_model.dart';
import 'services/todo_api_service.dart';

void main() {
  runApp(const TodoApiCrudApp());
}

class TodoApiCrudApp extends StatelessWidget {
  const TodoApiCrudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo CRUD',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const TodoApp(),
    );
  }
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
    if (!mounted) return;
    setState(() {
      _todos = list;
      _isLoading = false;
    });
  }

  void _addTodo() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _showMessage('Please enter a todo title.');
      return;
    }

    try {
      final newTodo = await _apiService.createTodo(title);
      if (!mounted) return;
      _titleController.clear();
      setState(() => _todos.insert(0, newTodo));
      _showMessage('Todo added');
    } catch (_) {
      if (mounted) _showMessage('Could not add the todo.');
    }
  }

  void _toggleComplete(Todo todo, bool? newValue) async {
    if (newValue == null) return;

    final previousValue = todo.completed;
    setState(() {
      todo.completed = newValue;
    });

    try {
      await _apiService.updateTodoStatus(todo.id, newValue);
    } catch (_) {
      if (!mounted) return;
      setState(() => todo.completed = previousValue);
      _showMessage('Could not update the todo.');
    }
  }

  void _deleteTodo(Todo todo) async {
    final index = _todos.indexWhere((item) => item.id == todo.id);
    setState(() {
      _todos.removeWhere((t) => t.id == todo.id);
    });

    try {
      await _apiService.deleteTodo(todo.id);
      if (mounted) _showMessage('Todo deleted');
    } catch (_) {
      if (!mounted) return;
      setState(() {
        if (index >= 0 && index <= _todos.length) {
          _todos.insert(index, todo);
        }
      });
      _showMessage('Could not delete the todo.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo CRUD'),
        actions: [
          IconButton(
            tooltip: 'Refresh todos',
            onPressed: _isLoading ? null : _fetchTodos,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _addTodo(),
                    decoration: const InputDecoration(
                      labelText: 'Todo title',
                      hintText: 'Enter a new todo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _addTodo,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _todos.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline, size: 64),
                        SizedBox(height: 12),
                        Text('No todos yet'),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
                    itemCount: _todos.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      return CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        value: todo.completed,
                        onChanged: (val) => _toggleComplete(todo, val),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        secondary: IconButton(
                          tooltip: 'Delete todo',
                          icon: const Icon(Icons.delete_outline),
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
