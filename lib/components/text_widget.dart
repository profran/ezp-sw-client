import 'package:flutter/material.dart';

import '../models/module.dart';
import 'module_base.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({Key key, @required this.module, this.extra})
      : super(key: key);

  final Module module;
  final String extra;

  @override
  Widget build(BuildContext context) {
    return ModuleBase(
      onPressed: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(module.alias),
          Text(
            (module.state ?? '--') + (extra ?? ''),
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
