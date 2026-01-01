import 'package:flutter/material.dart';
import 'package:time_tracking_app/models/add_model.dart';
import 'package:time_tracking_app/storage/projects_storage.dart';

class ProjectProvider with ChangeNotifier {
  List<Project> _projects = [];
  bool _loaded = false;

  List<Project> get projects => List.unmodifiable(_projects);

  Future<void> init() async {
    if (_loaded) return;

    _projects = await ProjectsStorage.loadProjects();

    if (_projects.isEmpty) {
      _projects = [
        Project(id: '1', name: 'Project Alpha'),
        Project(id: '2', name: 'Project Beta'),
        Project(id: '3', name: 'Project Gamma'),
      ];
      await ProjectsStorage.saveProjects(_projects);
    }

    _loaded = true;
    notifyListeners();
  }

  Future<void> addProject(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    _projects.add(Project(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: trimmed,
    ));

    notifyListeners();
    await ProjectsStorage.saveProjects(_projects);
  }

  Future<void> deleteProject(String id) async {
    _projects.removeWhere((p) => p.id == id);

    notifyListeners();
    await ProjectsStorage.saveProjects(_projects);
  }

  Project? getById(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
