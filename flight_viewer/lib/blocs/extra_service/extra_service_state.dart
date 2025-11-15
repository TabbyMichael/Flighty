import '../../models/extra_service.dart';

abstract class ExtraServiceState {}

class ExtraServiceInitial extends ExtraServiceState {}

class ExtraServiceLoading extends ExtraServiceState {}

class ExtraServiceLoaded extends ExtraServiceState {
  final List<ExtraService> services;
  final Map<String, int> selectedQuantities;

  ExtraServiceLoaded({
    required this.services,
    required this.selectedQuantities,
  });

  ExtraServiceLoaded copyWith({
    List<ExtraService>? services,
    Map<String, int>? selectedQuantities,
  }) {
    return ExtraServiceLoaded(
      services: services ?? this.services,
      selectedQuantities: selectedQuantities ?? this.selectedQuantities,
    );
  }

  double get totalCost {
    double total = 0;
    for (final service in services) {
      final qty = selectedQuantities[service.id] ?? 
                 (service.isMandatory ? service.minQuantity : 0);
      total += qty * service.price;
    }
    return total;
  }

  int quantityFor(String id) => selectedQuantities[id] ?? 0;

  ExtraService? getServiceById(String id) {
    try {
      return services.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }
}

class ExtraServiceError extends ExtraServiceState {
  final String message;

  ExtraServiceError(this.message);
}