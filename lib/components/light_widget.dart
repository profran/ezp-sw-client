import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'module_base.dart';
import '../models/module.dart';
import '../state/mqtt.dart';

class LightSwitch extends StatelessWidget {
  const LightSwitch({Key key, this.module}) : super(key: key);

  final Module module;

  @override
  Widget build(BuildContext context) {
    bool sw = module.state == '1';

    return ModuleBase(
      color: sw
          ? Theme.of(context).primaryColor
          : Theme.of(context).dialogBackgroundColor,
      onPressed: () {
        Provider.of<MqttProvider>(context, listen: false)
            .switchHandler(module.topic, !sw);
      },
      child: Text(
        module.alias,
        style: sw ? Theme.of(context).primaryTextTheme.button : null,
      ),
    );
  }
}
