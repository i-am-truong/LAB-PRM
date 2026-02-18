import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Lab 9.1 - Read JSON From Assets (Local Embedded File)
/// This screen demonstrates loading JSON from assets folder using rootBundle
class Lab91Screen extends StatefulWidget {
  const Lab91Screen({super.key});

  @override
  State<Lab91Screen> createState() => _Lab91ScreenState();
}

class _Lab91ScreenState extends State<Lab91Screen> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadJsonFromAssets();
  }

  /// Load JSON file from assets using rootBundle.loadString()
  Future<void> _loadJsonFromAssets() async {
    try {
      // Step 1: Load JSON string from assets
      final String jsonString = await rootBundle.loadString(
        'assets/data/products.json',
      );

      // Step 2: Decode JSON string to Dart List
      final List<dynamic> jsonData = jsonDecode(jsonString);

      // Step 3: Convert to List of Maps
      setState(() {
        _products = jsonData
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading JSON: $e';
        _isLoading = false;
      });
    }
  }

  /// Refresh data (pull-to-refresh)
  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadJsonFromAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.1 - Read JSON Assets'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(),
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
            Text('Loading products from assets...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _refreshData, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_products.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    // Display data using ListView with RefreshIndicator
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  /// Build a card widget for each product
  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            product['id'].toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          product['name'] ?? 'Unknown',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product['description'] ?? 'No description'),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    product['category'] ?? 'N/A',
                    style: const TextStyle(fontSize: 12),
                  ),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                Text(
                  '\$${product['price']?.toStringAsFixed(2) ?? '0.00'}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () => _showProductDetails(product),
      ),
    );
  }

  /// Show product details in a dialog
  void _showProductDetails(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product['name'] ?? 'Product Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ID', product['id'].toString()),
            _buildDetailRow('Name', product['name']),
            _buildDetailRow('Description', product['description']),
            _buildDetailRow('Category', product['category']),
            _buildDetailRow(
              'Price',
              '\$${product['price']?.toStringAsFixed(2)}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }
}
