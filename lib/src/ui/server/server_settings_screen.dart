import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/client_model.dart';
import '../../models/server_model.dart';
import '../../router/router_state.dart';
import '../_widgets/desktop_constraints.dart';

class ServerSettingsScreen extends StatelessWidget {
  const ServerSettingsScreen(this.serverModel, {super.key});

  final ServerModel serverModel;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => serverModel,
        child: Scaffold(
          appBar: AppBar(title: Text('Server live at: ${serverModel.ip}')),
          body: const SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 16),
            child: DesktopConstraints(
              child: _Clients(),
            ),
          ),
        ),
      );
}

class _Clients extends StatelessWidget {
  const _Clients();

  @override
  Widget build(BuildContext context) {
    final serverModel = context.watch<ServerModel>();

    return ListView.builder(
      itemCount: serverModel.clientModels.length,
      itemBuilder: (context, index) => _ClientTile(
        clientModel: serverModel.clientModels[index],
      ),
    );
  }
}

class _ClientTile extends StatelessWidget {
  const _ClientTile({
    required this.clientModel,
  });

  final ClientModel clientModel;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Listenable.merge([clientModel, clientModel.isConnected]),
        builder: (_, __) {
          final isConnected = clientModel.isConnected.value;

          return ListTile(
            onTap: () {
              context.read<RouterState>().selectedClientModel = clientModel;
            },
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            leading: const Icon(Icons.person_rounded),
            title: Text(clientModel.remoteIp),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //
                Text('Canvases: ${clientModel.canvases.length},'),

                const SizedBox(width: 10),

                Text('${isConnected ? 'Online' : 'Offline'}:'),

                const SizedBox(width: 5),

                SizedBox(
                  height: 12,
                  width: 12,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: isConnected ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                IconButton(
                  onPressed: () => context
                      .read<ServerModel>()
                      .removeClient(clientModel.remoteIp),
                  icon: const Icon(Icons.delete_forever_rounded),
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          );
        },
      );
}
