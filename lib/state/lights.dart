import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_switch/models/light.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LightsContainer extends StatefulWidget {
  LightsContainer({Key key, this.child}) : super(key: key);

  final Widget child;

  _LightsContainerState createState() => _LightsContainerState();
}

class _LightsContainerState extends State<LightsContainer> {
  List<Light> lights = <Light>[];

  void addLight(String alias, String topic) async {
    Light light = Light(alias: alias, topic: topic);
    setState(() {
      lights.add(light);
    });
    _saveLights();
  }

  void _saveLights() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> lightList = [];
    lights.forEach((light) => lightList.add(json.encode(light.toJson())));
    await prefs.setStringList('lights', lightList);
  }

  void _getSavedLights() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedLights = prefs.getStringList('lights');

    lights = [];
    savedLights
        ?.forEach((light) => lights.add(Light.fromJson(json.decode(light))));

    setState(() {
      lights = lights;
    });
  }

  void changeLightState(String topic, bool state) {
    List<Light> match = this.lights.where((el) => el.topic == topic).toList();

    if (match != null) {
      setState(() {
        match.forEach((el) => el.state = state);
      });
    }
  }

  @override
  void initState() {
    _getSavedLights();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Lights(
      lights,
      addLight,
      changeLightState,
      child: this.widget.child,
    );
  }
}

class Lights extends InheritedWidget {
  Lights(this.lights, this.addLight, this.changeLightState, {Key key, this.child})
      : super(key: key, child: child);

  final Widget child;
  final List<Light> lights;
  final Function addLight;
  final Function changeLightState;

  static Lights of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Lights) as Lights);
  }

  @override
  bool updateShouldNotify(Lights oldWidget) {
    return true;
  }
}
