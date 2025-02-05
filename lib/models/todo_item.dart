import 'package:intl/intl.dart';
import 'package:myapp/models/checklist_item.dart';

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
    // Use DateFormat to format the date and time in 12-hour format
    return DateFormat('yyyy-MM-dd h:mm a').format(dueDate);
  }

  void toggleCompletion() {
    isCompleted = !isCompleted;
  }
}