import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Mapping.dart';
import 'package:swole/homepage.dart';
import 'package:swole/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swole',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MappingPage(auth: AuthService(),),
    );
  }
}


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //checkLogin();
        return new Scaffold(
          backgroundColor: Color.fromRGBO(20, 20 , 20, 1),
          body: Container(
            padding: EdgeInsets.all(20),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                Text("Welcome.", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                SizedBox(height: 15,),
                Text("The app to help you meet your fitness goals!", style: TextStyle(color: Colors.white)),
                SizedBox(height: 200,),
                Container(
                  child:Center(
                    child: FloatingActionButton.extended(
                      backgroundColor: Colors.red,
                      onPressed: () => login(context),
                      label: Text("Login with Google"),
                    ),
                  ),
                ),  
              ],
            ),
            ),
        );
      }
    
    
      void login(BuildContext context) async {
    
        await authService.googleSignIn();    
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => HomeApp()), 
          ModalRoute.withName("/Home")
        );
      }
    
}

