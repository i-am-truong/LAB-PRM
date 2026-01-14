import 'package:flutter/material.dart';

class ScaffoldThemeDemo extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const ScaffoldThemeDemo({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 4 - Scaffold & Theme'),
        actions: [
          Row(
            children: [
              const Icon(Icons.light_mode),
              Switch(
                value: isDark,
                onChanged: onThemeChanged, // toggles themeMode from parent
              ),
              const Icon(Icons.dark_mode),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Screen structure:\n- AppBar\n- Body\n- FloatingActionButton\n- ThemeData + themeMode toggle',
          style: TextStyle(fontSize: 16),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('FAB pressed')));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
