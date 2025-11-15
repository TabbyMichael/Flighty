import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flight_viewer/blocs/flight/flight_bloc.dart';
import 'package:flight_viewer/blocs/flight/flight_event.dart';
import 'package:flight_viewer/blocs/flight/flight_state.dart';
import 'package:flight_viewer/services/api_service.dart';
import 'package:flight_viewer/models/flight.dart';
import 'package:flight_viewer/services/haptics_service.dart';

// Import the generated mocks
import 'flight_bloc_test.mocks.dart';

void main() {
  group('FlightBloc', () {
    late FlightBloc flightBloc;
    late MockApiService mockApiService;
    late MockHapticsService mockHapticsService;

    // Create test data
    final testFlights = [
      Flight(
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
      ),
    ];

    setUp(() {
      mockApiService = MockApiService();
      mockHapticsService = MockHapticsService();
      flightBloc = FlightBloc(apiService: mockApiService, hapticsService: mockHapticsService);
    });

    tearDown(() {
      flightBloc.close();
    });

    test('initial state is FlightInitial', () {
      expect(flightBloc.state, equals(FlightInitial()));
    });

    test('emits FlightLoading then FlightLoaded when LoadFlights succeeds', () async {
      // Arrange
      when(mockApiService.fetchFlights()).thenAnswer((_) async => testFlights);

      // Assert
      expectLater(
        flightBloc.stream,
        emitsInOrder([FlightLoading(), FlightLoaded(flights: testFlights, allFlights: testFlights)]),
      );

      // Act
      flightBloc.add(LoadFlights());
      await untilCalled(mockApiService.fetchFlights());
      
      // Verify
      verify(mockApiService.fetchFlights()).called(1);
      verify(mockHapticsService.success()).called(1);
    });

    test('emits FlightLoading then FlightError when LoadFlights fails', () async {
      // Arrange
      final exception = Exception('Failed to load flights');
      when(mockApiService.fetchFlights()).thenThrow(exception);

      // Assert
      expectLater(
        flightBloc.stream,
        emitsInOrder([FlightLoading(), FlightError(exception.toString())]),
      );

      // Act
      flightBloc.add(LoadFlights());
      await untilCalled(mockApiService.fetchFlights());
      
      // Verify
      verify(mockApiService.fetchFlights()).called(1);
      verify(mockHapticsService.error()).called(1);
    });

    test('emits FlightLoading then FlightLoaded when SearchFlights succeeds', () async {
      // Arrange
      when(mockApiService.searchFlights(
        origin: 'JFK',
        destination: 'LAX',
        departureDate: anyNamed('departureDate'),
      )).thenAnswer((_) async => testFlights);

      // Assert
      expectLater(
        flightBloc.stream,
        emitsInOrder([FlightLoading(), FlightLoaded(flights: testFlights, allFlights: testFlights)]),
      );

      // Act
      flightBloc.add(SearchFlights(origin: 'JFK', destination: 'LAX'));
      await untilCalled(mockApiService.searchFlights(
        origin: 'JFK',
        destination: 'LAX',
        departureDate: anyNamed('departureDate'),
      ));
      
      // Verify
      verify(mockApiService.searchFlights(
        origin: 'JFK',
        destination: 'LAX',
        departureDate: anyNamed('departureDate'),
      )).called(1);
      verify(mockHapticsService.success()).called(1);
    });
  });
}