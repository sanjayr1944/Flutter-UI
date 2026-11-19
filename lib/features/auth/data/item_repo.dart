import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/item_model.dart';

class ItemRepository {
  final FirebaseFirestore _firestore;
  late final CollectionReference _itemsCollection;

  ItemRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    _itemsCollection = _firestore.collection('items');
  }

  // CREATE (Admin)
  Future<void> addItem({
    required String title,
    required String description,
    required String createdBy,
  }) async {
    await _itemsCollection.add({
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
    });
  }

  // READ (Stream for real-time updates for both Admin & User)
  Stream<List<ItemModel>> getItemsStream() {
    return _itemsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ItemModel.fromFirestore(doc)).toList();
    });
  }

  // UPDATE (Admin)
  Future<void> updateItem({
    required String id,
    required String title,
    required String description,
  }) async {
    await _itemsCollection.doc(id).update({
      'title': title,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // DELETE (Admin)
  Future<void> deleteItem(String id) async {
    await _itemsCollection.doc(id).delete();
  }
}