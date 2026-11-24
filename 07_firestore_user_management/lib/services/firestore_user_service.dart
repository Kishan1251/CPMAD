import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUserService {
  final CollectionReference _usersCollection = FirebaseFirestore.instance
      .collection('users');

  Stream<QuerySnapshot> getUsersStream() {
    return _usersCollection.snapshots();
  }

  Future<void> addUser(String name, String city, int salary) async {
    await _usersCollection.add({
      'name': name,
      'city': city,
      'salary': salary,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateUser(
    String docId,
    String name,
    String city,
    int salary,
  ) async {
    await _usersCollection.doc(docId).update({
      'name': name,
      'city': city,
      'salary': salary,
    });
  }

  Future<void> deleteUser(String docId) async {
    await _usersCollection.doc(docId).delete();
  }
}
