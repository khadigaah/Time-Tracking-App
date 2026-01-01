import 'package:flutter/material.dart';
import 'package:time_tracking_app/models/add_model.dart';
import '../utils/formatters.dart';

class ProjectGroupCard extends StatelessWidget {
  final String projectName;
  final List<TimeEntry> entries;
  final String Function(String taskId) getTaskName;

  const ProjectGroupCard({
    super.key,
    required this.projectName,
    required this.entries,
    required this.getTaskName,
  });

  @override
  Widget build(BuildContext context) {
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
            ...entries.map((e) {
              final taskName = getTaskName(e.taskId);
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '- $taskName: ${hoursText(e.totalTime)} (${formatDatePretty(e.date)})',
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
