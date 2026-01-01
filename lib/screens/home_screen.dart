import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:time_tracking_app/dialogs/menu_drawer.dart';
import 'package:time_tracking_app/models/add_model.dart';
import 'package:time_tracking_app/provider/time_entry_provider.dart';
import 'package:time_tracking_app/screens/add_time_entry_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const AppMenuDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            'Time Tracker',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Color(0xFFFFD54F),
            indicatorWeight: 5,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'All Entries'),
              Tab(text: 'Grouped by Projects'),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            // ---------------- Tab 1: All Entries ----------------
            Consumer<TimeEntryProvider>(
              builder: (context, provider, child) {
                final entries = provider.entries;

                if (entries.isEmpty) {
                  return _emptyState();
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final TimeEntry e = entries[index];

                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${e.projectId} - ${e.taskId}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2F8F86), 
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Total Time: ${_hoursText(e.totalTime)}'),
                                  const SizedBox(height: 2),
                                  Text('Date: ${_formatDatePretty(e.date)}'),
                                  const SizedBox(height: 2),
                                  Text('Note: ${e.notes}'),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => provider.deleteTimeEntry(e.id),
                              tooltip: 'Delete',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // ---------------- Tab 2: Grouped by Projects ----------------
            Consumer<TimeEntryProvider>(
              builder: (context, provider, child) {
                final grouped = provider.entriesGroupedByProject;

                if (grouped.isEmpty) {
                  return _emptyState();
                }

                final projectNames = grouped.keys.toList()..sort();

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: projectNames.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final projectName = projectNames[index];
                    final list = grouped[projectName] ?? [];

                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              projectName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2F8F86),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...list.map((e) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  '- ${e.taskId}: ${_hoursText(e.totalTime)} (${_formatDatePretty(e.date)})',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.yellowAccent[700],
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTimeEntryScreen()),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

Widget _emptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Icon(Icons.hourglass_empty, size: 80, color: Colors.black26),
        SizedBox(height: 20),
        Text(
          'No time entries yet!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        SizedBox(height: 6),
        Text(
          'Tap the + button to add your first entry.',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ],
    ),
  );
}

String _hoursText(double hours) {
  if (hours == hours.roundToDouble()) return '${hours.toInt()} hours';
  return '${hours.toStringAsFixed(2)} hours';
}

String _formatDatePretty(DateTime d) {
  const months = [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec'
  ];
  return '${months[d.month - 1]} ${d.day}, ${d.year}';
}
