import 'package:swole/main.dart';
import 'package:swole/settings.dart';
import 'auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Constants.dart';
import 'package:intl/intl.dart';
import 'detailpage.dart';
import 'homepage.dart';
import 'fooddetailpage.dart';
import 'dart:math' as math;

math.Random random = new math.Random();
List<double> result = [0.0];
List<double> result2 = [0.0];

List<double> _generateRandomData() {
  return result;
}

List<double> _generateRandomData2() {
  return result2;
}

double getAverageResult(){
  double avg = 0;
  for(int i=1; i < result.length; i++)
  {
    avg += result[i];
  }
  avg = avg / (result.length - 1);
  return avg.roundToDouble();
}

double getAverageResult2(){
  double avg = 0;
  for(int i=1; i < result2.length; i++)
  {
    avg += result2[i];
  }
  avg = avg / (result2.length - 1);
  return avg.roundToDouble();
}


var data;
var data2;

DateTime today = DateTime.now();             
DateTime _firstDayOfTheweek = today.subtract(new Duration(days: today.weekday));

class ListPage extends StatefulWidget {
 @override
 _ListPageState createState() => _ListPageState();
}

class _ListPageState  extends State<ListPage> with SingleTickerProviderStateMixin{

  
  TabController _tabController;

  Future getWorkouts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").getDocuments();
    return qn.documents;
  }

  void addWorkouts(String name) async {
    print("Request to add: " + name);
    var fname = name + " " + DateTime.now().toString();
    var firestore = Firestore.instance;
    firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").document(fname).setData({"title": name, "name": fname, "date": DateFormat.yMMMMd().format(DateTime.now()), "total": 0});
  }

 void addFoodEntry(String foodName) async {
   print("Request to add: " + foodName);
   var name = foodName + " " + DateTime.now().toString();
   var firestore = Firestore.instance;
   firestore.collection("user_data").document(authService.currUser().uid).collection("food").document(name).setData({"name": name, "date": foodName, "total": 0});
 }


 Future getFood() async {
   var firestore = Firestore.instance;
   QuerySnapshot qn = await firestore.collection("user_data").document(authService.currUser().uid).collection("food").getDocuments();
   return qn.documents;
 }

 navigateToDetail(DocumentSnapshot workout){
   Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(workout: workout,)));
 }

 navigateToFoodDetail(DocumentSnapshot food){
   Navigator.push(context, MaterialPageRoute(builder: (context)=>FoodDetailPage(food: food,)));
 }

 void choice(String choice){

  if (choice == Constants.workout){
     
     showDialog(
   context: context,
   builder: (BuildContext context) {
     final myController = TextEditingController();
           return AlertDialog(
             content: Form(
               key: null,
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: <Widget>[
                   Padding(
                     padding: EdgeInsets.all(8.0),
                     child: TextFormField(controller: myController,),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: FlatButton(
                 child: Text("Submit"),
                 onPressed: () {
                   addWorkouts(myController.text);
                   Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => HomeApp()
                    ), 
                  ModalRoute.withName("/Home")
                  );
                 },
               ),
             )
           ],
         ),
       ),
     );
   });
   }

   else if (choice == Constants.food){
     addFoodEntry(DateFormat.yMMMMd().format(DateTime.now()));
     Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => HomeApp()
                    ), 
                  ModalRoute.withName("/Home")
                  );
   }
  
 }

 void initState(){
   _tabController = new TabController(length: 2, vsync: this);
 }

  void dispose(){
   _tabController.dispose();
 }


