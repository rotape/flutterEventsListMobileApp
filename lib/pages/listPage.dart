import 'addEventsPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/eventService.dart';
import 'signInPage.dart';
import '../model/authentication.dart';

class ListPage extends StatefulWidget {
  ListPage({this.userId, this.auth, this.logoutCallback});
  final BaseAuth auth;
  final String userId;
  final VoidCallback logoutCallback;
  @override
  _ListPageState createState() {
    return _ListPageState();
  }
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                widget.auth.signOut();
                Navigator.pop(context);
              },
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddEventsPage())),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('events').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

// Here we build the list
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }
// Each item of the list
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.title),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          leading: GestureDetector(
            child: Icon(Icons.edit),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => AddEventsPage(data: data),
              ));
            },
          ),
          title: Text('${record.title} ${record.date}' ),
          subtitle: Text(record.description),
          trailing: GestureDetector(
            child:Icon(Icons.delete),
            onTap: () {
              FirebaseService().deleteEvent(record.reference);
            }
          ),
        ),
      ),
    );
  }
}
