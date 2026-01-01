import 'package:flutter/material.dart';
import 'package:time_tracking_app/models/add_model.dart';
import '../utils/formatters.dart';

class EntryCard extends StatelessWidget {
  final TimeEntry entry;
  final String projectName;
  final String taskName;
  final VoidCallback onDelete;

  const EntryCard({
    super.key,
    required this.entry,
    required this.projectName,
    required this.taskName,
    required this.onDelete,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$projectName - $taskName',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2F8F86),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Total Time: ${hoursText(entry.totalTime)}'),
                  const SizedBox(height: 2),
                  Text('Date: ${formatDatePretty(entry.date)}'),
                  const SizedBox(height: 2),
                  Text('Note: ${entry.notes}'),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
