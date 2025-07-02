import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:docnest/models/document_model.dart';
import 'package:docnest/models/document_type.dart';

class DocumentListItem extends StatelessWidget {
  final Document document;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const DocumentListItem({
    super.key,
    required this.document,
    required this.onTap,
    required this.onLongPress,
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
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(0.08),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
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
            DateFormat('MMM d, yyyy - hh:mm a').format(document.addedDate),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ),
        trailing: const Icon(Icons.drag_handle_rounded, color: Colors.grey),
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