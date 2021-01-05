import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'state/modules.dart';
import 'state/mqtt.dart';
import 'state/settings.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ModulesProvider()),
        ChangeNotifierProxyProvider2<SettingsProvider, ModulesProvider,
            MqttProvider>(
          create: (_) => MqttProvider(),
          update: (context, settings, modules, mqtt) => mqtt
            ..settings = settings
            ..modules = modules,
        )
      ],
      child: App(),
    );
  }
}
