import 'package:flutter/material.dart';

import '../models/client_model.dart';
import '../models/stream_model.dart';

final class RouterState extends ChangeNotifier {
  bool _showClientSettings = false;
  bool get showClientSettings => _showClientSettings;
  set showClientSettings(bool showClientSettings) {
    if (_showClientSettings == showClientSettings) return;

    _showClientSettings = showClientSettings;
    notifyListeners();
  }

  StreamModel? _streamModel;
  StreamModel? get streamModel => _streamModel;
  set streamModel(StreamModel? streamModel) {
    if (_streamModel == streamModel) return;

    _streamModel = streamModel;
    notifyListeners();

    if (streamModel is ClientModel) {
      _streamModel?.onDoneCallback = () => this.streamModel = null;
      _selectedCanvasId = null;
    }
  }

  int? _selectedCanvasId;
  int? get selectedCanvasId => _selectedCanvasId;
  set selectedCanvasId(int? selectedCanvasId) {
    if (_selectedCanvasId == selectedCanvasId) return;

    _selectedCanvasId = selectedCanvasId;
    notifyListeners();
  }

  ClientModel? _selectedClientModel;
  ClientModel? get selectedClientModel => _selectedClientModel;
  set selectedClientModel(ClientModel? selectedClientModel) {
    if (_selectedClientModel == selectedClientModel) return;

    _selectedClientModel = selectedClientModel;
    notifyListeners();
  }
}
