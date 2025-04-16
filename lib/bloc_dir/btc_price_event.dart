abstract class PriceEvent {}

class ConnectWebSocket extends PriceEvent {}

class UpdateAlertPrice extends PriceEvent {
  final double alertPrice;

  UpdateAlertPrice(this.alertPrice);
}

class PriceUpdated extends PriceEvent {
  final double markPrice;

  PriceUpdated(this.markPrice);
}

