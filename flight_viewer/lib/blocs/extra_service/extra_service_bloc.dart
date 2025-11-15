import 'package:bloc/bloc.dart';
import '../../services/api_service.dart';
import '../../services/haptics_service.dart';
import 'extra_service_event.dart';
import 'extra_service_state.dart';

class ExtraServiceBloc extends Bloc<ExtraServiceEvent, ExtraServiceState> {
  final ApiService _apiService = ApiService();
  final HapticsService _hapticsService = HapticsService();

  ExtraServiceBloc() : super(ExtraServiceInitial()) {
    on<LoadServices>(_onLoadServices);
    on<UpdateQuantity>(_onUpdateQuantity);
  }

  Future<void> _onLoadServices(LoadServices event, Emitter<ExtraServiceState> emit) async {
    emit(ExtraServiceLoading());
    try {
      final services = await _apiService.fetchServices();
      
      // Initialize selected quantities map
      final selectedQuantities = <String, int>{};
      for (final service in services) {
        if (service.isMandatory) {
          selectedQuantities[service.id] = service.minQuantity;
        }
      }
      
      emit(ExtraServiceLoaded(
        services: services,
        selectedQuantities: selectedQuantities,
      ));
    } catch (e) {
      emit(ExtraServiceError(e.toString()));
      _hapticsService.error();
    }
  }

  Future<void> _onUpdateQuantity(UpdateQuantity event, Emitter<ExtraServiceState> emit) async {
    if (state is ExtraServiceLoaded) {
      final currentState = state as ExtraServiceLoaded;
      
      final updatedQuantities = Map<String, int>.from(currentState.selectedQuantities);
      updatedQuantities[event.serviceId] = event.quantity;
      
      emit(currentState.copyWith(selectedQuantities: updatedQuantities));
      _hapticsService.lightImpact();
    }
  }
}