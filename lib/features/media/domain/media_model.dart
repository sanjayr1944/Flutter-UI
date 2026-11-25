import 'package:cloud_firestore/cloud_firestore.dart';

class MediaModel {
  final String id;
  final String title;
  final String mediaUrl;
  final String updatedBy;
  final DateTime createdAt;
  final String storagePath;

  MediaModel({
    required this.id,
    required this.title,
    required this.mediaUrl,
    required this.updatedBy,
    required this.createdAt,
    required this.storagePath,
  });
  factory MediaModel.fromFireStore(DocumentSnapshot doc)
  {
    final data = doc.data() as Map<String,dynamic>? ?? {};
    return MediaModel(
        id: doc.id,
        title: data['title'] as String? ?? "Untitled",
        mediaUrl: data['mediaUrl'] as String? ??"",
        updatedBy: data["updatedBy"] as String? ?? "Admin",
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        storagePath: data["storagePath"] as String? ?? "");
  }


  Map<String,dynamic>toMap()
  {
    return
      {
        "title":title,
        "mediaUrl":mediaUrl,
        "updatedBy":updatedBy,
        "createdAt":FieldValue.serverTimestamp(),
        "storagePath":storagePath,
      };
  }

}
