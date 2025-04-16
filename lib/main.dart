import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'bloc_dir/btc_price_bloc.dart';
import 'btc_price_screen.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PriceBloc>(
      create: (context) => PriceBloc(),
      child: MaterialApp(
        title: 'BTC Price Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BTCPriceScreen(),
      ),
    );
  }
}


//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'BTC/USDT Alert',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home:  BTCPriceScreen(),
//     );
//   }
// }
//
//
// class BTCPriceScreen extends StatefulWidget {
//   const BTCPriceScreen({super.key});
//
//   @override
//   State<BTCPriceScreen> createState() => _BTCPriceScreenState();
// }
//
// class _BTCPriceScreenState extends State<BTCPriceScreen> {
//
//   final WebSocketChannel _channel = WebSocketChannel.connect(
//     Uri.parse('wss://fstream.binance.com/ws/btcusdt@markPrice'),
//   );
//
//   final TextEditingController _alertController = TextEditingController();
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   double? _markPrice;
//   double? _alertPrice;
//   bool _alertPlayed = false;
//   String _statusMessage = "No alert set.";
//
//   @override
//   void initState() {
//     super.initState();
//     _listenToWebSocket();
//   }
//
//   void _listenToWebSocket() {
//     _channel.stream.listen(
//           (data) {
//         final decoded = json.decode(data);
//         final newPrice = double.tryParse(decoded['p'] ?? '');
//         if (newPrice != null) {
//           setState(() {
//             _markPrice = newPrice;
//
//             print(_markPrice);
//           });
//           _checkAlert(newPrice);
//         }
//       },
//       onError: (error) {
//         _reconnectWebSocket();
//       },
//       onDone: () {
//         _reconnectWebSocket();
//       },
//     );
//   }
//
//   void _reconnectWebSocket() {
//     Future.delayed(const Duration(seconds: 3), () {
//       _channel.sink.close();
//       setState(() {
//         _statusMessage = 'Reconnecting...';
//       });
//       _listenToWebSocket();
//     });
//   }
//
//   void _checkAlert(double price) {
//     if (_alertPrice != null && !_alertPlayed && price >= _alertPrice!) {
//       _playAlertSound();
//       setState(() {
//         _alertPlayed = true;
//         _statusMessage = "🎯 Alert triggered at \$${price.toStringAsFixed(2)}!";
//       });
//     } else if (_alertPrice != null && !_alertPlayed) {
//       setState(() {
//         _statusMessage = "Waiting for price to reach $_alertPrice...";
//       });
//     }
//   }
//
//   Future<void> _playAlertSound() async {
//     await _audioPlayer.play(AssetSource('beep.mp3'));
//   }
//
//   void _setAlert() {
//     final input = double.tryParse(_alertController.text);
//     if (input != null) {
//       setState(() {
//         _alertPrice = input;
//         _alertPlayed = false;
//         _statusMessage = "Waiting for price to reach $_alertPrice...";
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _channel.sink.close();
//     _alertController.dispose();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('BTC/USDT Price Alert')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const SizedBox(height: 16),
//             Text(
//               "Live BTC/USDT Price:",
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             const SizedBox(height: 10),
//             Text(
//               _markPrice != null ? '\$${_markPrice!.toStringAsFixed(2)}' : 'Loading...',
//               style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 30),
//             TextField(
//               controller: _alertController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: 'Set Alert Price (e.g. 43000)',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _setAlert,
//               child: const Text("Set Alert"),
//             ),
//             const SizedBox(height: 20),
//             Text(_statusMessage),
//           ],
//         ),
//       ),
//     );
//   }
// }
