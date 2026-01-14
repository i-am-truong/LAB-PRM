import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 1 - Core Widgets')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Flutter UI Fundamentals',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            const Icon(Icons.flutter_dash, size: 48),
            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://upload.wikimedia.org/wikipedia/vi/thumb/2/2d/Logo_Tr%C6%B0%E1%BB%9Dng_%C4%90%E1%BA%A1i_h%E1%BB%8Dc_FPT.svg/330px-Logo_Tr%C6%B0%E1%BB%9Dng_%C4%90%E1%BA%A1i_h%E1%BB%8Dc_FPT.svg.png',
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.movie),
                title: const Text('ListTile inside Card'),
                subtitle: const Text('Tap action demo'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tapped ListTile')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
