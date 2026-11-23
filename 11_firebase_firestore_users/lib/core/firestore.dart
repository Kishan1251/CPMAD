import 'dart:async';

/// Firestore API contract matching cloud_firestore demonstrated in Udemy Sections 19 & 20

class DocumentSnapshot {
  final String id;
  final Map<String, dynamic> _data;

  DocumentSnapshot(this.id, this._data);

  Map<String, dynamic> data() => Map<String, dynamic>.from(_data);
  dynamic operator [](String key) => _data[key];
}

class QuerySnapshot {
  final List<DocumentSnapshot> docs;

  QuerySnapshot(this.docs);

  int get size => docs.length;
}

class DocumentReference {
  final String id;
  final CollectionReference _collection;

  DocumentReference(this.id, this._collection);

  Future<void> set(Map<String, dynamic> data) async {
    await _collection._setDoc(id, data);
  }

  Future<void> update(Map<String, dynamic> data) async {
    await _collection._updateDoc(id, data);
  }

  Future<void> delete() async {
    await _collection._deleteDoc(id);
  }

  Future<DocumentSnapshot> get() async {
    return _collection._getDoc(id);
  }
}

class CollectionReference {
  final String path;
  final Map<String, Map<String, dynamic>> _docs = {};
  final StreamController<QuerySnapshot> _streamController =
      StreamController<QuerySnapshot>.broadcast();
  int _autoDocCounter = 1000;

  CollectionReference(this.path);

  void _notify() {
    final docList = _docs.entries
        .map((e) => DocumentSnapshot(e.key, e.value))
        .toList();
    _streamController.add(QuerySnapshot(docList));
  }

  DocumentReference doc([String? id]) {
    final docId = id ?? 'doc_${_autoDocCounter++}';
    return DocumentReference(docId, this);
  }

  Future<DocumentReference> add(Map<String, dynamic> data) async {
    final docId = 'doc_${_autoDocCounter++}';
    _docs[docId] = Map<String, dynamic>.from(data);
    _notify();
    return DocumentReference(docId, this);
  }

  Future<void> _setDoc(String id, Map<String, dynamic> data) async {
    _docs[id] = Map<String, dynamic>.from(data);
    _notify();
  }

  Future<void> _updateDoc(String id, Map<String, dynamic> data) async {
    if (_docs.containsKey(id)) {
      _docs[id]!.addAll(data);
      _notify();
    }
  }

  Future<void> _deleteDoc(String id) async {
    _docs.remove(id);
    _notify();
  }

  DocumentSnapshot _getDoc(String id) {
    return DocumentSnapshot(id, _docs[id] ?? {});
  }

  Stream<QuerySnapshot> snapshots() {
    // Emit initial state microtask
    scheduleMicrotask(_notify);
    return _streamController.stream;
  }

  Future<QuerySnapshot> get() async {
    final docList = _docs.entries
        .map((e) => DocumentSnapshot(e.key, e.value))
        .toList();
    return QuerySnapshot(docList);
  }
}

class FirebaseFirestore {
  static final FirebaseFirestore _instance = FirebaseFirestore._internal();
  static FirebaseFirestore get instance => _instance;

  final Map<String, CollectionReference> _collections = {};

  FirebaseFirestore._internal();

  CollectionReference collection(String collectionPath) {
    return _collections.putIfAbsent(
      collectionPath,
      () => CollectionReference(collectionPath),
    );
  }
}

class FieldValue {
  static DateTime serverTimestamp() => DateTime.now();
}
