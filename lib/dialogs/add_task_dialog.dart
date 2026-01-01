import 'package:flutter/material.dart';

Future<void> showAddTaskDialog({
  required BuildContext context,
  required void Function(String name) onAdd,
}) async {
  final controller = TextEditingController();

  await showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Task Name',
          ),
          onSubmitted: (_) {
            final name = controller.text.trim();
            if (name.isNotEmpty) {
              onAdd(name);
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              onAdd(name);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}
