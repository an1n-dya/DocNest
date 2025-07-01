import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import 'package:docnest/providers/app_data_provider.dart';
import 'package:docnest/screens/folder_screen.dart';
import 'package:docnest/widgets/add_folder_dialog.dart';
import 'package:docnest/widgets/folder_card.dart';
import 'package:docnest/widgets/rename_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showFolderOptions(BuildContext context, folder) {
    final provider = Provider.of<AppDataProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline_rounded),
              title: const Text('Rename'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => RenameDialog(
                    initialName: folder.name,
                    onRename: (newName) => provider.renameFolder(folder, newName),
                  ),
                );
              },
            ),
            if (folder.name != "Unfiled") // Cannot delete Unfiled folder
              ListTile(
                leading: Icon(Icons.delete_outline_rounded, color: Colors.red.shade300),
                title: Text('Delete', style: TextStyle(color: Colors.red.shade300)),
                onTap: () {
                  Navigator.pop(context);
                  provider.deleteFolder(folder);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DocNest', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) {
          if (provider.folders.isEmpty) {
            return const Center(child: Text("Create a folder to get started."));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: provider.folders.length,
              itemBuilder: (context, index) {
                final folder = provider.folders[index];
                return FolderCard(
                  folder: folder,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FolderScreen(folder: folder)),
                    );
                  },
                  onLongPress: () => _showFolderOptions(context, folder),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_rounded),
        label: const Text("New"),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.create_new_folder_outlined),
                    title: const Text('Add New Folder'),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(context: context, builder: (_) => const AddFolderDialog());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.note_add_outlined),
                    title: const Text('Import PDF'),
                    onTap: () {
                      Navigator.pop(context);
                      final provider = Provider.of<AppDataProvider>(context, listen: false);
                      // Import to the "Unfiled" folder by default
                      final unfiledFolder = provider.folders.firstWhere((f) => f.name == "Unfiled");
                      provider.importDocument(unfiledFolder.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
