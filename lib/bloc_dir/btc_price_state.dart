import 'package:equatable/equatable.dart';

class PriceState extends Equatable {
  final double? markPrice;
  final double? alertPrice;
  final bool alertPlayed;
  final String statusMessage;

  const PriceState({
    this.markPrice,
    this.alertPrice,
    this.alertPlayed = false,
    this.statusMessage = '',
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

  @override
  List<Object?> get props => [markPrice, alertPrice, alertPlayed, statusMessage];

  @override
  String toString() => 'PriceState(markPrice: $markPrice, alertPrice: $alertPrice, '
      'alertPlayed: $alertPlayed, statusMessage: $statusMessage)';
}