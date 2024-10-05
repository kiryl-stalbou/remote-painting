import 'package:flutter/material.dart';

import '../models/client_model.dart';
import '../models/server_model.dart';
import '../ui/client/client_canvas_screen.dart';
import '../ui/client/client_canvases_screen.dart';
import '../ui/client/client_settings_screen.dart';
import '../ui/home_screen.dart';
import '../ui/server/server_client_screen.dart';
import '../ui/server/server_settings_screen.dart';
import '_pages/material_page.dart';
import 'router_state.dart';

class AppRouterDelegate extends RouterDelegate<RouterState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  AppRouterDelegate(this._state) : _key = GlobalKey() {
    _state.addListener(notifyListeners);
  }

  final GlobalKey<NavigatorState> _key;

  final RouterState _state;

  @override
  void dispose() {
    _state.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _key;

  @override
  Widget build(BuildContext context) {
    final selectedCanvasId = _state.selectedCanvasId;
    final showClientSettings = _state.showClientSettings;
    final streamModel = _state.streamModel;
    final selectedClientModel = _state.selectedClientModel;

    return Navigator(
      key: _key,
      onPopPage: _onPopPage,
      clipBehavior: Clip.none,
      pages: <Page<void>>[
        //
        asMaterialPage(const HomeScreen(), 'HomeScreen'),

        if (streamModel is ServerModel) ...[
          //
          asMaterialPage(
            ServerSettingsScreen(streamModel),
            'ServerSettingsScreen',
          ),

          if (selectedClientModel != null)
            asMaterialPage(
              ServerClientScreen(selectedClientModel),
              'ServerClientScreen',
            ),
        ],

        if (showClientSettings) ...[
          //
          asMaterialPage(const ClientSettingsScreen(), 'ClientSettingsScreen'),

          if (streamModel is ClientModel)
            asMaterialPage(
              ClientCanvasesScreen(
                clientModel: streamModel,
              ),
              'ClientCanvasesScreen',
            ),

          if (streamModel is ClientModel && selectedCanvasId != null)
            asMaterialPage(
              ClientCanvasScreen(
                clientModel: streamModel,
                canvasId: selectedCanvasId,
              ),
              'ClientCanvasScreen',
              true,
            ),
        ],
      ],
    );
  }

  bool _onPopPage(Route<Object?> route, Object? result) {
    if (route.didPop(result)) return _tryPopRoute();

    return false;
  }

  bool _tryPopRoute() {
    if (_state.selectedClientModel != null) {
      _state.selectedClientModel = null;
      return true;
    }

    if (_state.selectedCanvasId != null) {
      _state.selectedCanvasId = null;
      return true;
    }

    if (_state.streamModel != null) {
      _state.streamModel = null;
      return true;
    }

    if (_state.showClientSettings) {
      _state.showClientSettings = false;
      return true;
    }

    return false;
  }

  @override
  Future<void> setNewRoutePath(RouterState configuration) async {}
}
