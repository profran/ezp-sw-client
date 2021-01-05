import 'package:barcode_scan/barcode_scan.dart';
import 'package:ezp_sw_client/models/module.dart';
import 'package:ezp_sw_client/state/mqtt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../state/modules.dart';

class AddModule extends StatefulWidget {
  AddModule({Key key, this.addModule}) : super(key: key);

  final Function addModule;

  _AddModuleState createState() => _AddModuleState();
}

class _AddModuleState extends State<AddModule> {
  final TextEditingController aliasController = TextEditingController();
  final TextEditingController topicController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String error;
  ModuleType moduleType = ModuleType.light;

  void addModule() {
    if (aliasController.text != null && topicController.text != null) {
      this.widget.addModule(aliasController.text, topicController.text);
    }
  }

  Future _barcodeScanning() async {
    try {
      String data = await BarcodeScanner.scan();
      setState(() => this.topicController.text = data);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() => this.error = 'No camera permission');
      } else {
        setState(() => this.error = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.error = 'Nothing captured.');
    } catch (e) {
      setState(() => this.error = 'Unknown error: $e');
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
        title: Text('Add module'),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Provider.of<ModulesProvider>(context, listen: false)
                        .addModule(
                      aliasController.text,
                      topicController.text,
                      moduleType,
                    );
                    Provider.of<MqttProvider>(context, listen: false)
                        .subscribe(topicController.text);
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
          _barcodeScanning();
        },
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
                child: DropdownButtonFormField<ModuleType>(
                  value: moduleType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Module type',
                  ),
                  onChanged: (ModuleType newValue) {
                    setState(() {
                      moduleType = newValue;
                    });
                  },
                  items: ModuleType.values.map((ModuleType moduleType) {
                    return DropdownMenuItem<ModuleType>(
                        value: moduleType, child: Text(moduleType.toString()));
                  }).toList(),
                ),
              ),
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
