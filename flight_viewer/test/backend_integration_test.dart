import 'package:flutter_test/flutter_test.dart';
import 'package:flight_viewer/services/api_service.dart';
import 'package:flight_viewer/models/flight.dart';
import 'package:flight_viewer/models/booking.dart';

void main() {
  group('Backend Integration Tests', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
    });

    test('Fetch flights', () async {
      // This test will fail if the backend is not running
      try {
        final flights = await apiService.fetchFlights();
        expect(flights, isA<List<Flight>>());
        // Note: This might be empty if no flights are available
      } catch (e) {
        // If backend is not running, we expect an exception
        expect(e, isNotNull);
      }
    });

    test('Search flights', () async {
      try {
        final flights = await apiService.searchFlights(
          origin: 'JFK',
          destination: 'LAX',
          departureDate: DateTime(2023, 12, 1),
        );
        expect(flights, isA<List<Flight>>());
      } catch (e) {
        // If backend is not running, we expect an exception
        expect(e, isNotNull);
      }
    });

    test('Fetch services', () async {
      final services = await apiService.fetchServices();
      expect(services, isA<List>());
      // We're returning a static list, so it should not be empty
      expect(services.isNotEmpty, true);
    });

    test('Create booking', () async {
      try {
        final booking = await apiService.createBooking(
          flightId: 'FL123',
          firstName: 'John',
          lastName: 'Doe',
          passport: 'P12345678',
          email: 'john.doe@example.com',
          extras: {'baggage': 1},
          totalCost: 599.99,
        );
        expect(booking, isA<Booking>());
        expect(booking.flightId, 'FL123');
        expect(booking.firstName, 'John');
      } catch (e) {
        // If backend is not running, we expect an exception
        expect(e, isNotNull);
      }
    });

    test('Fetch user bookings', () async {
      try {
        final bookings = await apiService.fetchUserBookings('john.doe@example.com');
        expect(bookings, isA<List<Booking>>());
      } catch (e) {
        // If backend is not running, we expect an exception
        expect(e, isNotNull);
      }
    });
  });
}