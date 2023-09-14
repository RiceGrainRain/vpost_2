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
  final int bookmarkCount;
  final int hours;
  final tags;

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
    required this.bookmarkCount,
    required this.hours,
    required this.tags,
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
        "bookmarkCount": bookmarkCount,
        "hours": hours,
        "tags": tags,
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
      bookmarkCount: snapshot["bookmarkCount"],
      hours: snapshot['hours'],
      tags: snapshot['tags'],
    );
  }
}
