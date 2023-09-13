import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:vpost_2/resources/storage_methods.dart';
import '../models/post.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String title, String description, Uint8List file,
      String uid, String displayName, String profImage, String location) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        title: title,
        description: description,
        location: location,
        displayName: displayName,
        datePublished: DateTime.now(),
        postId: postId,
        profImage: profImage,
        postUrl: photoUrl,
        uid: uid,
        bookmarks: [], 
        bookmarkCount: 0,
        
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List bookmarks) async {
    String res = "Some error occurred";
    try {
      if (bookmarks.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'bookmarks': FieldValue.arrayRemove([uid]),
          'bookmarkCount': (bookmarks.length),
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'bookmarks': FieldValue.arrayUnion([uid]),
          'bookmarkCount': (bookmarks.length -1),
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
