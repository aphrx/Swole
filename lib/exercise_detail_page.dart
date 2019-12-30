import 'auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseDetailPage extends StatefulWidget {
  final DocumentSnapshot exercise;
  ExerciseDetailPage({this.exercise});
  
  @override
  _ExerciseDetailPage createState() => _ExerciseDetailPage(); 
}
class _ExerciseDetailPage extends State<ExerciseDetailPage> {

  // View Detailed Exercise Page
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(20, 20, 20, 1),
      appBar: new AppBar(
        title: new Text(widget.exercise.data["title"]),
        actions: <Widget>[
          // Delete Button
          IconButton(
            icon: Icon(Icons.delete),
            onPressed:() {
              var firestore = Firestore.instance;
              firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").document(widget.exercise.data["workout"]).collection("data").document(widget.exercise.data["title"]).delete();
              Navigator.pop(context);
            }
          )
        ]
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: FutureBuilder(
            future: getExerciseInfo(),
            builder: (_, snapshot2){
              // Initial Loading Screen
              if(snapshot2.connectionState == ConnectionState.waiting){
                return Center(child: Text("Loading..."));
              } 
              else {
                return ListView.builder(
                  itemCount: snapshot2.data.length,
                  itemBuilder: (_, index) {
                    // List reps of each workout
                    return InkWell(
                      child:
                      ListTile(title: Text(snapshot2.data[index].data["weight"] + " lbs x " + snapshot2.data[index].data["reps"], style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white),),), onLongPress: () => deleteDialog(snapshot2.data[index].data["id"]),
                    );
                  }
                );
              }
            }
          )
        )   
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addRepDialog();
        },
        label: Text('Add Rep'),
        icon: Icon(Icons.plus_one),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Get Exercise Info from DB
  getExerciseInfo() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").document(widget.exercise.data["workout"]).collection("data").document(widget.exercise.data["title"]).collection("sets").getDocuments();
    return qn.documents;
  }

  // Add Exercise Rep to DB
  addRep(weight, reps) async {
    var firestore = Firestore.instance;
    String identifier = DateTime.now().toString();
    firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").document(widget.exercise.data["workout"]).collection("data").document(widget.exercise.data["title"]).collection("sets").document(identifier).setData({"reps": reps, "weight": weight, "id": identifier});
  }

  // Delete an exercise
  deleteDialog(id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Confirm Delete Prompt
        return AlertDialog(
          content: Form(
            key: null,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: FlatButton(
                child: Text("Confirm Delete"),
                onPressed: () {
                  delete(id);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      }
    );
  }

  // Delete a specific ID number
  delete(id){
    var firestore = Firestore.instance;
    firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").document(widget.exercise.data["workout"]).collection("data").document(widget.exercise.data["title"]).collection("sets").document(id).delete();
    Navigator.pop(context);
  }

  // Dialog to add reps
  addRepDialog() {
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
                // Weight Field
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(decoration: InputDecoration(hintText: "Weight"),controller: myController,),
                ),
                // Reps Field
                Padding(  
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(decoration: InputDecoration(hintText: "Reps"),controller: myController2,),
                ),
                // Submit & Add to DB
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    child: Text("Submit"),
                    onPressed: () {
                      addRep(myController.text, myController2.text);
                      Navigator.pop(context);
                    }
                  )
                )
              ]
            )
          ),
        );
      }
    );
  }
}
   