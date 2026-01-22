import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

// Movie Model
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// Sample Movie Data
const List<Movie> allMovies = [
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama', 'Thriller'],
    posterUrl:
        'https://via.placeholder.com/150x225/1a1a2e/eee?text=Dark+Knight',
    rating: 9.0,
  ),
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi', 'Thriller'],
    posterUrl: 'https://via.placeholder.com/150x225/16213e/eee?text=Inception',
    rating: 8.8,
  ),
  Movie(
    title: 'The Shawshank Redemption',
    year: 1994,
    genres: ['Drama'],
    posterUrl: 'https://via.placeholder.com/150x225/0f3460/eee?text=Shawshank',
    rating: 9.3,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Drama'],
    posterUrl:
        'https://via.placeholder.com/150x225/533483/eee?text=Interstellar',
    rating: 8.6,
  ),
  Movie(
    title: 'The Grand Budapest Hotel',
    year: 2014,
    genres: ['Comedy', 'Drama'],
    posterUrl: 'https://via.placeholder.com/150x225/e94560/eee?text=Budapest',
    rating: 8.1,
  ),
  Movie(
    title: 'Pulp Fiction',
    year: 1994,
    genres: ['Drama', 'Thriller'],
    posterUrl:
        'https://via.placeholder.com/150x225/c23866/eee?text=Pulp+Fiction',
    rating: 8.9,
  ),
];

// Available Genres
const List<String> availableGenres = [
  'Action',
  'Drama',
  'Comedy',
  'Sci-Fi',
  'Thriller',
  'Romance',
];

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MovieBrowsingScreen(),
    );
  }
}

class MovieBrowsingScreen extends StatefulWidget {
  const MovieBrowsingScreen({super.key});

  @override
  State<MovieBrowsingScreen> createState() => _MovieBrowsingScreenState();
}

class _MovieBrowsingScreenState extends State<MovieBrowsingScreen> {
  String searchQuery = '';
  Set<String> selectedGenres = {};
  String selectedSort = 'A-Z';

  // Filter and sort movies
  List<Movie> get filteredAndSortedMovies {
    List<Movie> result = allMovies.where((movie) {
      // Filter by search query
      final matchesSearch = movie.title.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      // Filter by selected genres
      final matchesGenre =
          selectedGenres.isEmpty ||
          movie.genres.any((genre) => selectedGenres.contains(genre));

      return matchesSearch && matchesGenre;
    }).toList();

    // Sort movies
    switch (selectedSort) {
      case 'A-Z':
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Z-A':
        result.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Year':
        result.sort((a, b) => b.year.compareTo(a.year));
        break;
      case 'Rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return result;
  }

  void clearFilters() {
    setState(() {
      searchQuery = '';
      selectedGenres.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleMovies = filteredAndSortedMovies;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Find a Movie',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  if (searchQuery.isNotEmpty || selectedGenres.isNotEmpty)
                    TextButton.icon(
                      onPressed: clearFilters,
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear'),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search movies...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Genre Chips with Badge
              Row(
                children: [
                  const Text(
                    'Genres',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  if (selectedGenres.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${selectedGenres.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableGenres.map((genre) {
                  final isSelected = selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedGenres.add(genre);
                        } else {
                          selectedGenres.remove(genre);
                        }
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.deepPurple.withValues(alpha: 0.2),
                    checkmarkColor: Colors.deepPurple,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Sort Dropdown
              Row(
                children: [
                  const Text(
                    'Sort by:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: selectedSort,
                      underline: const SizedBox(),
                      items: ['A-Z', 'Z-A', 'Year', 'Rating']
                          .map(
                            (sort) => DropdownMenuItem(
                              value: sort,
                              child: Text(sort),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedSort = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Results count
              Text(
                '${visibleMovies.length} movie${visibleMovies.length != 1 ? 's' : ''} found',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 12),

              // Movie List (Responsive)
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWideScreen = constraints.maxWidth >= 800;

                    if (visibleMovies.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.movie_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No movies found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (isWideScreen) {
                      // Two-column grid for wide screens
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2.5,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: visibleMovies.length,
                        itemBuilder: (context, index) {
                          return MovieCard(
                            movie: visibleMovies[index],
                            isWideScreen: true,
                          );
                        },
                      );
                    } else {
                      // Single column list for narrow screens
                      return ListView.builder(
                        itemCount: visibleMovies.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: MovieCard(
                              movie: visibleMovies[index],
                              isWideScreen: false,
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isWideScreen;

  const MovieCard({super.key, required this.movie, required this.isWideScreen});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.posterUrl,
                width: isWideScreen ? 80 : 100,
                height: isWideScreen ? 120 : 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: isWideScreen ? 80 : 100,
                    height: isWideScreen ? 120 : 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.movie, size: 40),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Movie Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${movie.year}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),

                  // Rating with stars
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        final rating =
                            movie.rating / 2; // Convert to 5-star scale
                        if (index < rating.floor()) {
                          return const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          );
                        } else if (index < rating) {
                          return const Icon(
                            Icons.star_half,
                            size: 16,
                            color: Colors.amber,
                          );
                        } else {
                          return Icon(
                            Icons.star_border,
                            size: 16,
                            color: Colors.grey[400],
                          );
                        }
                      }),
                      const SizedBox(width: 4),
                      Text(
                        '${movie.rating}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Genres
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: movie.genres.map((genre) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          genre,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.deepPurple[700],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
