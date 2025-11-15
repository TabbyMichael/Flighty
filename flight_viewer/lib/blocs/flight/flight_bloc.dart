import 'package:bloc/bloc.dart';
import '../../services/api_service.dart';
import '../../services/haptics_service.dart';
import 'flight_event.dart';
import 'flight_state.dart';

class FlightBloc extends Bloc<FlightEvent, FlightState> {
  final ApiService _apiService = ApiService();
  final HapticsService _hapticsService = HapticsService();

  FlightBloc() : super(FlightInitial()) {
    on<LoadFlights>(_onLoadFlights);
    on<ApplyFilters>(_onApplyFilters);
    on<SearchFlights>(_onSearchFlights);
  }

  Future<void> _onLoadFlights(LoadFlights event, Emitter<FlightState> emit) async {
    emit(FlightLoading());
    try {
      final flights = await _apiService.fetchFlights();
      emit(FlightLoaded(
        flights: flights,
        allFlights: flights,
      ));
      _hapticsService.success();
    } catch (e) {
      emit(FlightError(e.toString()));
      _hapticsService.error();
    }
  }

  Future<void> _onApplyFilters(ApplyFilters event, Emitter<FlightState> emit) async {
    // This assumes we already have flights loaded
    if (state is FlightLoaded) {
      final currentState = state as FlightLoaded;
      
      final filteredFlights = currentState.allFlights.where((f) {
        if (event.maxPrice != null && f.price > event.maxPrice!) return false;
        if (event.maxStops != null && f.stops > event.maxStops!) return false;
        if (event.airlineCodes != null && 
            event.airlineCodes!.isNotEmpty && 
            !event.airlineCodes!.contains(f.airlineCode)) {
          return false;
        }
        return true;
      }).toList();

      emit(currentState.copyWith(
        flights: filteredFlights,
        currentMaxPrice: event.maxPrice,
        currentMaxStops: event.maxStops,
        selectedAirlines: event.airlineCodes,
      ));
      
      _hapticsService.lightImpact();
    }
  }

  Future<void> _onSearchFlights(SearchFlights event, Emitter<FlightState> emit) async {
    emit(FlightLoading());
    try {
      final flights = await _apiService.searchFlights(
        origin: event.origin,
        destination: event.destination,
        departureDate: event.departureDate,
        maxPrice: event.maxPrice,
        maxStops: event.maxStops,
        airlineCodes: event.airlineCodes,
      );
      
      emit(FlightLoaded(
        flights: flights,
        allFlights: flights,
        currentMaxPrice: event.maxPrice,
        currentMaxStops: event.maxStops,
      ));
      
      _hapticsService.success();
    } catch (e) {
      emit(FlightError(e.toString()));
      _hapticsService.error();
    }
  }
}