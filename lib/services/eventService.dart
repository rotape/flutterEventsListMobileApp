import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/event.dart';

class FirebaseService {
  final CollectionReference eventsCollection =
      Firestore.instance.collection('events');
  static final FirebaseService _instance = new FirebaseService.internal();

  factory FirebaseService() => _instance;

  FirebaseService.internal();

  Future<Event> createEvent(String title, String description, String date) {
    final TransactionHandler createTransaction = (Transaction trans) async {
      final DocumentSnapshot ds = await trans.get(eventsCollection.document());
      final Event event = new Event(title, date, description);
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


  Future <dynamic> updateEvent(DocumentReference id, String title, String description, String date) async {
      // id.toString();
      // await Firestore.instance.collection('events').document('$id').updateData({'title':  title, 'description':description, 'date':date });
      final TransactionHandler updateTransaction = (Transaction trans) async {
      await trans.update(id, {'title':  title, 'description':description, 'date':date });
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

  @override
  String toString() { "Record<$title:$date>"; print('$reference'); }
}
