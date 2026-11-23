import '../core/firestore.dart';

/// Firebase Firestore Service as implemented in Udemy Section 20
class FirestoreUserService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  FirestoreUserService() {
    // Seed initial users if collection is brand new
    _seedInitialUsers();
  }

  void _seedInitialUsers() async {
    final existing = await _usersCollection.get();
    if (existing.docs.isEmpty) {
      await addUser('Alice Johnson', 'New York', 85000);
      await addUser('Bob Smith', 'San Francisco', 92000);
      await addUser('Charlie Brown', 'Austin', 78000);
    }
  }

  /// Real-time stream of users for StreamBuilder
  Stream<QuerySnapshot> getUsersStream() {
    return _usersCollection.snapshots();
  }

  /// Create user document in Cloud Firestore
  Future<void> addUser(String name, String city, int salary) async {
    await _usersCollection.add({
      'name': name,
      'city': city,
      'salary': salary,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update existing user document
  Future<void> updateUser(String docId, String name, String city, int salary) async {
    await _usersCollection.doc(docId).update({
      'name': name,
      'city': city,
      'salary': salary,
    });
  }

  /// Delete user document
  Future<void> deleteUser(String docId) async {
    await _usersCollection.doc(docId).delete();
  }
}
