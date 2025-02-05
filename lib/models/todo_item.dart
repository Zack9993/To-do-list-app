import 'package:intl/intl.dart';
import 'checklist_item.dart';

class TodoItem {
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  List<ChecklistItem> checklist;

  TodoItem({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.checklist = const [],
  });

  String get formattedDueDate {
    return DateFormat('yyyy-MM-dd HH:mm').format(dueDate);
  }

  void toggleCompletion() {
    isCompleted = !isCompleted;
  }
}