import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
        title: Text('Add light'),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    this
                        .widget
                        .addLight(aliasController.text, topicController.text);
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
        onPressed: () {
          final snackbar = SnackBar(
            content: Text('You have errors'),
          );
          Scaffold.of(context).showSnackBar(snackbar);
        },
        backgroundColor: Theme.of(context).primaryColorDark,
        child: Icon(MdiIcons.qrcodeScan),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
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
