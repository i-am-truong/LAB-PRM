import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

/// Service class for handling API requests to JSONPlaceholder
class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  /// Fetch all posts from the API
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/posts'));

      if (response.statusCode == 200) {
        // Parse JSON response
        final List<dynamic> jsonList = json.decode(response.body);

        // Convert JSON list to List<Post>
        return jsonList.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  /// Create a new post via POST request
  Future<Post> createPost({
    required String title,
    required String body,
    int userId = 1,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'title': title, 'body': body, 'userId': userId}),
      );

      if (response.statusCode == 201) {
        // Parse created post from response
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  /// Clean up resources
  void dispose() {
    client.close();
  }
}
