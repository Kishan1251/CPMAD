import 'package:flutter_test/flutter_test.dart';
import 'package:todo_api_crud/models/todo_model.dart';

void main() {
  test('Todo.fromJson supports title and todo fields', () {
    final todo = Todo.fromJson({
      'id': '12',
      'title': 'Submission task',
      'completed': true,
    });

    expect(todo.id, 12);
    expect(todo.title, 'Submission task');
    expect(todo.completed, isTrue);
  });

  test('Todo.toJson produces API-compatible data', () {
    final todo = Todo(id: 3, title: 'Test task', completed: false);

    expect(todo.toJson(), {'id': 3, 'title': 'Test task', 'completed': false});
  });
}
