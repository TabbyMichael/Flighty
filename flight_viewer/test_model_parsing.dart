import 'dart:convert';
import 'lib/models/flight.dart';
import 'lib/models/booking.dart';

void main() {
  print('Testing model parsing...');
  
  // Test flight parsing with empty response
  final emptyFlightResponse = '{"flights":[]}';
  final emptyFlightData = json.decode(emptyFlightResponse);
  final emptyFlights = (emptyFlightData['flights'] as List)
      .map((json) => Flight.fromJson(json))
      .toList();
  print('Empty flights parsed successfully: ${emptyFlights.length} flights');
  
  // Test flight parsing with sample data
  final sampleFlightResponse = '''
  {
    "flights": [
      {
        "id": "AA123",
        "flight_number": "123",
        "airline": "American Airlines",
        "departure_airport": "JFK",
        "arrival_airport": "LAX",
        "departure_time": "2023-12-01T08:00:00Z",
        "arrival_time": "2023-12-01T11:00:00Z",
        "duration": 180,
        "price": 299.99,
        "currency": "USD",
        "stops": 0
      }
    ]
  }
  ''';
  
  final sampleFlightData = json.decode(sampleFlightResponse);
  final sampleFlights = (sampleFlightData['flights'] as List)
      .map((json) => Flight.fromJson(json))
      .toList();
  print('Sample flights parsed successfully: ${sampleFlights.length} flights');
  if (sampleFlights.isNotEmpty) {
    final flight = sampleFlights[0];
    print('Flight details:');
    print('  ID: ${flight.id}');
    print('  Flight Number: ${flight.flightNumber}');
    print('  Airline: ${flight.airlineName}');
    print('  Departure: ${flight.departureAirport}');
    print('  Arrival: ${flight.arrivalAirport}');
    print('  Price: ${flight.price}');
  }
  
  // Test booking parsing
  final sampleBookingResponse = '''
  {
    "id": "booking123",
    "flight_id": "AA123",
    "extras": {"baggage": 1},
    "first_name": "John",
    "last_name": "Doe",
    "passport": "P12345678",
    "email": "john.doe@example.com",
    "total_price": 299.99,
    "created_at": "2023-01-01T10:00:00Z",
    "pnr": "ABC123",
    "status": "confirmed"
  }
  ''';
  
  final bookingData = json.decode(sampleBookingResponse);
  final booking = Booking.fromJson(bookingData);
  print('Booking parsed successfully:');
  print('  ID: ${booking.id}');
  print('  Flight ID: ${booking.flightId}');
  print('  Passenger: ${booking.firstName} ${booking.lastName}');
  print('  Email: ${booking.email}');
  print('  Total Cost: ${booking.totalCost}');
  print('  Status: ${booking.status}');
  
  print('All model parsing tests completed successfully!');
}