// this file will check if the user minimized the app and needs to re sign in or not
// if the user signs out then prompt user with sign in page else promp to homepage

import 'package:flutter/material.dart';
import 'package:swole/homepage.dart';
import 'package:swole/main.dart';
import 'package:swole/auth.dart';

class MappingPage extends StatefulWidget {
  final AuthImplementation auth;

  MappingPage({
    this.auth,
  });

  State<StatefulWidget> createState() {
    return _MappingPageState();
  }
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _MappingPageState extends State<MappingPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  AuthImplementation auth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try{
      auth.getCurrentUser().then((userId){
          setState(() {
            authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
          });
      });
    }catch (e) {}
  
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new HomeScreen();

      case AuthStatus.signedIn:
        return new HomeApp(auth: widget.auth,);
    }
    return null;
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

 
}
