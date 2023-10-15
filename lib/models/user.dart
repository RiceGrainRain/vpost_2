import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String displayName;
  final String userAge;
  final String photoUrl;
  final String uid;
  final String location;

  const User({
    required this.email,
    required this.displayName,
    required this.userAge,
    required this.photoUrl,
    required this.uid,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        "uid": uid,
        "email": email,
        'userAge': userAge,
        'photoUrl': photoUrl,
        'location': location,
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
    );
  }
}
