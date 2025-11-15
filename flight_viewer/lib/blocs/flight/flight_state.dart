import '../../models/flight.dart';

abstract class FlightState {}

class FlightInitial extends FlightState {}

class FlightLoading extends FlightState {}

class FlightLoaded extends FlightState {
  final List<Flight> flights;
  final List<Flight> allFlights;
  final double? currentMaxPrice;
  final int? currentMaxStops;
  final Set<String> selectedAirlines;

  FlightLoaded({
    required this.flights,
    required this.allFlights,
    this.currentMaxPrice,
    this.currentMaxStops,
    Set<String>? selectedAirlines,
  }) : selectedAirlines = selectedAirlines ?? {};

  FlightLoaded copyWith({
    List<Flight>? flights,
    List<Flight>? allFlights,
    double? currentMaxPrice,
    int? currentMaxStops,
    Set<String>? selectedAirlines,
  }) {
    return FlightLoaded(
      flights: flights ?? this.flights,
      allFlights: allFlights ?? this.allFlights,
      currentMaxPrice: currentMaxPrice ?? this.currentMaxPrice,
      currentMaxStops: currentMaxStops ?? this.currentMaxStops,
      selectedAirlines: selectedAirlines ?? this.selectedAirlines,
    );
  }
}

class FlightError extends FlightState {
  final String message;

  FlightError(this.message);
}