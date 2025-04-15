import 'dart:async';
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
    on<ConnectWebSocket>((event, emit) async {
      print("Connecting to WebSocket...");
      _channel.stream.listen(
            (data) {
          print("Received WebSocket Data: $data");
          final decoded = json.decode(data);
          final newPrice = double.tryParse(decoded['p'] ?? '');

          if (newPrice != null) {
            print("Parsed Price: $newPrice");
            add(PriceUpdated(newPrice));
          }
        },
        onError: (error) {
          print("WebSocket Error: $error");
          _reconnectWebSocket();
        },
        onDone: () {
          print("WebSocket Done.");
          _reconnectWebSocket();
        },
      );
    });

    on<UpdateAlertPrice>(_onUpdateAlertPrice);

    on<PriceUpdated>((event, emit) async {
      final newPrice = event.markPrice;

      if (state.alertPrice != null &&
          !state.alertPlayed &&
          newPrice >= state.alertPrice!) {
        await _audioPlayer.play(AssetSource('beep.mp3'));
        emit(state.copyWith(
          markPrice: newPrice,
          alertPlayed: true,
          statusMessage: "🎯 Alert triggered at \$${newPrice.toStringAsFixed(2)}!",
        ));
      } else if (state.alertPrice != null && !state.alertPlayed) {
        emit(state.copyWith(
          markPrice: newPrice,
          statusMessage: "Waiting for price to reach ${state.alertPrice}...",
        ));
      } else {
        emit(state.copyWith(markPrice: newPrice));
      }
    });

    add(ConnectWebSocket());
  }

  void _onUpdateAlertPrice(UpdateAlertPrice event, Emitter<PriceState> emit) {
    emit(state.copyWith(
      alertPrice: event.alertPrice,
      alertPlayed: false,
      statusMessage: "Waiting for price to reach ${event.alertPrice}...",
    ));
  }

  void _reconnectWebSocket() {
    Future.delayed(const Duration(seconds: 3), () {
      _channel.sink.close();
      add(ConnectWebSocket());
    });
  }

  @override
  Future<void> close() {
    _channel.sink.close();
    _audioPlayer.dispose();
    return super.close();
  }
}
