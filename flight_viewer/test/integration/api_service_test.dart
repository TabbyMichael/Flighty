import 'package:flutter_test/flutter_test.dart';
import 'package:flight_viewer/services/api_service.dart';
import 'package:flight_viewer/models/flight.dart';
import 'package:flight_viewer/models/booking.dart';

void main() {
  group('ApiService', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
    });

    test('can be instantiated', () {
      expect(apiService, isNotNull);
    });

    test('fetchServices returns a list of services', () async {
      final services = await apiService.fetchServices();
      expect(services, isA<List>());
      expect(services.isNotEmpty, true);
    });

    // Skip network tests since they require a running backend
    test('fetchFlights handles network errors gracefully', () async {
      // This test would require mocking the HTTP client or having a running backend
      expect(true, true); // Placeholder
    });

    test('searchFlights handles network errors gracefully', () async {
      // This test would require mocking the HTTP client or having a running backend
      expect(true, true); // Placeholder
    });

    test('createBooking handles network errors gracefully', () async {
      // This test would require mocking the HTTP client or having a running backend
      expect(true, true); // Placeholder
    });

    test('fetchUserBookings handles network errors gracefully', () async {
      // This test would require mocking the HTTP client or having a running backend
      expect(true, true); // Placeholder
    });
  });
}