import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_dir/btc_price_bloc.dart';
import 'bloc_dir/btc_price_event.dart';
import 'bloc_dir/btc_price_state.dart';

class BTCPriceScreen extends StatelessWidget {
  final TextEditingController _alertController = TextEditingController();

  BTCPriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PriceBloc>(
      create: (_) => PriceBloc(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('BTC/USDT Price Alert')),
          body: BlocListener<PriceBloc, PriceState>(
            listenWhen: (previous, current) =>
            previous.statusMessage != current.statusMessage,
            listener: (context, state) {
              print('[BlocListener] statusMessage: ${state.statusMessage}');
              if (state.statusMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.statusMessage),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "Live BTC/USDT Price:",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<PriceBloc, PriceState>(
                    buildWhen: (previous, current) =>
                    previous.markPrice != current.markPrice,
                    builder: (context, state) {
                      return Text(
                        state.markPrice != null
                            ? '\$${state.markPrice!.toStringAsFixed(2)}'
                            : 'Loading...',
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _alertController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Set Alert Price (e.g. 43000)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      final input =
                      double.tryParse(_alertController.text.trim());
                      if (input != null) {
                        print('Set Alert button pressed with value: $input');
                        context.read<PriceBloc>().add(UpdateAlertPrice(input));
                      }
                    },
                    child: const Text("Set Alert"),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<PriceBloc, PriceState>(
                    buildWhen: (previous, current) {
                      print("Comparing status messages:");
                      print("Previous: '${previous.statusMessage}'");
                      print("Current: '${current.statusMessage}'");
                      return previous.statusMessage != current.statusMessage;
                    },
                    builder: (context, state) {
                      print("UI Build Triggered with Message: '${state.statusMessage}'");
                      return Text(
                        state.statusMessage,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}