import 'package:flutter/material.dart';
import '../services/json_storage_service.dart';

/// Lab 9.2 - Save & Load JSON From Device Storage
/// This screen demonstrates reading/writing JSON to local device storage
class Lab92Screen extends StatefulWidget {
  const Lab92Screen({super.key});

  @override
  State<Lab92Screen> createState() => _Lab92ScreenState();
}

class _Lab92ScreenState extends State<Lab92Screen> {
  static const String _fileName = 'notes.json';

  List<Map<String, dynamic>> _notes = [];
  bool _isLoading = true;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Load notes from local JSON file
  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
    });

    final notes = await JsonStorageService.readJsonFile(_fileName);

    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  /// Save notes to local JSON file
  Future<void> _saveNotes() async {
    final success = await JsonStorageService.writeJsonFile(_fileName, _notes);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Notes saved successfully!' : 'Failed to save notes',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Generate a unique ID for new notes
  int _generateId() {
    if (_notes.isEmpty) return 1;
    final maxId = _notes
        .map((n) => n['id'] as int)
        .reduce((a, b) => a > b ? a : b);
    return maxId + 1;
  }

  /// Add a new note
  void _addNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _notes.add({
        'id': _generateId(),
        'title': title,
        'content': content,
        'createdAt': DateTime.now().toIso8601String(),
      });
    });

    _titleController.clear();
    _contentController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note added! Remember to save.'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// Delete a note
  void _deleteNote(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notes.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Note deleted! Remember to save.'),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Show dialog to add a new note
  void _showAddNoteDialog() {
    _titleController.clear();
    _contentController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter note title',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'Enter note content',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addNote();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.2 - Local Storage'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotes,
            tooltip: 'Reload',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNotes,
            tooltip: 'Save',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading notes...'),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Info card
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Notes are stored locally. Tap Save to persist changes.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Notes count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Notes: ${_notes.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _saveNotes,
                icon: const Icon(Icons.save, size: 18),
                label: const Text('Save All'),
              ),
            ],
          ),
        ),

        const Divider(),

        // Notes list
        Expanded(
          child: _notes.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.note_add, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No notes yet.\nTap + to add your first note!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNotes,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      return _buildNoteCard(note, index);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildNoteCard(Map<String, dynamic> note, int index) {
    final createdAt = note['createdAt'] != null
        ? DateTime.tryParse(note['createdAt'])
        : null;
    final formattedDate = createdAt != null
        ? '${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}'
        : 'Unknown date';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(
            Icons.note,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        title: Text(
          note['title'] ?? 'Untitled',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note['content']?.isNotEmpty == true)
              Text(
                note['content'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _deleteNote(index),
        ),
        isThreeLine: true,
      ),
    );
  }
}
