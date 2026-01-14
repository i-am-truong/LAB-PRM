import 'package:flutter/material.dart';

import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_basics_demo.dart';
import 'scaffold_theme_demo.dart';
import 'debug_fixes_demo.dart';

void main() => runApp(const Lab4App());

class Lab4App extends StatefulWidget {
  const Lab4App({super.key});

  @override
  State<Lab4App> createState() => _Lab4AppState();
}

class _Lab4AppState extends State<Lab4App> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final light = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      // Theme customization demo
      appBarTheme: const AppBarTheme(centerTitle: true),
    );

    final dark = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(centerTitle: true),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeMenu(
        darkMode: _darkMode,
        onToggleDarkMode: (v) => setState(() => _darkMode = v),
      ),
    );
  }
}

class HomeMenu extends StatelessWidget {
  final bool darkMode;
  final ValueChanged<bool> onToggleDarkMode;

  const HomeMenu({
    super.key,
    required this.darkMode,
    required this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4 - Menu'),
        actions: [
          Switch(value: darkMode, onChanged: onToggleDarkMode),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Exercise 1 - Core Widgets'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CoreWidgetsDemo()),
            ),
          ),
          ListTile(
            title: const Text('Exercise 2 - Input Widgets'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InputControlsDemo()),
            ),
          ),
          ListTile(
            title: const Text('Exercise 3 - Layout Basics'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LayoutBasicsDemo()),
            ),
          ),
          ListTile(
            title: const Text('Exercise 4 - Scaffold & Theme'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ScaffoldThemeDemo(
                  isDark: darkMode,
                  onThemeChanged: onToggleDarkMode,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Exercise 5 - Debug & Fixes'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DebugFixesDemo()),
            ),
          ),
        ],
      ),
    );
  }
}
