abstract class BookingEvent {}

class LoadBookings extends BookingEvent {
  final String email;

  LoadBookings(this.email);
}

class CreateBooking extends BookingEvent {
  final String flightId;
  final String firstName;
  final String lastName;
  final String passport;
  final String email;
  final Map<String, int> extras;
  final double totalCost;

  CreateBooking({
    required this.flightId,
    required this.firstName,
    required this.lastName,
    required this.passport,
    required this.email,
    required this.extras,
    required this.totalCost,
  });
}