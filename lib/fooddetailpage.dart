import 'auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodDetailPage extends StatefulWidget {
  final DocumentSnapshot food;
  FoodDetailPage({this.food});

  @override
  _FoodDetailPageState createState() => _FoodDetailPageState(); 
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  // Variables for tracking total calories
  int loaded = 0;
  int total = 0;
  
  @override
  Widget build(BuildContext context) {
    // Keep track of if total variable was reset
    if(loaded == 0){
      total = widget.food.data["total"];
      loaded = 1;
    }
    return new Scaffold(
      backgroundColor: Color.fromRGBO(20, 20, 20, 1),
      appBar: new AppBar(
        title: new Text(widget.food.data["date"]),
        actions: <Widget>[
          // Delete Button
          IconButton(
            icon: Icon(Icons.delete),
            onPressed:() {
              var firestore = Firestore.instance;
              firestore.collection("user_data").document(authService.currUser().uid).collection("food").document(widget.food.documentID).delete();
              Navigator.pop(context);
            }
          ),
          // Add Button
          IconButton(
            icon: Icon(Icons.add),
            onPressed:() {
              addFoodItemDialog();
            } 
          )
        ]
      ),
      body: Center(
        child: Padding(padding: EdgeInsets.all(15),
          child: FutureBuilder(
            future: getFoodEntry(),
            builder: (_, snapshot2){
              if(snapshot2.connectionState == ConnectionState.waiting){
                //Initial loading screen
                return Center(child: Text("Loading..."));
              } 
              else {
                // List of food items and respective calories
                return ListView.builder(
                  itemCount: snapshot2.data.length,
                  itemBuilder: (_, index) {
                    return Column( 
                      children: <Widget>[
                        // Food item card
                        
                          ListTile(
                            title: Text(snapshot2.data[index].data["name"], style: TextStyle(color: Colors.white)),
                            subtitle: Text(snapshot2.data[index].data["calories"] + " calories", style: TextStyle(color: Colors.white)),
                          )
                        
                      ]
                    );
                  }
                );
              }
            }
          )
        )
      )
    );
  }

  // Get food items from DB
  getFoodEntry() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("user_data").document(authService.currUser().uid).collection("food").document(widget.food.data["name"]).collection("data").getDocuments();
    return qn.documents;
  }

  // Add food item to DB
  addFoodItem(String text, String text2){
    print("Request to add: " + text);
    var firestore = Firestore.instance;
    total = total + int.parse(text2);
    firestore.collection("user_data").document(authService.currUser().uid).collection("food").document(widget.food.data["name"]).collection("data").document(text).setData({"name": text, "calories": text2});
    firestore.collection("user_data").document(authService.currUser().uid).collection("food").document(widget.food.data["name"]).setData({"date": widget.food.data["date"], "name": widget.food.data["name"], "total": total});
  }

  // Dialog to add food item
  addFoodItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final myController = TextEditingController();
        final myController2 = TextEditingController();
        return AlertDialog(
          content: Form(
            key: null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Name Field
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(decoration: InputDecoration(hintText: "Name"), controller: myController,),
                ),
                // Calories Field
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(decoration: InputDecoration(hintText: "Calories"),controller: myController2,),
                ),
                // Submit & Add to database
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text("Submit"),
                    onPressed: () {
                      addFoodItem(myController.text, myController2.text);
                      Navigator.pop(context);
                    }
                  )
                )
              ]
            )
          )
        );
      }
    );
  }
}
   