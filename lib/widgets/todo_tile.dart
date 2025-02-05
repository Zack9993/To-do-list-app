import 'package:flutter/material.dart';
import 'package:myapp/models/todo_item.dart';
import 'package:myapp/widgets/checklist_tile.dart';

class TodoTile extends StatelessWidget {
  final TodoItem todo;
  final VoidCallback onToggleCompletion;
  final VoidCallback onDelete;
  final Function(TodoItem) onEdit;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggleCompletion,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (value) => onToggleCompletion(),
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration:
                    todo.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(todo.formattedDueDate), // Displays the due date in 12-hour format
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    onEdit(todo);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
          if (todo.checklist.isNotEmpty)
            ...todo.checklist.map((item) => ChecklistTile(
                  checklistItem: item,
                  onToggleCompletion: () {
                    item.toggleCompletion();
                  },
                )),
        ],
      ),
    );
  }
}