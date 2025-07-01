import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:docnest/models/document_model.dart';
import 'package:docnest/models/folder_model.dart';
import 'package:docnest/providers/app_data_provider.dart';
import 'package:docnest/screens/home_screen.dart';
import 'package:docnest/utils/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive DB
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(DocumentAdapter());
  Hive.registerAdapter(FolderAdapter());
  Hive.registerAdapter(IconDataAdapter());

  // Open Hive Boxes
  await Hive.openBox<Document>('documents');
  await Hive.openBox<Folder>('folders');

  runApp(const DocNestApp());
}

class DocNestApp extends StatelessWidget {
  const DocNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppDataProvider()..loadData(),
      child: MaterialApp(
        title: 'DocNest',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
