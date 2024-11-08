import 'package:flutter/material.dart';
import '../feature/admin_activity_add_f.dart'; // Import the feature file

class AdminActivityAdd extends StatefulWidget {
  final String userId;
  const AdminActivityAdd({super.key, required this.userId});

  @override
  _AdminActivityAddState createState() => _AdminActivityAddState();
}

class _AdminActivityAddState extends State<AdminActivityAdd> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _videoNameController = TextEditingController();
  final TextEditingController _videoDescriptionController =
      TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();

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

    Map<String, dynamic> newActivity = {
      'category': _categoryController.text,
      'videoname': _videoNameController.text,
      'videodescription': _videoDescriptionController.text,
      'videourl': _videoUrlController.text,
    };

    try {
      await addActivity(newActivity); // Call add activity function

      // Show congratulatory SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activity added successfully!')),
      );

      Navigator.pop(context); // Go back to the previous screen
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add activity: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Activity'),
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
                child: const Text('Add Activity'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
