import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/eventService.dart';

class AddEventsPage extends StatefulWidget {
  final DocumentSnapshot data;
  AddEventsPage({ this.data});
  @override 
  State<StatefulWidget> createState() {
    return AddEventsPageState(data: data);
  }
}

class AddEventsPageState extends State<AddEventsPage> {
  final FirebaseService firebaseService = new FirebaseService();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  final data;
  
  AddEventsPageState({this.data});
  @override
  Widget build(BuildContext context) {
    // Prevent to crash when data is null
  final element = data != null ? Record.fromSnapshot(data) : null; 
  // pass data to the form fields with default values
  _titleController.text = element != null? element.title : 'Title';
  _dateController.text = element != null? element.date : 'Date';
  _descriptionController.text = element != null? element.description : 'Description';
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Create Event'),
                    ),
                    body: SafeArea(
                      top: false,
                      bottom: false,
                      child: Form(
                        key: _formKey,
                        autovalidate: true,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          children: <Widget>[
                            TextFormField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.title),
                                hintText: 'Enter the name of the event',
                            )
                        ),
                        TextFormField(
                          controller: _dateController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.event),
                            hintText: 'Enter the date of the event',
                    )
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.text_fields),
                    hintText: 'Enter the description of the event',
                    )
                )
              ]
            ),
          )
        ),floatingActionButton: FloatingActionButton(
          // commuting the button action depending if it's updating an element or a new one needs to be created
      onPressed: () => element != null ?
       this.firebaseService.updateEvent(element.reference, _titleController.text, _dateController.text, _descriptionController.text) : 
       this.firebaseService.createEvent(_titleController.text, _dateController.text, _descriptionController.text)
      .then((_) {
        // go to the previous page
        Navigator.pop(context);
      }), 
      child: Icon(Icons.send),
    ),
    );
  }
}

