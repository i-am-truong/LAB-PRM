import 'package:flutter/material.dart';

class LayoutBasicsDemo extends StatelessWidget {
  const LayoutBasicsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final movies = List<String>.generate(30, (i) => 'Movie #${i + 1}');

    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 3 - Layout Basics')),
      body: Padding(
        padding: const EdgeInsets.all(16), // consistent spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Home',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: const [
                Icon(Icons.local_fire_department),
                SizedBox(width: 8),
                Text('Trending', style: TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: const [
                          Text(
                            'Points',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('120'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: const [
                          Text(
                            'Level',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('5'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            const Text('Movies', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.movie_outlined),
                        title: Text(movies[index]),
                        subtitle: const Text('Subtitle / description'),
                      ),
                    ),
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
