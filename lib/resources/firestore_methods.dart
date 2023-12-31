import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import 'package:vpost_2/resources/storage_methods.dart';
import '../models/post.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
      String title,
      String description,
      Uint8List file,
      String uid,
      String displayName,
      String profImage,
      String location,
      int hours,
      String tags,
      int tagColor,
      double postLat,
      double postLong,
      ) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      List<Location> locations = await locationFromAddress(location);
      Location locationConvert = locations[0];
      double latitude = locationConvert.latitude;
      double longitude = locationConvert.longitude;
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
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
        hours: hours,
        tags: tags,
        tagColor: tagColor,
        checks: [],
        checkCount: 0,
        postLat: latitude,
        postLong: longitude,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> checkPost(String postId, String uid, List checks) async {
    String res = "Some error occurred";
    try {
      if (checks.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'checks': FieldValue.arrayRemove([uid]),
          'checkCount': (checks.length - 1),
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'checks': FieldValue.arrayUnion([uid]),
          'checkCount': (checks.length + 1),
        });
      }
      res = 'success';
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
          'bookmarkCount': (bookmarks.length - 1),
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'bookmarks': FieldValue.arrayUnion([uid]),
          'bookmarkCount': (bookmarks.length + 1),
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

  Future<String> updateLocation(String uid, String newLocation) async {
    String res = "Some error occurred";
    try {
      List<Location> locations = await locationFromAddress(newLocation);
      Location locationConvert = locations[0];
      double latitude = locationConvert.latitude;
      double longitude = locationConvert.longitude;

      await _firestore.collection('users').doc(uid).update({
        'location': newLocation,
        'latitude': latitude,
        'longitude': longitude,
      });

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