void logout(){
  print("Logging out");
  authService.signOut();
  Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => MyApp()
  ),
  ModalRoute.withName("/Home"));
}

 @override
 Widget build(BuildContext context) {
   data = _generateRandomData();
   data2 = _generateRandomData2();
   return DefaultTabController(
     length: 2,
     child: Scaffold(
      backgroundColor: Color.fromRGBO(20, 20, 20, 1),
     appBar: AppBar(
       elevation: 0,
       title: Text("Swole"),
       bottom: TabBar(
         unselectedLabelColor: Colors.white,
         labelColor: Colors.white,
         indicatorSize: TabBarIndicatorSize.label,
         indicator: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Color.fromRGBO(20 , 20, 20, 1),
         ),
         controller: _tabController,
         tabs: <Widget>[
           Tab(
             child: Align(
               alignment: Alignment.center,
               child: Text("Food"),
             ),
           ),
           Tab(
             child: Align(
               alignment: Alignment.center,
               child: Text("Workout"),
             ),
           ),
         ],
       ), 
     ),
     body: Center(child:new TabBarView(
       controller: _tabController,
       children: <Widget>[
         Container(

               child: FutureBuilder(
                 future: getFood(),
                 builder: (_, snapshot){
                 if(snapshot.connectionState == ConnectionState.waiting){
                   result = [0.0];
                   
                   return Center(child: Text("Please wait while we gather your data!", style: TextStyle(color: Colors.white),),
                   );
                 } else {
                   return Column(
                     children: <Widget>[
                       Expanded(
                         child: ListView.builder(
                           itemCount: snapshot.data.length,
                           itemBuilder: (_, index){
                             result.add(double.parse(snapshot.data[index].data["total"].toString()));
                             
                             
                             return
                               InkWell(
                                 child:Container(
                                 padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                 height: 70,
                                 child: ListTile(
                                  
                                  title: Text(snapshot.data[index].data["date"], style: TextStyle(color: Colors.white),),
                                  subtitle: Text(snapshot.data[index].data["total"].toString() + " calories", style: TextStyle(color: Colors.white)),
                                )              
                               ),
                               
                               onTap: () => navigateToFoodDetail(snapshot.data[index]),
                            
                            
                             );
                            
                           }
                     ),
                       ),
                       Center(child: 
                      FlatButton(
                        child: Text("Add Food Entry", style:TextStyle(color: Colors.white)),
                        onPressed: () => choice("Add Food Entry"),
                      ))
                     ],
                   );
                   
                     
                 }
               },
              
               ),
                  
             ),
         
         Container(
               child: FutureBuilder(
                 future: getWorkouts(),
                 builder: (_, snapshot){
                 if(snapshot.connectionState == ConnectionState.waiting){
                   result2 = [0.0];
                   return Center(child: Text("Please wait while we gather your data!", style: TextStyle(color: Colors.white),),
                   );
                 } else {
                   return 
                   Column(
                     children: <Widget>[
                     Expanded(
                       child:
                     ListView.builder(
                           itemCount: snapshot.data.length,
                           itemBuilder: (_, index){
                            result2.add(double.parse(snapshot.data[index].data["total"].toString()));

                             return
                               InkWell(

                               child: Container(
                                 padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                 height: 70,
                                 child: Center(
                                  child: ListTile(
                                    title: Text(snapshot.data[index].data["title"], style: TextStyle(color: Colors.white)),
                                    subtitle: Text(snapshot.data[index].data["date"], style: TextStyle(color: Colors.white)),
                                  )
                                 ),
                               ),
                               onTap: () => navigateToDetail(snapshot.data[index]),
                            
                            
                             );
                            
                           }
                     ),),
                     Center(child: 
                      FlatButton(
                        child: Text("Add Workout", style:TextStyle(color: Colors.white)),
                        onPressed: () => choice("Add Workout"),
                      ))
                     ]);
                 }
               },
               ),
             ),
             
       ],
       ),
     ),
     drawer: Drawer(
       child: 
       Container(
         color: Color.fromRGBO(20, 20, 20, 1),
         child: ListView(
         
         children: <Widget>[
           UserAccountsDrawerHeader(
             accountEmail: Text(authService.currUser().email.toString()),
           ),
           new ListTile(
             title: new Text("Settings", style: TextStyle(color: Colors.white),),
             trailing: new Icon(Icons.settings, color: Colors.white),
             onTap: () =>
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingApp())
            ),
           ),
           new Divider(),
           new ListTile(
             title: new Text("Logout", style: TextStyle(color: Colors.white)),
             onTap: () => logout(),
           )
         ],
       ),
     ),),
   ),
   );
  }
}

