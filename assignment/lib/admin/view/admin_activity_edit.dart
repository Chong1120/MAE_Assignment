import 'package:flutter/material.dart';
import '../feature/admin_activity_edit_f.dart'; // Import the feature file

class AdminActivityEdit extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> activity; // Activity data to be edited

  const AdminActivityEdit(
      {super.key, required this.userId, required this.activity});

  @override
  _AdminActivityEditState createState() => _AdminActivityEditState();
}

class _AdminActivityEditState extends State<AdminActivityEdit> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _videoNameController = TextEditingController();
  final TextEditingController _videoDescriptionController =
      TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text fields with current activity data
    _categoryController.text = widget.activity['category'];
    _videoNameController.text = widget.activity['videoname'];
    _videoDescriptionController.text = widget.activity['videodescription'];
    _videoUrlController.text = widget.activity['videourl'];
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _videoNameController.dispose();
    _videoDescriptionController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_categoryController.text.isEmpty ||
        _videoNameController.text.isEmpty ||
        _videoDescriptionController.text.isEmpty ||
        _videoUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields!')),
      );
      return;
    }

    Map<String, dynamic> updatedActivity = {
      'category': _categoryController.text,
      'videoname': _videoNameController.text,
      'videodescription': _videoDescriptionController.text,
      'videourl': _videoUrlController.text,
    };

    try {
      await editActivity(widget.activity['id'],
          updatedActivity); // Call edit activity function
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activity updated successfully!')),
      );
      Navigator.pop(context); // Go back to the previous screen
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update activity: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Activity'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _videoNameController,
              decoration: const InputDecoration(labelText: 'Video Name'),
            ),
            TextField(
              controller: _videoDescriptionController,
              decoration: const InputDecoration(labelText: 'Video Description'),
              maxLines: 3,
            ),
            TextField(
              controller: _videoUrlController,
              decoration: const InputDecoration(labelText: 'Video URL'),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Update Activity'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
