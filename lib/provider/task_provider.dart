import 'package:flutter/material.dart';
import 'package:time_tracking_app/models/add_model.dart';
import 'package:time_tracking_app/storage/task_storage.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _loaded = false;

  List<Task> get tasks => List.unmodifiable(_tasks);

  Future<void> init() async {
    if (_loaded) return;

    _tasks = await TasksStorage.loadTasks();

    if (_tasks.isEmpty) {
      _tasks = [
        Task(id: '1', name: 'Task A'),
        Task(id: '2', name: 'Task B'),
        Task(id: '3', name: 'Task C'),
      ];
      await TasksStorage.saveTasks(_tasks);
    }

    _loaded = true;
    notifyListeners();
  }

  Future<void> addTask(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    _tasks.add(Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: trimmed,
    ));

    notifyListeners();
    await TasksStorage.saveTasks(_tasks);
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);

    notifyListeners();
    await TasksStorage.saveTasks(_tasks);
  }

  Task? getById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
