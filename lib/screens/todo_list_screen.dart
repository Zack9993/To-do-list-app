import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/checklist_item.dart';
import 'package:myapp/models/todo_item.dart';
import 'package:myapp/utils/notification_service.dart';
import 'package:myapp/widgets/todo_tile.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _todos = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _checklistController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    NotificationService.initialize();
  }

  void _addTodo() {
    if (_titleController.text.isNotEmpty && _selectedDate != null) {
      setState(() {
        _todos.add(
          TodoItem(
            title: _titleController.text,
            description: _descriptionController.text,
            dueDate: _selectedDate!,
            checklist: [],
          ),
        );
        _titleController.clear();
        _descriptionController.clear();
        _selectedDate = null;

        // Schedule notification
        NotificationService.scheduleNotification(
          id: _todos.length,
          title: 'Task Reminder',
          body: _titleController.text,
          scheduledTime: _selectedDate!,
        );
      });
    }
  }

  void _editTodo(int index, TodoItem originalTodo) {
    _titleController.text = originalTodo.title;
    _descriptionController.text = originalTodo.description;
    _selectedDate = originalTodo.dueDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Set Due Date'),
                ),
                const SizedBox(width: 8),
                Text(_selectedDate == null
                    ? 'No date selected'
                    : DateFormat('yyyy-MM-dd h:mm a').format(_selectedDate!)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty && _selectedDate != null) {
                setState(() {
                  _todos[index] = TodoItem(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    dueDate: _selectedDate!,
                    checklist: originalTodo.checklist,
                    isCompleted: originalTodo.isCompleted,
                  );

                  // Reschedule notification
                  NotificationService.scheduleNotification(
                    id: index,
                    title: 'Task Reminder',
                    body: _titleController.text,
                    scheduledTime: _selectedDate!,
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
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

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
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
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Task Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('Set Due Date'),
                    ),
                    const SizedBox(width: 8),
                    Text(_selectedDate == null
                        ? 'No date selected'
                        : DateFormat('yyyy-MM-dd h:mm a').format(_selectedDate!)),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: const Text('Add Task'),
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
                        onEdit: (todo) => _editTodo(index, todo),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Checklist Item'),
              content: TextField(
                controller: _checklistController,
                decoration:
                    const InputDecoration(hintText: 'Enter checklist item'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (_checklistController.text.isNotEmpty &&
                        _todos.isNotEmpty) {
                      setState(() {
                        _todos.last.checklist.add(
                          ChecklistItem(title: _checklistController.text),
                        );
                        _checklistController.clear();
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}