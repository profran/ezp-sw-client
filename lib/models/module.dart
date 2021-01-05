import 'package:ezp_sw_client/components/light_widget.dart';
import 'package:ezp_sw_client/components/text_widget.dart';
import 'package:flutter/material.dart';

enum ModuleType { light, text, humidity, temperature }

ModuleType moduleTypeFromString(String moduleType) {
  switch (moduleType) {
    case 'light':
      return ModuleType.light;
      break;
    case 'text':
      return ModuleType.text;
      break;
    case 'humidity':
      return ModuleType.humidity;
      break;
    case 'temperature':
      return ModuleType.temperature;
      break;
    default:
      throw Exception('Unknown ModuleType');
  }
}

String moduleTypeToString(ModuleType moduleType) {
  switch (moduleType) {
    case ModuleType.light:
      return 'light';
      break;
    case ModuleType.text:
      return 'text';
      break;
    case ModuleType.humidity:
      return 'humidity';
      break;
    case ModuleType.temperature:
      return 'temperature';
      break;
    default:
      throw Exception('Unknown ModuleType');
  }
}

Widget getWidgetFromModule(Module module) {
  switch (module.type) {
    case ModuleType.light:
      return LightSwitch(module: module);
      break;
    case ModuleType.text:
      return TextWidget(module: module);
      break;
    case ModuleType.humidity:
      return TextWidget(module: module, extra: ' %',);
      break;
    case ModuleType.temperature:
      return TextWidget(module: module, extra: ' C',);
      break;
    default:
      throw Exception('Unknown ModuleType');
  }
}

class Module {
  String alias;
  String topic;
  String state;
  ModuleType type;

  Module({this.alias, this.topic, this.type});

  Module.fromJson(Map<String, dynamic> json) {
    alias = json['alias'];
    topic = json['topic'];
    type = moduleTypeFromString(json['type']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alias'] = this.alias;
    data['topic'] = this.topic;
    data['type'] = moduleTypeToString(this.type);
    return data;
  }
}
