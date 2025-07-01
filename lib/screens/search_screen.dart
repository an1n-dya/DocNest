import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_filex/open_filex.dart';

import 'package:docnest/providers/app_data_provider.dart';
import 'package:docnest/widgets/search_result_item.dart';
import 'package:docnest/models/document_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Document> _searchResults = [];

  void _performSearch(String query) {
    final provider = Provider.of<AppDataProvider>(context, listen: false);
    setState(() {
      _searchResults = provider.searchDocuments(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppDataProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search all documents...',
            border: InputBorder.none,
          ),
          onChanged: _performSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _performSearch('');
            },
          )
        ],
      ),
      body: SafeArea(
        child: _searchResults.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off_rounded, size: 60, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      _searchController.text.isEmpty
                          ? 'Search for documents by name.'
                          : 'No results found.',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final doc = _searchResults[index];
                  final folder = provider.findFolderForDocument(doc.id);
                  return SearchResultItem(
                    document: doc,
                    folder: folder,
                    onTap: () => OpenFilex.open(doc.path),
                  );
                },
              ),
      ),
    );
  }
}
