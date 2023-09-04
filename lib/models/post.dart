import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String displayName;
  final datePublished;
  final String postUrl;
  final String postId;
  final String profImage;
  final String uid;
  final bookmarks;


  const Post({
    required this.description,
    required this.displayName,
    required this.datePublished,
    required this.postId,
    required this.profImage,
    required this.postUrl,
    required this.uid,
    required this.bookmarks,
  });

  Map<String, dynamic> toJson() => {
         'displayName': displayName,
          "uid": uid,
          "description": description,
          "postId": postId,
          "profImage": profImage,
          "bookmarks": bookmarks,
          'datePublished': datePublished,
          'postUrl': postUrl,
  };

  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      displayName: snapshot['displayName'], 
      description: snapshot['description'], 
      datePublished: snapshot['datePublished'], 
      postId: snapshot['postId'],
      postUrl: snapshot['postUrl'], 
      uid: snapshot['uid'], 
      profImage: snapshot['profImage'], 
      bookmarks: snapshot['bookmarks'],
      );

  }
}