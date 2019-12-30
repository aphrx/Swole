import 'package:flutter/material.dart';
import 'auth.dart';

class SettingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swole',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new SettingScreen(),
    );
  }
}

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(20, 20, 20, 1),
      appBar: new AppBar(
        title: new Center(child: new Text("Settings", textAlign: TextAlign.center)),
      ),
      body: Center(
        child: Padding(padding: EdgeInsets.all(15),
          child: Column(
            // Settings Items
            children: <Widget>[
              ListTile(title: Text("User Information", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)), 
              ListTile(title: Text(authService.currUser().email.toString(), style: TextStyle(color: Colors.white),)),
              new Divider(),
              ListTile(title: Text("Build", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)),
              ListTile(title: Text("P1230", style: TextStyle(color: Colors.white),))
            ]
          )
        )
      )
    );
  }
}



