import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:docnest/providers/app_data_provider.dart';

class MoveFileDialog extends StatelessWidget {
  final String currentFolderId;
  final Function(String) onMove;

  const MoveFileDialog({super.key, required this.currentFolderId, required this.onMove});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppDataProvider>(context, listen: false);
    final otherFolders = provider.folders.where((f) => f.id != currentFolderId).toList();

    return AlertDialog(
      title: const Text("Move to..."),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: otherFolders.length,
          itemBuilder: (context, index) {
            final folder = otherFolders[index];
            return ListTile(
              leading: Icon(folder.icon, color: Theme.of(context).primaryColor),
              title: Text(folder.name),
              onTap: () {
                onMove(folder.id);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel"))
      ],
    );
  }
}