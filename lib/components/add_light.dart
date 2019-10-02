import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mqtt_switch/state/lights.dart';

class AddLight extends StatefulWidget {
  AddLight({Key key, this.addLight}) : super(key: key);

  final Function addLight;

  _AddLightState createState() => _AddLightState();
}

class _AddLightState extends State<AddLight> {
  final TextEditingController aliasController = TextEditingController();
  final TextEditingController topicController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void addLight() {
    if (aliasController.text != null && topicController.text != null) {
      this.widget.addLight(aliasController.text, topicController.text);
    }
  }

  @override
  void dispose() {
    aliasController.dispose();
    topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Add light'),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Lights.of(context).addLight(aliasController.text, topicController.text);
                    Navigator.pop(context);
                  } else {
                    final snackbar = SnackBar(
                      content: Text('You have errors'),
                    );
                    Scaffold.of(context).showSnackBar(snackbar);
                  }
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(MdiIcons.qrcodeScan),
      ),
      backgroundColor: Theme.of(context).appBarTheme.color,
      body: Container(
        padding: EdgeInsets.only(
          top: 24.0,
          right: 18.0,
          bottom: 18.0,
          left: 18.0,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 18.0),
                child: TextFormField(
                  controller: aliasController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'This field is not optional';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Alias',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 18.0),
                child: TextFormField(
                  controller: topicController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'This field is not optional';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Topic',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
