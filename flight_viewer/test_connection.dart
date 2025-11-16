import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final String baseUrl = 'http://127.0.0.1:8000';
  
  try {
    print('Testing connection to backend...');
    
    // Test health endpoint
    final healthResponse = await http.get(Uri.parse('$baseUrl/health'));
    print('Health check status: ${healthResponse.statusCode}');
    print('Health check body: ${healthResponse.body}');
    
    // Test flights search endpoint
    final searchResponse = await http.get(
      Uri.parse('$baseUrl/flights/search?origin=JFK&destination=LAX&date=2023-12-01')
    );
    print('Search flights status: ${searchResponse.statusCode}');
    print('Search flights body: ${searchResponse.body}');
    
    // Parse the response
    if (searchResponse.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(searchResponse.body);
      final List<dynamic> flights = data['flights'] ?? [];
      print('Number of flights found: ${flights.length}');
    }
    
    print('Connection test completed successfully!');
  } catch (e) {
    print('Connection test failed: $e');
  }
}