abstract class ExtraServiceEvent {}

class LoadServices extends ExtraServiceEvent {}

class UpdateQuantity extends ExtraServiceEvent {
  final String serviceId;
  final int quantity;

  UpdateQuantity(this.serviceId, this.quantity);
}