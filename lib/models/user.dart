import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String displayName;
  final String userAge;
  final String photoUrl;
  final String uid;
  final String location;
  final double userLat;
  final double userLong;

  const User({
    required this.email,
    required this.displayName,
    required this.userAge,
    required this.photoUrl,
    required this.uid,
    required this.location,
    required this.userLat,
    required this.userLong,
  });

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        "uid": uid,
        "email": email,
        'userAge': userAge,
        'photoUrl': photoUrl,
        'location': location,
        'userLat': userLat,
        'userLong': userLong, 
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      displayName: snapshot['displayName'],
      email: snapshot['email'],
      userAge: snapshot['userAge'],
      photoUrl: snapshot['photoUrl'],
      uid: snapshot['uid'],
      location: snapshot['location'],
      userLat: snapshot['userLat'],
      userLong: snapshot['userLong'],
    );
  }
}
