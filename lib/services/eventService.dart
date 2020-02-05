import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/event.dart';

//In this class methods we implement the CRUD actions for the app
class FirebaseService {
  final CollectionReference eventsCollection =
      Firestore.instance.collection('events');
  static final FirebaseService _instance =  FirebaseService.internal();

  factory FirebaseService() => _instance;

  FirebaseService.internal();

  Future<Event> createEvent(String title, String date, String description ) {
    final TransactionHandler createTransaction = (Transaction trans) async {
      final DocumentSnapshot ds = await trans.get(eventsCollection.document());
      final Event event = Event(title, date, description);
      final Map<String, dynamic> data = event.toMap();

      await trans.set(ds.reference, data);

      return data;
    };

      return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return Event.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
}


  Future <dynamic> updateEvent(DocumentReference id, String title, String date, String description) async {
      final TransactionHandler updateTransaction = (Transaction trans) async {
      await trans.update(id, {'title':  title, 'date':date, 'description':description  });
    };
    return Firestore.instance
        .runTransaction(updateTransaction)
        .then((mapData) {
      return Event.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Future<dynamic> deleteEvent(DocumentReference id) async {
    final TransactionHandler deleteTransaction = (Transaction trans) async {
      await trans.delete(id);
       return {'deleted': true};
    };
    return Firestore.instance
        .runTransaction(deleteTransaction)
        .then((mapData) {
      return Event.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }
}  

class Record {
  final String title;
  final String date;
  final String description;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['date'] != null),
        assert(map['description'] != null),
        title = map['title'],
        date = map['date'],
        description = map['description'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
