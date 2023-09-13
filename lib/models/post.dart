import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String title;
  final String description;
  final String location;
  final String displayName;
  final DateTime datePublished;
  final String postUrl;
  final String postId;
  final String profImage;
  final String uid;
  final bookmarks;

  const Post({
    required this.title,
    required this.description,
    required this.location,
    required this.displayName,
    required this.datePublished,
    required this.postId,
    required this.profImage,
    required this.postUrl,
    required this.uid,
    required this.bookmarks,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        "description": description,
        "location": location,
        'displayName': displayName,
        'datePublished': datePublished,
        "postId": postId,
        "profImage": profImage,
        'postUrl': postUrl,
        "uid": uid,
        "bookmarks": bookmarks,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      title: snapshot['title'],
      description: snapshot['description'],
      location: snapshot['location'],
      displayName: snapshot['displayName'],
      datePublished: snapshot['datePublished'],
      postId: snapshot['postId'],
      profImage: snapshot['profImage'],
      postUrl: snapshot['postUrl'],
      uid: snapshot['uid'],
      bookmarks: snapshot['bookmarks'],
    );
  }
}
