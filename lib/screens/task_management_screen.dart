import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking_app/provider/task_provider.dart';

import '../dialogs/add_task_dialog.dart';

class TaskManagementScreen extends StatelessWidget {
  const TaskManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<TaskProvider>().init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: const Text('Manage Tasks', style: TextStyle(color: Colors.white)),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Consumer<TaskProvider>(
            builder: (context, provider, child) {
              final tasks = provider.tasks;

              if (tasks.isEmpty) {
                return const Center(child: Text('No tasks yet'));
              }

              return ListView.separated(
                itemCount: tasks.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final t = tasks[index];
                  return ListTile(
                    title: Text(t.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        await provider.deleteTask(t.id);
                      },
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.yellowAccent[700],
            onPressed: () {
              showAddTaskDialog(
                context: context,
                onAdd: (name) async {
                  await context.read<TaskProvider>().addTask(name);
                },
              );
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}
