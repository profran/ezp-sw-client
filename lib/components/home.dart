import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:provider/provider.dart';
import '../components/light_switch.dart';
import '../components/shortcuts_widget.dart';
import '../state/modules.dart';
import '../state/mqtt.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget fab;

    switch (Provider.of<MqttProvider>(context).connectionState) {
      case mqtt.MqttConnectionState.connected:
        fab = FloatingActionButton(
          tooltip: 'Add',
          onPressed: () {
            Navigator.pushNamed(context, '/add');
          },
          child: Icon(Icons.add),
        );
        break;
      case mqtt.MqttConnectionState.connecting:
        fab = FloatingActionButton(
          tooltip: 'Add',
          onPressed: null,
          child: CircularProgressIndicator(),
        );
        break;
      default:
        fab = FloatingActionButton.extended(
          tooltip: 'Connect',
          onPressed: Provider.of<MqttProvider>(context).connect,
          label: Text('Connect to broker'),
        );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Icon(Icons.all_inclusive),
      ),
      backgroundColor: Theme.of(context).appBarTheme.color,
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Text('MQTT Switch'),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Add light'),
                    onTap: () {
                      Navigator.pushNamed(context, '/add');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.close),
                    title: Text('Disconnect'),
                    onTap: () {
                      Provider.of<MqttProvider>(context).disconnect();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 6.0),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        ),
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: Provider.of<ModulesProvider>(context).modules.isNotEmpty
                        ? GridView.count(
                            padding: EdgeInsets.all(18),
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 18,
                            crossAxisCount: 2,
                            childAspectRatio: 2.0 / 1.0,
                            shrinkWrap: true,
                            children: Provider.of<ModulesProvider>(context)
                                .modules
                                .map((module) => LightSwitch(
                                      module: module,
                                    ))
                                .toList(),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
