import 'package:flutter/material.dart';
import 'package:myapp/models/todo_item.dart';
import 'package:myapp/widgets/todo_tile.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _todos = [];
  final TextEditingController _textEditingController = TextEditingController();

  void _addTodo() {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        _todos.add(TodoItem(title: _textEditingController.text));
        _textEditingController.clear(); // Clear the text field after adding
      });
    }
  }

  void _toggleCompletion(int index) {
    setState(() {
      _todos[index].toggleCompletion();
    });
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      labelText: 'Add a task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _todos.isEmpty
                ? const Center(child: Text('No tasks yet!'))
                : ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      return TodoTile(
                        todo: _todos[index],
                        onToggleCompletion: () => _toggleCompletion(index),
                        onDelete: () => _removeTodo(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}