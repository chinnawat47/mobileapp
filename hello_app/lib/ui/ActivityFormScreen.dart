import 'package:flutter/material.dart';
import 'package:hello_app/models/Activity.dart';
import 'package:hello_app/services/ActivityDBHelper.dart';

class ActivityFormScreen extends StatefulWidget {
  final Activity? activity;

  const ActivityFormScreen({super.key, this.activity});

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  bool get isEdit => widget.activity != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      titleController.text = widget.activity!.title;
      descController.text = widget.activity!.desc;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> saveActivity() async {
    FocusScope.of(context).unfocus();

    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter activity title')),
      );
      return;
    }

    try {
      if (isEdit) {
        await ActivityDBHelper.updateActivity(
          widget.activity!.id,
          title: titleController.text.trim(),
          desc: descController.text.trim(),
          stdList: widget.activity!.stdList,
          dateFrom: widget.activity!.dateFrom,
        );
      } else {
        await ActivityDBHelper.addActivity(
          title: titleController.text.trim(),
          desc: descController.text.trim(),
          stdList: [],
          dateFrom: DateTime.now(),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit ? 'Activity updated successfully' : 'Activity added successfully',
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Activity' : 'Add Activity'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme.brightness == Brightness.dark
                ? [Colors.indigo.shade900, Colors.black]
                : [Colors.indigo.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.indigo.shade50, shape: BoxShape.circle),
                          child: const Icon(Icons.edit_note_rounded, color: Colors.indigo),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(isEdit ? 'Update activity details' : 'Create a new activity', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text('Keep the title and description clear for your team.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Activity Title',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: descController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: saveActivity,
                    icon: Icon(isEdit ? Icons.update : Icons.save_outlined),
                    label: Text(isEdit ? 'Update Activity' : 'Save Activity'),
                    style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}