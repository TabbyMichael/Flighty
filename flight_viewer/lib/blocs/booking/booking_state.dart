import '../../models/booking.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<Booking> bookings;

  BookingLoaded({required this.bookings});

  BookingLoaded copyWith({List<Booking>? bookings}) {
    return BookingLoaded(
      bookings: bookings ?? this.bookings,
    );
  }
}

class BookingError extends BookingState {
  final String message;

  BookingError(this.message);
}