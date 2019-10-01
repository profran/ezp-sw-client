import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_switch/state/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key, this.addLight}) : super(key: key);

  final Function addLight;

  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('SettingsScreen'),
      ),
      backgroundColor: Colors.grey[800],
      body: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.only(bottom: 16.0, top: 16.0),
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.only(
                  left: 72.0,
                  right: 32.0,
                ),
                title: Text('Broker URL'),
                subtitle: Text(Settings.of(context).brokerURL ?? 'Broker URL not set'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        title: Text('Edit broker URL'),
                        content: TextFormField(
                          controller: urlController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field is not optional';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'URL',
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            onPressed: () {
                              Settings.of(context).changeBrokerURL(urlController.text);
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Divider(
                indent: 0.0,
                endIndent: 0.0,
              ),
              ListTile(
                contentPadding: EdgeInsets.only(
                  left: 72.0,
                  right: 16.0,
                ),
                title: Text('Demo mode'),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // _saveDemoMode(value);
                  },
                ),
              ),
              Divider(
                indent: 0.0,
                endIndent: 0.0,
              ),
              ListTile(
                contentPadding: EdgeInsets.only(
                  left: 72.0,
                  right: 16.0,
                ),
                title: Text('Dark mode'),
                subtitle: Text('This shouldn\'t be an option'),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
