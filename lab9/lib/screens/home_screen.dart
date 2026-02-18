import 'package:flutter/material.dart';
import 'lab9_1_screen.dart';
import 'lab9_2_screen.dart';
import 'lab9_3_screen.dart';

/// Home screen with navigation to all three lab screens
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LAB 9 - JSON Local Storage'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.secondaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.storage,
                    size: 48,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Working With Local JSON Storage',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Flutter + File Persistence',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Lab 9.1 Card
            _buildLabCard(
              context,
              title: 'Lab 9.1',
              subtitle: 'Read JSON From Assets',
              description:
                  'Load JSON from assets folder using rootBundle.loadString() and display data with ListView.',
              icon: Icons.file_download,
              color: Colors.blue,
              features: [
                'Load JSON from /assets/',
                'Parse with jsonDecode()',
                'Display in ListView',
              ],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Lab91Screen()),
              ),
            ),

            const SizedBox(height: 16),

            // Lab 9.2 Card
            _buildLabCard(
              context,
              title: 'Lab 9.2',
              subtitle: 'Save & Load JSON From Device Storage',
              description:
                  'Read/write JSON files to application documents directory with persistence.',
              icon: Icons.save_alt,
              color: Colors.green,
              features: [
                'Use path_provider',
                'Read/Write JSON files',
                'Persist across restarts',
              ],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Lab92Screen()),
              ),
            ),

            const SizedBox(height: 16),

            // Lab 9.3 Card
            _buildLabCard(
              context,
              title: 'Lab 9.3',
              subtitle: 'JSON CRUD Mini Database',
              description:
                  'Full CRUD operations with search/filter functionality and auto-save.',
              icon: Icons.dataset,
              color: Colors.purple,
              features: [
                'Add / Edit / Delete',
                'Search & Filter',
                'Auto-save changes',
              ],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Lab93Screen()),
              ),
            ),

            const SizedBox(height: 24),

            // Info Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Key Concepts',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.code,
                    'dart:convert for JSON encoding/decoding',
                  ),
                  _buildInfoRow(
                    Icons.folder,
                    'path_provider for local storage',
                  ),
                  _buildInfoRow(Icons.refresh, 'setState for UI updates'),
                  _buildInfoRow(
                    Icons.list,
                    'ListView.builder for efficient lists',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
    required List<String> features,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            subtitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: features
                          .map(
                            (f) => Chip(
                              label: Text(
                                f,
                                style: const TextStyle(fontSize: 10),
                              ),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
