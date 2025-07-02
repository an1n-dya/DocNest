import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import 'package:docnest/providers/app_data_provider.dart';
import 'package:docnest/screens/folder_screen.dart';
import 'package:docnest/widgets/add_folder_dialog.dart';
import 'package:docnest/widgets/folder_card.dart';
import 'package:docnest/widgets/rename_dialog.dart';
import 'package:docnest/screens/search_screen.dart';
import 'package:docnest/utils/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late AnimationController _headerAnimationController;
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _headerSlideAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: AppTheme.normalAnimation,
      vsync: this,
    );
    _headerAnimationController = AnimationController(
      duration: AppTheme.slowAnimation,
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));

    _headerSlideAnimation = Tween<double>(
      begin: -50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutBack,
    ));

    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  void _showFolderOptions(BuildContext context, folder) {
    final provider = Provider.of<AppDataProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Folder info header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        folder.icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            folder.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${folder.documentIds.length} files',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Options
              _buildBottomSheetOption(
                icon: Icons.drive_file_rename_outline_rounded,
                title: 'Rename Folder',
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

              if (folder.name != "Unfiled")
                _buildBottomSheetOption(
                  icon: Icons.delete_outline_rounded,
                  title: 'Delete Folder',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation(context, folder, provider);
                  },
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDestructive ? Colors.red : AppTheme.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? Colors.red : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, folder, AppDataProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Folder'),
        content: Text('Are you sure you want to delete "${folder.name}"? This will also delete all files in this folder.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              provider.deleteFolder(folder);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showNewItemSheet() {
    setState(() => _isExpanded = !_isExpanded);
    _fabAnimationController.forward().then((_) {
      _fabAnimationController.reverse();
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 20),

              // Title
              const Text(
                'Create New',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              _buildNewItemOption(
                icon: Icons.create_new_folder_outlined,
                title: 'New Folder',
                subtitle: 'Organize your documents',
                gradient: AppTheme.primaryGradient,
                onTap: () {
                  Navigator.pop(context);
                  showDialog(context: context, builder: (_) => const AddFolderDialog());
                },
              ),

              const SizedBox(height: 12),

              _buildNewItemOption(
                icon: Icons.note_add_outlined,
                title: 'Import Document',
                subtitle: 'Add documents to your library',
                gradient: AppTheme.accentGradient,
                onTap: () {
                  Navigator.pop(context);
                  final provider = Provider.of<AppDataProvider>(context, listen: false);
                  final unfiledFolder = provider.folders.firstWhere((f) => f.name == "Unfiled");
                  provider.importDocument(unfiledFolder.id);
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewItemOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _headerSlideAnimation,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _headerSlideAnimation.value),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                                  child: const Text(
                                    'DocNest',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Your document library',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () => Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const SearchScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                  transitionDuration: AppTheme.fastAnimation,
                                ),
                              ),
                              icon: const Icon(Icons.search_rounded),
                              iconSize: 28,
                              color: Colors.grey.shade700,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.grey.shade100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.all(12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Folders Grid
            Consumer<AppDataProvider>(
              builder: (context, provider, child) {
                if (provider.folders.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient.scale(0.1),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Icon(
                              Icons.folder_outlined,
                              size: 80,
                              color: AppTheme.primaryBlue.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Welcome to DocNest!",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Create your first folder to get started",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 32),
                          FilledButton.tonalIcon(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (_) => const AddFolderDialog(),
                            ),
                            icon: const Icon(Icons.add_rounded),
                            label: const Text("Create Folder"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childCount: provider.folders.length,
                    itemBuilder: (context, index) {
                      final folder = provider.folders[index];
                      return AnimatedContainer(
                        duration: AppTheme.normalAnimation,
                        curve: Curves.easeOutBack,
                        child: FolderCard(
                          folder: folder,
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    FolderScreen(folder: folder),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOutCubic,
                                    )),
                                    child: child,
                                  );
                                },
                                transitionDuration: AppTheme.normalAnimation,
                              ),
                            );
                          },
                          onLongPress: () => _showFolderOptions(context, folder),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            // Bottom spacing for FAB
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),

      floatingActionButton: AnimatedBuilder(
        animation: _fabScaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _fabScaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppTheme.floatingButtonShadow,
            ),
            child: FloatingActionButton.extended(
              onPressed: _showNewItemSheet,
              elevation: 0,
              highlightElevation: 0,
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              icon: AnimatedRotation(
                turns: _isExpanded ? 0.125 : 0,
                duration: AppTheme.fastAnimation,
                child: const Icon(Icons.add_rounded, size: 28),
              ),
              label: const Text(
                "New",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
