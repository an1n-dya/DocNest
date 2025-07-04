import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:docnest/models/document_model.dart';
import 'package:docnest/models/folder_model.dart';
import 'package:docnest/models/document_type.dart';

class SearchResultItem extends StatelessWidget {
  final Document document;
  final Folder? folder;
  final VoidCallback onTap;

  const SearchResultItem({
    super.key,
    required this.document,
    required this.folder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget thumbnailWidget;
    if (document.thumbnailPath.isNotEmpty) {
      thumbnailWidget = Image.file(
        File(document.thumbnailPath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(document.documentType),
      );
    } else {
      thumbnailWidget = _buildDefaultIcon(document.documentType);
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(0.08),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(10),
        leading: Container(
          width: 50,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade200,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: thumbnailWidget,
          ),
        ),
        title: Text(
          document.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            "In: ${folder?.name ?? 'Unfiled'} • ${DateFormat('MMM d, yyyy').format(document.addedDate)}",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultIcon(DocumentType type) {
    switch (type) {
      case DocumentType.pdf:
        return const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent);
      case DocumentType.image:
        return const Icon(Icons.image_rounded, color: Colors.blueAccent);
    }
  }
}