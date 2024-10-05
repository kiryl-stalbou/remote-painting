import 'dart:io';

import 'client_model.dart';
import 'stream_model.dart';

final class ServerModel extends StreamModel<ServerSocket, Socket> {
  ServerModel({required super.stream}) : ip = stream.address.address;

  final String ip;

  final Map<String, ClientModel> _clientModelByIp = {};

  List<ClientModel> get clientModels => _clientModelByIp.values.toList();

  @override
  void onData(Socket data) {
    _clientModelByIp.update(
      data.address.address,
      (clientModel) => clientModel
        ..initialize(data)
        ..syncCanvases(),
      ifAbsent: () => ClientModel(stream: data),
    );

    notifyListeners();
  }

  @override
  void onDone() {
    super.onDone();

    for (final client in _clientModelByIp.values) {
      // ignore: discarded_futures
      client.onDone();
    }
    // ignore: discarded_futures
    stream.close();
  }

  void removeClient(String clientIp) {
    final clientModel = _clientModelByIp.remove(clientIp);
    // ignore: discarded_futures
    clientModel?.onDone();
    notifyListeners();
  }
}
