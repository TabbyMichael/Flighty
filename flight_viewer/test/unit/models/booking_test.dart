import 'package:flutter_test/flutter_test.dart';
import 'package:flight_viewer/models/booking.dart';

void main() {
  group('Booking', () {
    test('can be instantiated with required parameters', () {
      final booking = Booking(
        id: '1',
        flightId: 'FL123',
        extras: {'baggage': 1},
        firstName: 'John',
        lastName: 'Doe',
        passport: 'P12345678',
        email: 'john.doe@example.com',
        totalCost: 599.99,
        createdAt: DateTime(2023, 11, 15),
        pnr: 'ABC123',
        status: 'confirmed',
      );

      expect(booking.id, '1');
      expect(booking.flightId, 'FL123');
      expect(booking.extras, {'baggage': 1});
      expect(booking.firstName, 'John');
      expect(booking.lastName, 'Doe');
      expect(booking.passport, 'P12345678');
      expect(booking.email, 'john.doe@example.com');
      expect(booking.totalCost, 599.99);
      expect(booking.createdAt, DateTime(2023, 11, 15));
      expect(booking.pnr, 'ABC123');
      expect(booking.status, 'confirmed');
    });

    test('can be created from JSON', () {
      final json = {
        'id': '1',
        'flight_id': 'FL123',
        'extras': {'baggage': 1},
        'first_name': 'John',
        'last_name': 'Doe',
        'passport': 'P12345678',
        'email': 'john.doe@example.com',
        'total_price': 599.99,
        'created_at': '2023-11-15T10:00:00Z',
        'pnr': 'ABC123',
        'status': 'confirmed',
      };

      final booking = Booking.fromJson(json);

      expect(booking.id, '1');
      expect(booking.flightId, 'FL123');
      expect(booking.extras, {'baggage': 1});
      expect(booking.firstName, 'John');
      expect(booking.lastName, 'Doe');
      expect(booking.passport, 'P12345678');
      expect(booking.email, 'john.doe@example.com');
      expect(booking.totalCost, 599.99);
      expect(booking.createdAt, DateTime.parse('2023-11-15T10:00:00Z'));
      expect(booking.pnr, 'ABC123');
      expect(booking.status, 'confirmed');
    });

    test('can handle missing optional fields in JSON', () {
      final json = {
        'id': '1',
        'flight_id': 'FL123',
        'first_name': 'John',
        'last_name': 'Doe',
        'passport': 'P12345678',
        'email': 'john.doe@example.com',
        'total_price': 599.99,
        'created_at': '2023-11-15T10:00:00Z',
      };

      final booking = Booking.fromJson(json);

      expect(booking.id, '1');
      expect(booking.flightId, 'FL123');
      expect(booking.extras, <String, int>{});
      expect(booking.firstName, 'John');
      expect(booking.lastName, 'Doe');
      expect(booking.passport, 'P12345678');
      expect(booking.email, 'john.doe@example.com');
      expect(booking.totalCost, 599.99);
      expect(booking.createdAt, DateTime.parse('2023-11-15T10:00:00Z'));
      expect(booking.pnr, '');
      expect(booking.status, 'confirmed'); // Default value
    });
  });
}