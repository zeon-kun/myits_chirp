// screens/space_form_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/space_services.dart';
import '../../../models/space_model.dart';

class SpaceFormScreen extends StatefulWidget {
  final Space? space;

  SpaceFormScreen({this.space});

  @override
  _SpaceFormScreenState createState() => _SpaceFormScreenState();
}

class _SpaceFormScreenState extends State<SpaceFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.space != null) {
      _nameController.text = widget.space!.name;
      _descController.text = widget.space!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.space == null ? 'Create Space' : 'Edit Space'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Space Name'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Space Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.space == null) {
                  Provider.of<SpaceService>(context, listen: false)
                      .addSpace(_nameController.text, _descController.text);
                } else {
                  Provider.of<SpaceService>(context, listen: false)
                      .updateSpace(widget.space!.id, _nameController.text, _descController.text);
                }
                Navigator.pop(context);
              },
              child: Text(widget.space == null ? 'Create' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
