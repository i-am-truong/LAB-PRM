import 'package:flutter/material.dart';
import '../services/json_storage_service.dart';

/// Lab 9.3 - JSON CRUD Mini Database (Search + Edit + Delete)
/// Full CRUD operations with search/filter and auto-save functionality
class Lab93Screen extends StatefulWidget {
  const Lab93Screen({super.key});

  @override
  State<Lab93Screen> createState() => _Lab93ScreenState();
}

class _Lab93ScreenState extends State<Lab93Screen> {
  static const String _fileName = 'tasks_database.json';

  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> _filteredTasks = [];
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _searchController.addListener(_filterTasks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Load tasks from local JSON file
  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    final tasks = await JsonStorageService.readJsonFile(_fileName);

    setState(() {
      _tasks = tasks;
      _filteredTasks = List.from(tasks);
      _isLoading = false;
    });
  }

  /// Auto-save tasks to local JSON file
  Future<void> _autoSave() async {
    final success = await JsonStorageService.writeJsonFile(_fileName, _tasks);

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved automatically'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// Filter tasks based on search query
  void _filterTasks() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredTasks = List.from(_tasks);
      } else {
        _filteredTasks = _tasks.where((task) {
          final title = (task['title'] ?? '').toString().toLowerCase();
          final description = (task['description'] ?? '')
              .toString()
              .toLowerCase();
          final status = (task['status'] ?? '').toString().toLowerCase();
          return title.contains(query) ||
              description.contains(query) ||
              status.contains(query);
        }).toList();
      }
    });
  }

  /// Generate a unique ID for new tasks
  int _generateId() {
    if (_tasks.isEmpty) return 1;
    final maxId = _tasks
        .map((t) => t['id'] as int)
        .reduce((a, b) => a > b ? a : b);
    return maxId + 1;
  }

  /// Add a new task
  Future<void> _addTask(
    String title,
    String description,
    String priority,
  ) async {
    if (title.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title cannot be empty'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final newTask = {
      'id': _generateId(),
      'title': title.trim(),
      'description': description.trim(),
      'status': 'pending',
      'priority': priority,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    setState(() {
      _tasks.add(newTask);
      _filterTasks();
    });

    await _autoSave();
  }

  /// Edit an existing task
  Future<void> _editTask(
    int index,
    String title,
    String description,
    String status,
    String priority,
  ) async {
    if (title.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title cannot be empty'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Find the actual index in _tasks
    final taskId = _filteredTasks[index]['id'];
    final actualIndex = _tasks.indexWhere((t) => t['id'] == taskId);

    if (actualIndex != -1) {
      setState(() {
        _tasks[actualIndex] = {
          ..._tasks[actualIndex],
          'title': title.trim(),
          'description': description.trim(),
          'status': status,
          'priority': priority,
          'updatedAt': DateTime.now().toIso8601String(),
        };
        _filterTasks();
      });

      await _autoSave();
    }
  }

  /// Delete a task
  Future<void> _deleteTask(int index) async {
    final taskId = _filteredTasks[index]['id'];
    final actualIndex = _tasks.indexWhere((t) => t['id'] == taskId);

    if (actualIndex != -1) {
      setState(() {
        _tasks.removeAt(actualIndex);
        _filterTasks();
      });

      await _autoSave();
    }
  }

  /// Show dialog to add a new task
  void _showAddTaskDialog() {
    _titleController.clear();
    _descriptionController.clear();
    String selectedPriority = 'medium';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    hintText: 'Enter task title',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter task description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'high', child: Text('High')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedPriority = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addTask(
                  _titleController.text,
                  _descriptionController.text,
                  selectedPriority,
                );
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  /// Show dialog to edit a task
  void _showEditTaskDialog(int index) {
    final task = _filteredTasks[index];
    _titleController.text = task['title'] ?? '';
    _descriptionController.text = task['description'] ?? '';
    String selectedStatus = task['status'] ?? 'pending';
    String selectedPriority = task['priority'] ?? 'medium';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(
                      value: 'in_progress',
                      child: Text('In Progress'),
                    ),
                    DropdownMenuItem(
                      value: 'completed',
                      child: Text('Completed'),
                    ),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedStatus = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'high', child: Text('High')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedPriority = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _editTask(
                  index,
                  _titleController.text,
                  _descriptionController.text,
                  selectedStatus,
                  selectedPriority,
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  /// Show confirmation dialog for delete
  void _showDeleteConfirmation(int index) {
    final task = _filteredTasks[index];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteTask(index);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.3 - CRUD Database'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTasks,
            tooltip: 'Reload',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        tooltip: 'Add Task',
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
            Text('Loading tasks...'),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search tasks',
              hintText: 'Search by title, description, or status',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
            ),
          ),
        ),

        // Stats bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatChip('Total', _tasks.length, Colors.blue),
              _buildStatChip(
                'Pending',
                _tasks.where((t) => t['status'] == 'pending').length,
                Colors.orange,
              ),
              _buildStatChip(
                'In Progress',
                _tasks.where((t) => t['status'] == 'in_progress').length,
                Colors.purple,
              ),
              _buildStatChip(
                'Done',
                _tasks.where((t) => t['status'] == 'completed').length,
                Colors.green,
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Results info
        if (_searchController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Found ${_filteredTasks.length} result(s)',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),

        const Divider(),

        // Task list
        Expanded(
          child: _filteredTasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _searchController.text.isNotEmpty
                            ? Icons.search_off
                            : Icons.task_alt,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchController.text.isNotEmpty
                            ? 'No tasks found matching your search'
                            : 'No tasks yet.\nTap + to add your first task!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadTasks,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: _filteredTasks.length,
                    itemBuilder: (context, index) {
                      return _buildTaskCard(_filteredTasks[index], index);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, int index) {
    final status = task['status'] ?? 'pending';
    final priority = task['priority'] ?? 'medium';

    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'in_progress':
        statusColor = Colors.purple;
        statusIcon = Icons.pending;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.radio_button_unchecked;
    }

    Color priorityColor;
    switch (priority) {
      case 'high':
        priorityColor = Colors.red;
        break;
      case 'low':
        priorityColor = Colors.green;
        break;
      default:
        priorityColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor, size: 32),
        title: Text(
          task['title'] ?? 'Untitled',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: status == 'completed'
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task['description']?.isNotEmpty == true)
              Text(
                task['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(51),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withAlpha(51),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    priority.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: priorityColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditTaskDialog(index);
                break;
              case 'delete':
                _showDeleteConfirmation(index);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () => _showEditTaskDialog(index),
      ),
    );
  }
}
