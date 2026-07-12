import 'package:flutter/material.dart';
import 'package:hello_app/models/Activity.dart';
import 'package:hello_app/services/ActivityDBHelper.dart';

class ActivityFormScreen extends StatefulWidget {
  final Activity? activity;

  const ActivityFormScreen({
    super.key,
    this.activity,
  });

  @override
  State<ActivityFormScreen> createState() =>
      _ActivityFormScreenState();
}

class _ActivityFormScreenState
    extends State<ActivityFormScreen> {

  final TextEditingController titleController =
      TextEditingController();

  final TextEditingController descController =
      TextEditingController();

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
        const SnackBar(
          content: Text('Please enter activity title'),
        ),
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
              isEdit
                  ? 'Activity updated successfully'
                  : 'Activity added successfully',
            ),
          ),
        );

        Navigator.pop(context);
      }

    } catch (e) {

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error : $e'),
          ),
        );
      }

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          isEdit
              ? 'Edit Activity'
              : 'Add Activity',
        ),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(

              controller: titleController,

              decoration: const InputDecoration(
                labelText: 'Activity Title',
                border: OutlineInputBorder(),
              ),

            ),

            const SizedBox(height: 16),

            TextField(

              controller: descController,

              maxLines: 4,

              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),

            ),

            const SizedBox(height: 24),

            SizedBox(

              width: double.infinity,

              height: 50,

              child: ElevatedButton(

                onPressed: saveActivity,

                child: Text(
                  isEdit
                      ? 'Update Activity'
                      : 'Save Activity',
                ),

              ),

            ),

          ],

        ),

      ),

    );
  }
}