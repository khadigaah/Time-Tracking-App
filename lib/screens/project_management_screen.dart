import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking_app/provider/project_provider.dart';
import '../dialogs/add_project_dialog.dart';

class ProjectManagementScreen extends StatelessWidget {
  const ProjectManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<ProjectProvider>().init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: const Text(
              'Manage Projects',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
          ),

          body: Consumer<ProjectProvider>(
            builder: (context, provider, child) {
              final projects = provider.projects;

              if (projects.isEmpty) {
                return const Center(child: Text('No projects yet'));
              }

              return ListView.separated(
                itemCount: projects.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final p = projects[index];
                  return ListTile(
                    title: Text(p.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        await provider.deleteProject(p.id);
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
              showAddProjectDialog(
                context: context,
                onAdd: (name) async {
                  await context.read<ProjectProvider>().addProject(name);
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
