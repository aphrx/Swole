import 'listpage.dart';
import 'package:flutter/material.dart';
import 'package:swole/auth.dart';

class HomeApp extends StatelessWidget {
  HomeApp({
    this.auth,
  });

  final AuthImplementation auth;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ListPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
          child: new Text(widget.title, textAlign: TextAlign.center)
        ),
      ),
      body: new Container(),
    );
  }
}
