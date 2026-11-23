import 'package:flutter/material.dart';
import 'models/todo_model.dart';
import 'services/todo_api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TodoCrudScreen(),
  ));
}


/// Udemy Course - Section 18: Todo App with CRUD operations using API without GetX
/// Demonstrates:
/// - Pure Flutter StatefulWidget state management using setState()
/// - HTTP CRUD Operations: GET list, POST create, PUT status update, DELETE item
/// - Row with Expanded input field and add button
/// - CheckboxListTile with leading control affinity and trailing delete action
class TodoCrudScreen extends StatefulWidget {
  const TodoCrudScreen({super.key});

  @override
  State<TodoCrudScreen> createState() => _TodoCrudScreenState();
}

class _TodoCrudScreenState extends State<TodoCrudScreen> {
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

  Future<void> _fetchTodos() async {
    setState(() => _isLoading = true);
    final list = await _apiService.getTodos();
    setState(() {
      _todos = list;
      _isLoading = false;
    });
  }

  Future<void> _addTodo() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    _titleController.clear();
    final newTodo = await _apiService.createTodo(title);

    setState(() {
      _todos.removeWhere((t) => t.id == newTodo.id);
      _todos.insert(0, newTodo);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo added via API POST')),
      );
    }
  }

  Future<void> _toggleComplete(Todo todo, bool? newValue) async {
    if (newValue == null) return;

    // Optimistic UI update using setState as taught in Section 18
    setState(() {
      todo.completed = newValue;
    });

    await _apiService.updateTodoStatus(todo.id, newValue);
  }

  Future<void> _deleteTodo(Todo todo) async {
    setState(() {
      _todos.removeWhere((t) => t.id == todo.id);
    });

    await _apiService.deleteTodo(todo.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deleted "${todo.title}"')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo CRUD (API Without GetX)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Todos',
            onPressed: _fetchTodos,
          ),
        ],
      ),
      body: Column(
        children: [
          // Input row with Expanded TextField and Add button (Section 18)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter new task (e.g. Learn Flutter)...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: _addTodo,
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Todo',
                ),
              ],
            ),
          ),

          // Todo List with leading Checkbox and trailing Delete
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _todos.isEmpty
                    ? const Center(
                        child: Text(
                          'No tasks yet. Add one above!',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _todos.length,
                        separatorBuilder: (context, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final todo = _todos[index];
                          return CheckboxListTile(
                            // Leading control affinity as explained in Section 18
                            controlAffinity: ListTileControlAffinity.leading,
                            value: todo.completed,
                            onChanged: (val) => _toggleComplete(todo, val),
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                fontSize: 16,
                                decoration: todo.completed
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: todo.completed ? Colors.grey : Colors.black87,
                              ),
                            ),
                            secondary: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              tooltip: 'Delete',
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