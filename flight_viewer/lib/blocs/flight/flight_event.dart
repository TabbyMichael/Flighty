abstract class FlightEvent {}

class LoadFlights extends FlightEvent {}

class ApplyFilters extends FlightEvent {
  final double? maxPrice;
  final int? maxStops;
  final Set<String>? airlineCodes;

  ApplyFilters({
    this.maxPrice,
    this.maxStops,
    this.airlineCodes,
  });
}

class SearchFlights extends FlightEvent {
  final String? origin;
  final String? destination;
  final DateTime? departureDate;
  final double? maxPrice;
  final int? maxStops;
  final List<String>? airlineCodes;

  SearchFlights({
    this.origin,
    this.destination,
    this.departureDate,
    this.maxPrice,
    this.maxStops,
    this.airlineCodes,
  });
}