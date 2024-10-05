import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/router/router_delegate.dart';
import 'src/router/router_state.dart';

class App extends StatelessWidget {
  const App({super.key});

  static final _routerState = RouterState();
  static final _routerDelegate = AppRouterDelegate(_routerState);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => _routerState,
        child: MaterialApp.router(
          title: 'Remote Painting',
          routerDelegate: _routerDelegate,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: Colors.blue,
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
}
