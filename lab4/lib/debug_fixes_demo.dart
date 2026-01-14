import 'package:flutter/material.dart';

class DebugFixesDemo extends StatefulWidget {
  const DebugFixesDemo({super.key});

  @override
  State<DebugFixesDemo> createState() => _DebugFixesDemoState();
}

class _DebugFixesDemoState extends State<DebugFixesDemo> {
  int _counter = 0;
  DateTime? _picked;

  Future<void> _showPicker() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _picked ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (d != null) {
      setState(() => _picked = d);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = List<String>.generate(25, (i) => 'Item ${i + 1}');

    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 5 - Debug & Fix')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Common UI fixes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Text('Counter: $_counter'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() => _counter++);
                },
                child: const Text('Increment (setState fix)'),
              ),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: _showPicker,
                icon: const Icon(Icons.date_range),
                label: const Text('Open DatePicker (context fix)'),
              ),
              const SizedBox(height: 8),
              Text(
                _picked == null ? 'No date' : 'Picked: ${_picked!.toLocal()}',
              ),
              const SizedBox(height: 16),

              const Text(
                'ListView inside Column fix (Expanded)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) => ListTile(title: Text(items[i])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
