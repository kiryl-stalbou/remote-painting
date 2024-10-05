import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/client_model.dart';
import '../../router/router_state.dart';
import '../../utils/snackbar.dart';
import '../_widgets/desktop_constraints.dart';

class ClientSettingsScreen extends StatefulWidget {
  const ClientSettingsScreen({super.key});

  @override
  State<ClientSettingsScreen> createState() => _ClientSettingsScreenState();
}

class _ClientSettingsScreenState extends State<ClientSettingsScreen> {
  final _serverIPController =
      TextEditingController(text: kDebugMode ? '127.0.0.1' : null);

  Future<void> _onConnectTap() async {
    try {
      // ignore: close_sinks
      final socket = await Socket.connect(_serverIPController.text, 8096);

      if (!mounted) return;

      context.read<RouterState>().streamModel = ClientModel(stream: socket);
    } on Object catch (e, s) {
      log('$e, $s');
      if (mounted) showSnackBar(context, 'Failed to connect socket');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Client Settings')),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16),
          child: DesktopConstraints(
            child: ListView(
              children: [
                //
                const SizedBox(height: 10),

                TextField(
                  controller: _serverIPController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Server bind IP'),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: _onConnectTap,
                  label: const Text('Connect'),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
        ),
      );
}
