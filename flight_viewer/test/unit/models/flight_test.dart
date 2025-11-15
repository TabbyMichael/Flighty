import 'package:flutter_test/flutter_test.dart';
import 'package:flight_viewer/models/flight.dart';

void main() {
  group('Flight', () {
    test('can be instantiated with required parameters', () {
      final flight = Flight(
        id: '1',
        airlineCode: 'AA',
        airlineName: 'American Airlines',
        flightNumber: 'AA100',
        departureAirport: 'JFK',
        arrivalAirport: 'LAX',
        departureTime: DateTime(2023, 12, 1, 10, 0),
        arrivalTime: DateTime(2023, 12, 1, 13, 0),
        duration: 180,
        price: 299.99,
        stops: 0,
        currency: 'USD',
        segments: [],
        cabinClass: 'ECONOMY',
      );

      expect(flight.id, '1');
      expect(flight.airlineCode, 'AA');
      expect(flight.airlineName, 'American Airlines');
      expect(flight.flightNumber, 'AA100');
      expect(flight.departureAirport, 'JFK');
      expect(flight.arrivalAirport, 'LAX');
      expect(flight.duration, 180);
      expect(flight.price, 299.99);
      expect(flight.stops, 0);
      expect(flight.currency, 'USD');
      expect(flight.cabinClass, 'ECONOMY');
    });

    test('can be created from JSON', () {
      final json = {
        'id': '1',
        'airline': 'AA',
        'airline_name': 'American Airlines',
        'flight_number': 'AA100',
        'departure_airport': 'JFK',
        'arrival_airport': 'LAX',
        'departure_time': '2023-12-01T10:00:00Z',
        'arrival_time': '2023-12-01T13:00:00Z',
        'duration': 180,
        'price': 299.99,
        'stops': 0,
        'currency': 'USD',
        'cabin_class': 'ECONOMY',
        'segments': [],
      };

      final flight = Flight.fromJson(json);

      expect(flight.id, '1');
      expect(flight.airlineCode, 'AA');
      expect(flight.airlineName, 'American Airlines');
      expect(flight.flightNumber, 'AA100');
      expect(flight.departureAirport, 'JFK');
      expect(flight.arrivalAirport, 'LAX');
      expect(flight.departureTime, DateTime.parse('2023-12-01T10:00:00Z'));
      expect(flight.arrivalTime, DateTime.parse('2023-12-01T13:00:00Z'));
      expect(flight.duration, 180);
      expect(flight.price, 299.99);
      expect(flight.stops, 0);
      expect(flight.currency, 'USD');
      expect(flight.cabinClass, 'ECONOMY');
    });
  });

  group('Segment', () {
    test('can be instantiated with required parameters', () {
      final segment = Segment(
        departureAirport: 'JFK',
        arrivalAirport: 'ORD',
        departureTime: DateTime(2023, 12, 1, 10, 0),
        arrivalTime: DateTime(2023, 12, 1, 12, 0),
        flightNumber: 'AA100',
        airlineCode: 'AA',
        airlineName: 'American Airlines',
        duration: 120,
      );

      expect(segment.departureAirport, 'JFK');
      expect(segment.arrivalAirport, 'ORD');
      expect(segment.flightNumber, 'AA100');
      expect(segment.airlineCode, 'AA');
      expect(segment.airlineName, 'American Airlines');
      expect(segment.duration, 120);
    });

    test('can be created from JSON', () {
      final json = {
        'departure_airport': 'JFK',
        'arrival_airport': 'ORD',
        'departure_time': '2023-12-01T10:00:00Z',
        'arrival_time': '2023-12-01T12:00:00Z',
        'flight_number': 'AA100',
        'airline': 'AA',
        'airline_name': 'American Airlines',
        'duration': 120,
      };

      final segment = Segment.fromJson(json);

      expect(segment.departureAirport, 'JFK');
      expect(segment.arrivalAirport, 'ORD');
      expect(segment.departureTime, DateTime.parse('2023-12-01T10:00:00Z'));
      expect(segment.arrivalTime, DateTime.parse('2023-12-01T12:00:00Z'));
      expect(segment.flightNumber, 'AA100');
      expect(segment.airlineCode, 'AA');
      expect(segment.airlineName, 'American Airlines');
      expect(segment.duration, 120);
    });
  });
}