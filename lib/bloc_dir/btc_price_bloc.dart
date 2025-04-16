import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:audioplayers/audioplayers.dart';

import 'btc_price_event.dart';
import 'btc_price_state.dart';

class PriceBloc extends Bloc<PriceEvent, PriceState> {
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('wss://fstream.binance.com/ws/btcusdt@markPrice'),
  );

  final AudioPlayer _audioPlayer = AudioPlayer();

  PriceBloc() : super(PriceState()) {
    on<ConnectWebSocket>(_onConnectWebSocket);
    on<PriceUpdated>(_onPriceUpdated);
    on<UpdateAlertPrice>(_onUpdateAlertPrice);

    add(ConnectWebSocket());
  }

  void _onConnectWebSocket(ConnectWebSocket event, Emitter<PriceState> emit) {
    _channel.stream.listen(
          (data) {
        final decoded = json.decode(data);
        final newPrice = double.tryParse(decoded['p'] ?? '');
        if (newPrice != null) {
          add(PriceUpdated(newPrice));
        }
      },
      onError: (error) {
        print("WebSocket Error: $error");
      },
      onDone: () {
        print("WebSocket connection closed.");
      },
    );
  }

  Future<void> _onPriceUpdated(PriceUpdated event, Emitter<PriceState> emit) async {
    final newPrice = event.markPrice;

    if (state.alertPrice != null && !state.alertPlayed && newPrice >= state.alertPrice!) {
      await _audioPlayer.play(AssetSource('beep.mp3'));
      emit(state.copyWith(
        markPrice: newPrice,
        alertPlayed: true,
        statusMessage: "🎯 Alert triggered at \$${newPrice.toStringAsFixed(2)}!",
      ));
    } else if (state.alertPrice != null && !state.alertPlayed) {
      final message = "Waiting for price to reach \$${state.alertPrice!.toStringAsFixed(2)}...";
      emit(state.copyWith(
        markPrice: newPrice,
        statusMessage: message,
      ));
    } else {
      emit(state.copyWith(markPrice: newPrice));
    }
  }

  void _onUpdateAlertPrice(UpdateAlertPrice event, Emitter<PriceState> emit) {
    print('Setting alert price to: ${event.alertPrice}');

    final newState = PriceState(
      markPrice: state.markPrice,
      alertPrice: event.alertPrice,
      alertPlayed: false,
      statusMessage: "✅ Alert price set to \$${event.alertPrice.toStringAsFixed(2)}",
    );

    emit(newState);

    print('New status message should be: ${newState.statusMessage}');
  }

  @override
  Future<void> close() {
    _channel.sink.close();
    _audioPlayer.dispose();
    return super.close();
  }
}