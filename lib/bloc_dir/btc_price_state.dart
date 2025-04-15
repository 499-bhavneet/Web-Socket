class PriceState {
  final double? markPrice;
  final double? alertPrice;
  final bool alertPlayed;
  final String statusMessage;

  PriceState({
    this.markPrice,
    this.alertPrice,
    this.alertPlayed = false,
    this.statusMessage = "No alert set.",
  });

  PriceState copyWith({
    double? markPrice,
    double? alertPrice,
    bool? alertPlayed,
    String? statusMessage,
  }) {
    return PriceState(
      markPrice: markPrice ?? this.markPrice,
      alertPrice: alertPrice ?? this.alertPrice,
      alertPlayed: alertPlayed ?? this.alertPlayed,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }
}
