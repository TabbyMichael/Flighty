import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flight.dart';
import '../models/airline.dart';
import '../models/extra_service.dart';
import '../models/booking.dart';
import 'haptics_service.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000'; // For iOS simulator and local development
  // static const String baseUrl = 'http://10.0.2.2:8000'; // For Android emulator
  // static const String baseUrl = 'http://YOUR_COMPUTER_IP:8000'; // For physical device
  
  final HapticsService _hapticsService = HapticsService();

  Future<List<Flight>> fetchFlights() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/flights'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> flightsJson = data['flights'] ?? [];
        return flightsJson.map((json) => Flight.fromJson(json)).toList();
      } else {
        _hapticsService.error();
        throw Exception('Failed to load flights: ${response.statusCode}');
      }
    } catch (e) {
      _hapticsService.error();
      throw Exception('Failed to fetch flights: $e');
    }
  }

  Future<List<Airline>> fetchAirlines() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/airlines'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> airlinesJson = data['airlines'] ?? [];
        return airlinesJson.map((json) => Airline.fromJson(json)).toList();
      } else {
        _hapticsService.error();
        throw Exception('Failed to load airlines: ${response.statusCode}');
      }
    } catch (e) {
      _hapticsService.error();
      throw Exception('Failed to fetch airlines: $e');
    }
  }

  Future<List<Flight>> searchFlights({
    String? origin,
    String? destination,
    DateTime? departureDate,
    double? maxPrice,
    int? maxStops,
    List<String>? airlineCodes,
  }) async {
    try {
      // Build query parameters
      final Map<String, String> queryParams = {};
      if (origin != null) queryParams['origin'] = origin;
      if (destination != null) queryParams['destination'] = destination;
      if (departureDate != null) {
        queryParams['date'] = departureDate.toIso8601String().split('T').first;
      }
      
      final Uri uri = Uri.parse('$baseUrl/flights/search').replace(queryParameters: queryParams);
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> flightsJson = data['flights'] ?? [];
        return flightsJson.map((json) => Flight.fromJson(json)).toList();
      } else {
        _hapticsService.error();
        throw Exception('Failed to search flights: ${response.statusCode}');
      }
    } catch (e) {
      _hapticsService.error();
      throw Exception('Failed to search flights: $e');
    }
  }

  Future<List<ExtraService>> fetchServices() async {
    try {
      // For now, we'll return a static list of services since the backend doesn't have this endpoint yet
      // In a real implementation, this would fetch from the backend
      return [
        ExtraService(
          id: '1',
          name: 'Extra Baggage',
          description: '20kg additional baggage allowance',
          price: 50.0,
          minQuantity: 0,
          maxQuantity: 3,
          isMandatory: false,
        ),
        ExtraService(
          id: '2',
          name: 'Priority Boarding',
          description: 'Board the plane first',
          price: 25.0,
          minQuantity: 0,
          maxQuantity: 1,
          isMandatory: false,
        ),
        ExtraService(
          id: '3',
          name: 'In-flight Meal',
          description: 'Special meal selection',
          price: 15.0,
          minQuantity: 0,
          maxQuantity: 1,
          isMandatory: false,
        ),
      ];
    } catch (e) {
      _hapticsService.error();
      throw Exception('Failed to fetch services: $e');
    }
  }
  
  // Add method to create a booking
  Future<Booking> createBooking({
    required String flightId,
    required String firstName,
    required String lastName,
    required String passport,
    required String email,
    required Map<String, int> extras,
    required double totalCost,
  }) async {
    try {
      print('Creating booking with flight ID: $flightId');
      final response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'flight_id': flightId,
          'passenger': {
            'first_name': firstName,
            'last_name': lastName,
            'passport': passport,
            'email': email,
          },
          'extras': extras,
          'total_price': totalCost,
          'currency': 'USD',
        }),
      );
      
      print('Booking response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _hapticsService.success();
        
        // Add default values for new required fields
        final bookingData = responseData as Map<String, dynamic>;
        bookingData['pnr'] = bookingData['pnr'] ?? 'ABC123';
        bookingData['status'] = bookingData['status'] ?? 'confirmed';
        
        return Booking.fromJson(bookingData);
      } else {
        final errorData = json.decode(response.body);
        _hapticsService.error();
        throw Exception('Failed to create booking: ${errorData['detail'] ?? response.statusCode}');
      }
    } catch (e) {
      _hapticsService.error();
      throw Exception('Failed to create booking: $e');
    }
  }
  
  // Fetch all bookings for a specific user by email
  Future<List<Booking>> fetchUserBookings(String email) async {
    try {
      print('Fetching bookings for email: $email');
      final response = await http.get(
        Uri.parse('$baseUrl/bookings').replace(
          queryParameters: {'email': email},
        ),
      );
      
      print('Bookings response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic> bookingsList = responseBody['bookings'] ?? [];
        
        // Add default values for new required fields
        final List<Booking> bookings = [];
        for (final bookingJson in bookingsList) {
          final bookingData = bookingJson as Map<String, dynamic>;
          bookingData['pnr'] = bookingData['pnr'] ?? 'ABC123';
          bookingData['status'] = bookingData['status'] ?? 'confirmed';
          bookings.add(Booking.fromJson(bookingData));
        }
        
        return bookings;
      } else {
        _hapticsService.error();
        throw Exception('Failed to load bookings: ${response.statusCode}');
      }
    } catch (e) {
      _hapticsService.error();
      throw Exception('Failed to fetch bookings: $e');
    }
  }
}