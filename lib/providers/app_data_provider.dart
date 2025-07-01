import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdfx/pdfx.dart';

import 'package:docnest/models/document_model.dart';
import 'package:docnest/models/folder_model.dart';

class AppDataProvider extends ChangeNotifier {
  final _documentBox = Hive.box<Document>('documents');
  final _folderBox = Hive.box<Folder>('folders');
  final _uuid = const Uuid();

  List<Folder> _folders = [];
  List<Folder> get folders => _folders;

  Map<String, Document> _documents = {};
  Map<String, Document> get documents => _documents;

  void loadData() {
    _folders = _folderBox.values.toList();
    _documents = {for (var doc in _documentBox.values) doc.id: doc};

    // Create a default "Unfiled" folder if none exist
    if (_folders.where((f) => f.name == "Unfiled").isEmpty) {
      final unfiledFolder = Folder(id: _uuid.v4(), name: "Unfiled", documentIds: []);
      _folderBox.put(unfiledFolder.id, unfiledFolder);
      _folders.add(unfiledFolder);
    }

    notifyListeners();
  }

  // Folder Operations
  Future<void> createFolder(String name) async {
    final newFolder = Folder(id: _uuid.v4(), name: name, documentIds: []);
    await _folderBox.put(newFolder.id, newFolder);
    _folders.add(newFolder);
    notifyListeners();
  }

  Future<void> renameFolder(Folder folder, String newName) async {
    folder.name = newName;
    await folder.save();
    notifyListeners();
  }

  Future<void> deleteFolder(Folder folder) async {
    // Delete associated documents
    for (var docId in folder.documentIds) {
      final doc = _documents[docId];
      if (doc != null) {
        await deleteDocument(doc, folder.id);
      }
    }
    await _folderBox.delete(folder.id);
    _folders.removeWhere((f) => f.id == folder.id);
    notifyListeners();
  }

  // Document Operations
  Future<void> importDocument(String folderId) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final pickedFile = File(result.files.single.path!);
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = result.files.single.name;
      final newPath = '${appDir.path}/${_uuid.v4()}.pdf';
      await pickedFile.copy(newPath);

      // Generate Thumbnail
      final thumbnailPath = await _generateThumbnail(newPath);

      final newDoc = Document(
        id: _uuid.v4(),
        name: fileName,
        path: newPath,
        addedDate: DateTime.now(),
        thumbnailPath: thumbnailPath,
      );

      await _documentBox.put(newDoc.id, newDoc);
      _documents[newDoc.id] = newDoc;

      final folder = _folders.firstWhere((f) => f.id == folderId);
      folder.documentIds.add(newDoc.id);
      await folder.save();

      notifyListeners();
    }
  }

  Future<String> _generateThumbnail(String pdfPath) async {
    try {
      final doc = await PdfDocument.openFile(pdfPath);
      final page = await doc.getPage(1);
      final pageImage = await page.render(width: 200, height: 200 * 1.414); // A4 aspect ratio
      await page.close();

      final appDir = await getApplicationDocumentsDirectory();
      final thumbnailFile = File('${appDir.path}/${_uuid.v4()}.png');
      await thumbnailFile.writeAsBytes(pageImage!.bytes);
      return thumbnailFile.path;
    } catch (e) {
      // Return a placeholder path if thumbnail generation fails
      debugPrint("Thumbnail generation failed: $e");
      return '';
    }
  }

  Future<void> renameDocument(Document doc, String newName) async {
    doc.name = newName;
    await doc.save();
    notifyListeners();
  }

  Future<void> moveDocument(Document doc, String fromFolderId, String toFolderId) async {
    final fromFolder = _folders.firstWhere((f) => f.id == fromFolderId);
    final toFolder = _folders.firstWhere((f) => f.id == toFolderId);

    fromFolder.documentIds.remove(doc.id);
    toFolder.documentIds.add(doc.id);

    await fromFolder.save();
    await toFolder.save();
    notifyListeners();
  }

  Future<void> deleteDocument(Document doc, String folderId) async {
    // Delete files from storage
    try {
      final file = File(doc.path);
      if (await file.exists()) await file.delete();

      final thumbnail = File(doc.thumbnailPath);
      if (await thumbnail.exists()) await thumbnail.delete();
    } catch (e) {
      debugPrint("Error deleting files: $e");
    }

    // Remove from folder and database
    final folder = _folders.firstWhere((f) => f.id == folderId);
    folder.documentIds.remove(doc.id);
    await folder.save();

    await _documentBox.delete(doc.id);
    _documents.remove(doc.id);
    notifyListeners();
  }

  void reorderDocuments(String folderId, int oldIndex, int newIndex) {
    final folder = _folders.firstWhere((f) => f.id == folderId);
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final docId = folder.documentIds.removeAt(oldIndex);
    folder.documentIds.insert(newIndex, docId);
    folder.save();
    notifyListeners();
  }
  
  // Search Operations
  List<Document> searchDocuments(String query) {
    if (query.isEmpty) return [];
    final lowerCaseQuery = query.toLowerCase();
    return _documents.values
        .where((doc) => doc.name.toLowerCase().contains(lowerCaseQuery))
        .toList();
  }

  Folder? findFolderForDocument(String documentId) {
    for (var folder in _folders) {
      if (folder.documentIds.contains(documentId)) {
        return folder;
      }
    }
    return null;
  }
}
