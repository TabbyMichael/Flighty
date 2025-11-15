import 'package:bloc/bloc.dart';
import '../../models/booking.dart';
import '../../services/api_service.dart';
import '../../services/haptics_service.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final ApiService _apiService = ApiService();
  final HapticsService _hapticsService = HapticsService();

  BookingBloc() : super(BookingInitial()) {
    on<LoadBookings>(_onLoadBookings);
    on<CreateBooking>(_onCreateBooking);
  }

  Future<void> _onLoadBookings(LoadBookings event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings = await _apiService.fetchUserBookings(event.email);
      emit(BookingLoaded(bookings: bookings));
      _hapticsService.success();
    } catch (e) {
      emit(BookingError(e.toString()));
      _hapticsService.error();
    }
  }

  Future<void> _onCreateBooking(CreateBooking event, Emitter<BookingState> emit) async {
    try {
      final booking = await _apiService.createBooking(
        flightId: event.flightId,
        firstName: event.firstName,
        lastName: event.lastName,
        passport: event.passport,
        email: event.email,
        extras: event.extras,
        totalCost: event.totalCost,
      );

      // If we already have bookings loaded, add the new one to the list
      if (state is BookingLoaded) {
        final currentState = state as BookingLoaded;
        final updatedBookings = List<Booking>.from(currentState.bookings)..add(booking);
        emit(currentState.copyWith(bookings: updatedBookings));
      } else {
        // Otherwise, just emit the new booking in a list
        emit(BookingLoaded(bookings: [booking]));
      }

      _hapticsService.success();
    } catch (e) {
      emit(BookingError(e.toString()));
      _hapticsService.error();
      rethrow;
    }
  }
}