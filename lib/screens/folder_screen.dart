import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:open_filex/open_filex.dart';

import 'package:docnest/models/document_model.dart';
import 'package:docnest/models/folder_model.dart';
import 'package:docnest/providers/app_data_provider.dart';
import 'package:docnest/widgets/document_list_item.dart';
import 'package:docnest/widgets/rename_dialog.dart';
import 'package:docnest/widgets/move_file_dialog.dart';

enum SortOption { name, date }

class FolderScreen extends StatefulWidget {
  final Folder folder;
  const FolderScreen({super.key, required this.folder});

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  SortOption _sortOption = SortOption.date;

  void _showDocumentOptions(BuildContext context, Document doc, String folderId) {
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
              leading: const Icon(Icons.drive_file_move_outline),
              title: const Text('Move to...'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => MoveFileDialog(
                    currentFolderId: folderId,
                    onMove: (newFolderId) => provider.moveDocument(doc, folderId, newFolderId),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline_rounded),
              title: const Text('Rename'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => RenameDialog(
                    initialName: doc.name,
                    onRename: (newName) => provider.renameDocument(doc, newName),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline_rounded, color: Colors.red.shade300),
              title: Text('Delete', style: TextStyle(color: Colors.red.shade300)),
              onTap: () {
                Navigator.pop(context);
                provider.deleteDocument(doc, folderId);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.name),
        actions: [
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort_rounded),
            onSelected: (option) => setState(() => _sortOption = option),
            itemBuilder: (context) => [
              const PopupMenuItem(value: SortOption.name, child: Text("Sort by Name")),
              const PopupMenuItem(value: SortOption.date, child: Text("Sort by Date")),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Selector<AppDataProvider, List<Document>>(
          selector: (context, provider) {
            final docsInFolder = widget.folder.documentIds
                .map((id) => provider.documents[id])
                .where((doc) => doc != null)
                .cast<Document>()
                .toList();

            // Sorting logic
            docsInFolder.sort((a, b) {
              if (_sortOption == SortOption.name) {
                return a.name.toLowerCase().compareTo(b.name.toLowerCase());
              } else {
                return b.addedDate.compareTo(a.addedDate); // Newest first
              }
            });
            return docsInFolder;
          },
          builder: (context, docsInFolder, child) {

            if (docsInFolder.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.file_copy_outlined, size: 60, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text("This folder is empty.", style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                        icon: const Icon(Icons.note_add_outlined),
                        label: const Text("Import a Document"),
                        onPressed: () => provider.importDocument(widget.folder.id))
                  ],
                ),
              );
            }

            return ReorderableListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: docsInFolder.length,
              itemBuilder: (context, index) {
                final doc = docsInFolder[index];
                return DocumentListItem(
                  key: ValueKey(doc.id),
                  document: doc,
                  onTap: () => OpenFilex.open(doc.path),
                  onLongPress: () => _showDocumentOptions(context, doc, widget.folder.id),
                );
              },
              onReorder: (oldIndex, newIndex) {
                Provider.of<AppDataProvider>(context, listen: false).reorderDocuments(widget.folder.id, oldIndex, newIndex);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.note_add_outlined),
        onPressed: () => Provider.of<AppDataProvider>(context, listen: false).importDocument(widget.folder.id),
      ),
    );
  }
}
