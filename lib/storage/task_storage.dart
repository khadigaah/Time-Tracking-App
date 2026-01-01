import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/add_model.dart'; 

class TasksStorage {
  static const _key = 'tasks';

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = tasks.map((t) => {'id': t.id, 'name': t.name}).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_key);
    if (s == null) return [];

    final decoded = (jsonDecode(s) as List).cast<dynamic>();
    return decoded.map((e) {
      final map = Map<String, dynamic>.from(e as Map);
      return Task(
        id: map['id'] as String,
        name: map['name'] as String,
      );
    }).toList();
  }
}
