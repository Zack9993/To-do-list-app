class ChecklistItem {
  String title;
  bool isCompleted;

  ChecklistItem({required this.title, this.isCompleted = false});

  void toggleCompletion() {
    isCompleted = !isCompleted;
  }
}