import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/module.dart';

class ModulesProvider extends ChangeNotifier {
  List<Module> modules = <Module>[];

  ModulesProvider() {
    this._getSavedModules();
  }

  void addModule(String alias, String topic, ModuleType type) async {
    this.modules.add(Module(alias: alias, topic: topic, type: type));

    _saveModules();
    notifyListeners();
  }

  void changeModuleState(String topic, String state) {
    List<Module> match = this.modules.where((el) => el.topic == topic).toList();

    // TODO: Add validator depending on the module type
    match?.forEach((el) => el.state = state);
    notifyListeners();
  }

  void _saveModules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> moduleList = [];
    this
        .modules
        .forEach((module) => moduleList.add(json.encode(module.toJson())));
    await prefs.setStringList('modules', moduleList);
  }

  void _getSavedModules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedModules = prefs.getStringList('modules');

    savedModules?.forEach(
        (module) => this.modules.add(Module.fromJson(json.decode(module))));
    notifyListeners();
  }
}
