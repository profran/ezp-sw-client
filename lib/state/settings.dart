import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  String brokerURL = '10.0.2.2';
  int brokerPort = 1883;
  String brokerUsername;
  String brokerPassword;
  bool darkMode = false;

  SettingsProvider() {
    // TODO: Might be better to save and get all the settings at once
    _getSavedBrokerURL();
    _getSavedBrokerPort();
    _getSavedBrokerUsername();
    _getSavedBrokerPassword();
    _getSavedDarkMode();
  }

  void changeBrokerURL(String brokerURL) {
    this.brokerURL = brokerURL != '' ? brokerURL : null;
    notifyListeners();

    this._saveBrokerURL(brokerURL);
  }

  void _saveBrokerURL(String brokerURL) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('brokerURL', brokerURL);
  }

  void _getSavedBrokerURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    this.changeBrokerURL(prefs.getString('brokerURL'));
  }

  void changeBrokerPort(int brokerPort) {
    this.brokerPort = brokerPort ?? 1883;
    notifyListeners();

    this._saveBrokerPort(brokerPort);
  }

  void _saveBrokerPort(int brokerPort) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('brokerPort', brokerPort);
  }

  void _getSavedBrokerPort() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    this.changeBrokerPort(prefs.getInt('brokerPort'));
  }

  void changeBrokerUsername(String brokerUsername) {
    brokerUsername = brokerUsername != '' ? brokerUsername : null;
    notifyListeners();

    this._saveBrokerUsername(brokerUsername);
  }

  void _saveBrokerUsername(String brokerUsername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('brokerUsername', brokerUsername);
  }

  void _getSavedBrokerUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    this.changeBrokerUsername(prefs.getString('brokerUsername'));
  }

  void changeBrokerPassword(String brokerPassword) {
    brokerPassword = brokerPassword != '' ? brokerPassword : null;
    notifyListeners();

    _saveBrokerPassword(brokerPassword);
  }

  void _saveBrokerPassword(String brokerPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('brokerPassword', brokerPassword);
  }

  void _getSavedBrokerPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    this.changeBrokerPassword(prefs.getString('brokerPassword'));
  }

  void changeDarkMode(bool darkMode) {
    darkMode = darkMode ?? false;
    notifyListeners();

    _saveDarkMode(darkMode);
  }

  void _saveDarkMode(bool darkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('darkMode', darkMode);
  }

  void _getSavedDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    this.changeDarkMode(prefs.getBool('darkMode'));
  }
}
