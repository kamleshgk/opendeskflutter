import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(new App());
const TITLE = "Open Desk";

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: TITLE,
      theme: new ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: new Home(title: TITLE),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {

  Widget _buildRow(int index, DocumentSnapshot doc) {
    return ListTile(
      title: Row(children: <Widget>[
        Expanded(
          child: Text((doc['number'].toString() + "-->" + doc['title']), 
          style: Theme.of(context).textTheme.headline),
        ),
        Divider(),
      ]),
    );
  }

  // Widget _buildIssuesList() {
  //   return ListView.builder(
  //       padding: const EdgeInsets.all(16.0),
  //       itemBuilder: (context, i) {
  //         if (i.isOdd) {
  //           return Divider();
  //         }
  //         final index = i ~/ 2;
  //         return _buildRow(index);
  //       });
  // }

  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      // body: _buildIssuesList(),
      body:StreamBuilder(
        stream: Firestore.instance.collection("issues").snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading...");
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemExtent: 80.0,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>_buildRow(index, snapshot.data.documents[index]),
          );
      },)
    );
  }
}
