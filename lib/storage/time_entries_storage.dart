import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/add_model.dart';

class TimeEntriesStorage {
  static const _key = 'time_entries';

  static Future<void> saveEntries(List<TimeEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = entries.map((e) => {
      'id': e.id,
      'projectId': e.projectId,
      'taskId': e.taskId,
      'totalTime': e.totalTime,
      'date': e.date.millisecondsSinceEpoch,
      'notes': e.notes,
    }).toList();

    await prefs.setString(_key, jsonEncode(jsonList));
  }

  static Future<List<TimeEntry>> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_key);
    if (s == null) return [];

    final decoded = (jsonDecode(s) as List).cast<dynamic>();
    return decoded.map((x) {
      final m = Map<String, dynamic>.from(x as Map);
      return TimeEntry(
        id: m['id'] as String,
        projectId: m['projectId'] as String,
        taskId: m['taskId'] as String,
        totalTime: (m['totalTime'] as num).toDouble(),
        date: DateTime.fromMillisecondsSinceEpoch(m['date'] as int),
        notes: m['notes'] as String,
      );
    }).toList();
  }
}
