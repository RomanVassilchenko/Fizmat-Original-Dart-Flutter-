import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool townSwitcher = false;

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    //townSwitcher = getBoolValuesSF("townSwitcher");
    super.initState();
  }

  addBoolToSF(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  getBoolValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boolValue = prefs.getBool(key) ?? false;
    return boolValue;
  }

  toggleSwitch(bool value) async {
    if (townSwitcher == false) {
      setState(() {
        townSwitcher = true;
      });
      print('Switch is ON');
      addBoolToSF("townSwitcher", townSwitcher);
      // Put your code here which you want to execute on Switch ON event.

    } else {
      setState(() {
        townSwitcher = false;
      });
      print('Switch is OFF');
      addBoolToSF("townSwitcher", townSwitcher);
      // Put your code here which you want to execute on Switch OFF event.
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: Scaffold(
            appBar: AppBar(
                title: Text("Настройки"),
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context, false),
                )),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Transform.scale(
                      scale: 1.5,
                      child: Switch(
                        onChanged: toggleSwitch,
                        value: townSwitcher,
                        activeColor: Colors.blue,
                        activeTrackColor: Colors.green,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                      )),
                ]))));
  }
}
