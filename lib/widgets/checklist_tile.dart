import 'package:flutter/material.dart';
import 'package:myapp/models/checklist_item.dart';

class ChecklistTile extends StatelessWidget {
  final ChecklistItem checklistItem;
  final VoidCallback onToggleCompletion;

  const ChecklistTile({
    super.key,
    required this.checklistItem,
    required this.onToggleCompletion,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: checklistItem.isCompleted,
        onChanged: (value) => onToggleCompletion(),
      ),
      title: Text(
        checklistItem.title,
        style: TextStyle(
          decoration: checklistItem.isCompleted
              ? TextDecoration.lineThrough
              : null,
        ),
      ),
    );
  }
}