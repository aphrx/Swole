import 'package:swole/exercise_detail_page.dart';
import 'auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPage extends StatefulWidget {
  final DocumentSnapshot workout;
  DetailPage({this.workout});

  @override
  _DetailPageState createState() => _DetailPageState();
}
 
class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin{
  int total = 0;
  int loaded = 0;

  TabController _tabController;


 void initState(){
   _tabController = new TabController(length: 2, vsync: this);
 }

  void dispose(){
   _tabController.dispose();
 }

  // View Detail Workout Page
  @override
  Widget build(BuildContext context) {
    if(loaded == 0){
      total = widget.workout.data["total"];
      loaded = 1;
    }
        return DefaultTabController(
          length: 2,
          child:
        new Scaffold(
          backgroundColor: Color.fromRGBO(20, 20, 20, 1),
          appBar: new AppBar(
          
            title: new Center(child: new Text(widget.workout.data["title"], textAlign: TextAlign.center)),
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
               child: Text("Exercises"),
             ),
           ),
           Tab(
             child: Align(
               alignment: Alignment.center,
               child: Text("History"),
             ),
           ),
         ],
       ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed:() {
            var firestore = Firestore.instance;
            firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").document(widget.workout.documentID).delete();
            Navigator.pop(context);
            },
          )
        ]
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          
          Column(
        children: <Widget>[
          Expanded(
            child:       Center(
        child: Padding(padding: EdgeInsets.all(15),
          child: FutureBuilder(
            future: getExercise(),
            builder: (_, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: Text("Loading..."),
                );
              }
              else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {

                    return InkWell(
                      child:Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      height: 60,
                      child: ListTile(
                      
                      title: Text(snapshot.data[index].data["title"], style: new TextStyle(fontSize: 16, color: Colors.white),)
                    )              
                    ),
                    
                    //onTap: () => navigateToExerciseDetail(snapshot.data[index]),  
                    );
                  }
                );
              }
            }
          )
        )   
      ),
          ),
          Center(child: 
                      FlatButton(
                        child: Text("Add Exercise", style:TextStyle(color: Colors.white)),
                        onPressed: () => addExerciseDialog(),
                      )),
                      Center(child: 
                      FlatButton(
                        child: Text("Start New Workout", style:TextStyle(color: Colors.white)),
                        onPressed: () => addExerciseDialog(),
                      ))
        ]), 
        Container(
          child: Text("Coming soon!", style: TextStyle(color: Colors.white),),
        )]
        )));

  }

  

  // Open Exercise Details Page
  navigateToExerciseDetail(DocumentSnapshot exercise){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ExerciseDetailPage(exercise: exercise,)));
  }

  // Get Exercises from DB
  getExercise() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").document(widget.workout.data["name"]).collection("data").getDocuments();
    return qn.documents;
  }

  // Add Exercise to DB
  addExercise(String text){
    print("Request to add: " + text);
    var firestore = Firestore.instance;
    //total = total + 1;
    firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").document(widget.workout.data["name"]).collection("data").document(text).setData({"title": text, "workout": widget.workout.data["name"]});
    //firestore.collection("user_data").document(authService.currUser().uid).collection("workouts").document(widget.workout.data["name"]).setData({"date": widget.workout.data["date"], "title": widget.workout.data["title"], "total":total});

  }

  // Prompt dialog to add an exercise
  addExerciseDialog() {
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
                      addExercise(myController.text);
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}