import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:vpost_2/models/post.dart';
import 'package:vpost_2/resources/storage_methods.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String title,
    String uid,
    String displayName,
    String profImage,
  ) async {
    String res = 'some error occurred';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);
      String postId = const Uuid().v1();
      Post post = Post(
          title: title,
          description: description,
          displayName: displayName,
          datePublished: DateTime.now(),
          postId: postId,
          profImage: profImage,
          postUrl: photoUrl,
          uid: uid,
          bookmarks: []
          );
    
    _firestore.collection('posts').doc(postId).set(post.toJson());
    res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
