import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/features/media/domain/media_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MediaRepo {
  final FirebaseStorage _storage;
  final FirebaseFirestore _firestore;

  MediaRepo({FirebaseStorage? storage, FirebaseFirestore? firestore})
    : _storage = storage ?? FirebaseStorage.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _mediaCollection => _firestore.collection("media");

  // Upload media to Firebase Storage
  Future<void> uploadMedia({
    required File file,
    required String title,
    required String updatedBy,
  }) async {
    //1 - GENERATE NAME FOR THE FILE WHICH UPLOADED
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}";
    final storagePath = "media/$fileName";
    final ref = _storage.ref().child(storagePath);

    //2 - Upload file with Content Type
    final uploadTask = ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    final snapShot = await uploadTask;

    //3 - Obtain Download URL

    final downloadUrl = await snapShot.ref.getDownloadURL();

    await _mediaCollection.add({
      "title": title,
      "mediaUrl": downloadUrl,
      "updatedBy": updatedBy,
      "createdAt": FieldValue.serverTimestamp(),
      "storagePath": storagePath,
    });
  }

  Stream<List<MediaModel>> getMediaStream() {
    return _mediaCollection
        .orderBy("uploadedAt", descending: true)
        .snapshots()
        .map(
          (snapShot) => snapShot.docs
              .map((doc) => MediaModel.fromFireStore(doc))
              .toList(),
        );
  }
  Future<void> deleteMedia({
    required String id,
    required String storagePath,
  })
  async
  {
    if(storagePath.isNotEmpty)
    {
      try{
        await _storage.ref().child(storagePath).delete();
      }
      catch(_)
      {
      }
    }
    await _mediaCollection.doc(id).delete();
  }
}
