import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController urlController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Settings'),
      ),
      backgroundColor: Theme.of(context).appBarTheme.color,
      body: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        ),
        child: ListView(
          children: <Widget>[
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.only(
                left: 72.0,
                right: 32.0,
              ),
              title: Text('Broker',
                  style: TextStyle(color: Theme.of(context).accentColor)),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(
                left: 72.0,
                right: 16.0,
              ),
              title: Text('AWS Iot Core'),
              // TODO: Use Consumer<T> instead of Provider.of<T>
              trailing: Consumer<SettingsProvider>(
                builder: (_, settings, __) => Switch(
                  value: settings.usesAWSIotCore,
                  onChanged: (value) {
                    settings.changeUsesAWSIotCore(value);
                  },
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(
                left: 72.0,
                right: 32.0,
              ),
              title: Text('URL'),
              subtitle: Text(Provider.of<SettingsProvider>(context).brokerURL ??
                  'URL not set'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      title: Text('Edit broker URL'),
                      content: TextFormField(
                        controller: urlController,
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
                          onPressed: () {
                            Provider.of<SettingsProvider>(context,
                                    listen: false)
                                .changeBrokerURL(urlController.text);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Save',
                            style: Theme.of(context).primaryTextTheme.button,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(
                left: 72.0,
                right: 32.0,
              ),
              title: Text('Port'),
              subtitle: Text(Provider.of<SettingsProvider>(context)
                      .brokerPort
                      .toString() ??
                  'Port not set'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      title: Text('Edit broker port'),
                      content: TextFormField(
                        controller: portController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Port',
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
                          onPressed: () {
                            Provider.of<SettingsProvider>(context,
                                    listen: false)
                                .changeBrokerPort(
                                    int.tryParse(portController.text) ?? null);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Save',
                            style: Theme.of(context).primaryTextTheme.button,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(
                left: 72.0,
                right: 32.0,
              ),
              title: Text('Username'),
              subtitle: Text(
                  Provider.of<SettingsProvider>(context).brokerUsername ??
                      'Username not set'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      title: Text('Edit broker username'),
                      content: TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
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
                          onPressed: () {
                            Provider.of<SettingsProvider>(context,
                                    listen: false)
                                .changeBrokerUsername(usernameController.text);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Save',
                            style: Theme.of(context).primaryTextTheme.button,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(
                left: 72.0,
                right: 32.0,
              ),
              title: Text('Password'),
              subtitle: Text(
                  Provider.of<SettingsProvider>(context).brokerPassword ??
                      'Password not set'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      title: Text('Edit broker password'),
                      content: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
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
                          onPressed: () {
                            Provider.of<SettingsProvider>(context,
                                    listen: false)
                                .changeBrokerPassword(passwordController.text);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Save',
                            style: Theme.of(context).primaryTextTheme.button,
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
              dense: true,
              contentPadding: EdgeInsets.only(
                left: 72.0,
                right: 32.0,
              ),
              title: Text('Appearance',
                  style: TextStyle(color: Theme.of(context).accentColor)),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(
                left: 72.0,
                right: 16.0,
              ),
              title: Text('Dark mode'),
              subtitle: Text('This shouldn\'t be an option'),
              trailing: Switch(
                value: Provider.of<SettingsProvider>(context).darkMode,
                onChanged: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? (value) {
                        Provider.of<SettingsProvider>(context, listen: false)
                            .changeDarkMode(value);
                      }
                    : null,
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
              title: Text('Demo mode'),
              trailing: Switch(
                value: true,
                onChanged: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
