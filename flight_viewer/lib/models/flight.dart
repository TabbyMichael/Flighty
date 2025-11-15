class Flight {
  final String id;
  final String airlineCode;
  final String airlineName;
  final String flightNumber;
  final String departureAirport;
  final String arrivalAirport;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int duration; // in minutes
  final double price;
  final int stops;
  final String currency;
  final List<Segment> segments;
  final String cabinClass;

  Flight({
    required this.id,
    required this.airlineCode,
    required this.airlineName,
    required this.flightNumber,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
    required this.stops,
    required this.currency,
    required this.segments,
    required this.cabinClass,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    // Parse departure time
    DateTime departureTime;
    try {
      // Handle different date formats from the new backend
      if (json['departure_time'] is String) {
        departureTime = DateTime.parse(json['departure_time']);
      } else if (json['departureTime'] is String) {
        departureTime = DateTime.parse(json['departureTime']);
      } else {
        departureTime = DateTime.now();
      }
    } catch (e) {
      departureTime = DateTime.now();
    }
    
    // Parse arrival time
    DateTime arrivalTime;
    try {
      // Handle different date formats from the new backend
      if (json['arrival_time'] is String) {
        arrivalTime = DateTime.parse(json['arrival_time']);
      } else if (json['arrivalTime'] is String) {
        arrivalTime = DateTime.parse(json['arrivalTime']);
      } else {
        arrivalTime = DateTime.now();
      }
    } catch (e) {
      arrivalTime = DateTime.now();
    }
    
    // Extract values with fallbacks for different backend formats
    final String flightNumber = json['flight_number'] ?? json['flightNumber'] ?? '';
    final String airlineCode = json['airline'] ?? json['airlineCode'] ?? '';
    final String airlineName = json['airline_name'] ?? json['airlineName'] ?? airlineCode;
    final String departureAirport = json['departure_airport'] ?? json['departureAirport'] ?? '';
    final String arrivalAirport = json['arrival_airport'] ?? json['arrivalAirport'] ?? '';
    final int duration = json['duration'] ?? 0;
    final double price = (json['price'] ?? 0).toDouble();
    final int stops = json['stops'] ?? 0;
    final String currency = json['currency'] ?? 'USD';
    final String cabinClass = json['cabin_class'] ?? json['cabinClass'] ?? 'ECONOMY';
    
    return Flight(
      id: json['id'] ?? '',
      airlineCode: airlineCode,
      airlineName: airlineName,
      flightNumber: flightNumber,
      departureAirport: departureAirport,
      arrivalAirport: arrivalAirport,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
      duration: duration,
      price: price,
      stops: stops,
      currency: currency,
      cabinClass: cabinClass,
      segments: (json['segments'] as List<dynamic>?)
              ?.map((segment) => Segment.fromJson(segment))
              .toList() ??
          [],
    );
  }
}

class Segment {
  final String departureAirport;
  final String arrivalAirport;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String flightNumber;
  final String airlineCode;
  final String airlineName;
  final int duration; // in minutes

  Segment({
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    required this.flightNumber,
    required this.airlineCode,
    required this.airlineName,
    required this.duration,
  });

  factory Segment.fromJson(Map<String, dynamic> json) {
    // Parse departure time
    DateTime departureTime;
    try {
      // Handle different date formats from the new backend
      if (json['departure_time'] is String) {
        departureTime = DateTime.parse(json['departure_time']);
      } else if (json['departureTime'] is String) {
        departureTime = DateTime.parse(json['departureTime']);
      } else {
        departureTime = DateTime.now();
      }
    } catch (e) {
      departureTime = DateTime.now();
    }
    
    // Parse arrival time
    DateTime arrivalTime;
    try {
      // Handle different date formats from the new backend
      if (json['arrival_time'] is String) {
        arrivalTime = DateTime.parse(json['arrival_time']);
      } else if (json['arrivalTime'] is String) {
        arrivalTime = DateTime.parse(json['arrivalTime']);
      } else {
        arrivalTime = DateTime.now();
      }
    } catch (e) {
      arrivalTime = DateTime.now();
    }
    
    // Extract values with fallbacks for different backend formats
    final String flightNumber = json['flight_number'] ?? json['flightNumber'] ?? '';
    final String airlineCode = json['airline'] ?? json['airlineCode'] ?? '';
    final String airlineName = json['airline_name'] ?? json['airlineName'] ?? airlineCode;
    final String departureAirport = json['departure_airport'] ?? json['departureAirport'] ?? '';
    final String arrivalAirport = json['arrival_airport'] ?? json['arrivalAirport'] ?? '';
    final int duration = json['duration'] ?? 0;
    
    return Segment(
      departureAirport: departureAirport,
      arrivalAirport: arrivalAirport,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
      flightNumber: flightNumber,
      airlineCode: airlineCode,
      airlineName: airlineName,
      duration: duration,
    );
  }
}