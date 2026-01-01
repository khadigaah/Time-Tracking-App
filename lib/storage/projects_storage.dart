import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/add_model.dart';

class ProjectsStorage {
  static const _key = 'projects';

  static Future<void> saveProjects(List<Project> projects) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = projects.map((p) => {'id': p.id, 'name': p.name}).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  static Future<List<Project>> loadProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_key);
    if (s == null) return [];

    final decoded = (jsonDecode(s) as List).cast<dynamic>();
    return decoded.map((e) {
      final map = Map<String, dynamic>.from(e as Map);
      return Project(
        id: map['id'] as String,
        name: map['name'] as String,
      );
    }).toList();
  }
}
