import 'package:flutter/foundation.dart';
import 'package:time_tracking_app/models/add_model.dart';
import 'package:time_tracking_app/storage/time_entries_storage.dart';

class TimeEntryProvider with ChangeNotifier {
  List<TimeEntry> _entries = [];
  bool _loaded = false;

  List<TimeEntry> get entries => List.unmodifiable(_entries);

  Future<void> init() async {
    if (_loaded) return;
    _entries = await TimeEntriesStorage.loadEntries();
    _loaded = true;
    notifyListeners();
  }

  List<TimeEntry> get entriesSortedByDateDesc {
    final list = [..._entries];
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  Future<void> addTimeEntry(TimeEntry entry) async {
    _entries.add(entry);
    notifyListeners();
    await TimeEntriesStorage.saveEntries(_entries);
  }

  Future<void> updateTimeEntry(TimeEntry updated) async {
    final index = _entries.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;
    _entries[index] = updated;
    notifyListeners();
    await TimeEntriesStorage.saveEntries(_entries);
  }

  Future<void> deleteTimeEntry(String id) async {
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
    await TimeEntriesStorage.saveEntries(_entries);
  }

  /// Group entries by projectId (ID)
  Map<String, List<TimeEntry>> get entriesGroupedByProject {
    final Map<String, List<TimeEntry>> grouped = {};
    for (final e in _entries) {
      grouped.putIfAbsent(e.projectId, () => []);
      grouped[e.projectId]!.add(e);
    }
    return grouped;
  }

  List<TimeEntry> byProject(String projectId) =>
      _entries.where((e) => e.projectId == projectId).toList();

  List<TimeEntry> byTask(String taskId) =>
      _entries.where((e) => e.taskId == taskId).toList();

  Future<void> clear() async {
    _entries.clear();
    notifyListeners();
    await TimeEntriesStorage.saveEntries(_entries);
  }
}
