import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking_app/dialogs/field_label.dart';
import 'package:time_tracking_app/models/add_model.dart';
import 'package:time_tracking_app/provider/time_entry_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key});

  @override
  State<AddTimeEntryScreen> createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _projects = const ['Project Alpha', 'Project Beta', 'Project Gamma','Project Delta'];
  final List<String> _tasks = const ['Task A', 'Task B', 'Task C', 'Task D', 'Task E'];

  String? projectId;
  String? taskId;

  DateTime date = DateTime.now();
  double totalTime = 0.0;
  String notes = '';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => date = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    Provider.of<TimeEntryProvider>(context, listen: false).addTimeEntry(
      TimeEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        projectId: projectId!,
        taskId: taskId!,      
        totalTime: totalTime,
        date: date,
        notes: notes,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final appBarColor = Theme.of(context).appBarTheme.backgroundColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Time Entry'),
        centerTitle: true,
        backgroundColor: appBarColor, 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FieldLabel('Project'),
              DropdownButtonFormField<String>(
                initialValue: projectId,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(fontSize: 18, color: Colors.black87,),
                hint: const Text(
                  'Select Project',
                  style: TextStyle(fontSize: 18, color: Colors.black38,),
                ),
                items: _projects
                    .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p),
                        ))
                    .toList(),
                validator: (v) => v == null ? 'Please select a project' : null,
                onChanged: (v) => setState(() => projectId = v),
                onSaved: (v) => projectId = v,
              ),
              const SizedBox(height: 18),

              const FieldLabel('Task'),
              DropdownButtonFormField<String>(
                initialValue: taskId,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(fontSize: 18, color: Colors.black87),
                hint: const Text(
                  'Select Task',
                  style: TextStyle(fontSize: 18, color: Colors.black38),
                ),
                items: _tasks
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t),
                        ))
                    .toList(),
                validator: (v) => v == null ? 'Please select a task' : null,
                onChanged: (v) => setState(() => taskId = v),
                onSaved: (v) => taskId = v,
              ),
              const SizedBox(height: 18),

              Text(
                'Date: ${formatDate(date)}',
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: _pickDate,
                style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
                child: const Text('Select Date'),
              ),
              const SizedBox(height: 22),

              const FieldLabel('Total Time (in hours)'),
              TextFormField(
                initialValue: '',
                decoration: const InputDecoration(
                  hintText: '1',
                  border: UnderlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Please enter total time';
                  final d = double.tryParse(value.trim());
                  if (d == null) return 'Please enter a valid number';
                  if (d <= 0) return 'Must be > 0';
                  return null;
                },
                onSaved: (value) => totalTime = double.parse(value!.trim()),
              ),
              const SizedBox(height: 22),

              const FieldLabel('Notes'),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Write your notes...',
                  border: OutlineInputBorder(),
                ),
                minLines: 3,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Please enter some notes';
                  return null;
                },
                onSaved: (value) => notes = value!.trim(),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  label: const Text('Save Entry'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10, ),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}