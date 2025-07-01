import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:docnest/providers/app_data_provider.dart';

class AddFolderDialog extends StatefulWidget {
  const AddFolderDialog({super.key});

  @override
  _AddFolderDialogState createState() => _AddFolderDialogState();
}

class _AddFolderDialogState extends State<AddFolderDialog> {
  final _controller = TextEditingController();

  void _addFolder() {
    if (_controller.text.isNotEmpty) {
      Provider.of<AppDataProvider>(context, listen: false).createFolder(_controller.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Folder'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Folder Name'),
        onSubmitted: (_) => _addFolder(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _addFolder,
          child: const Text('Create'),
        ),
      ],
    );
  }
}