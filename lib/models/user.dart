class User {
  final String email;
  final String displayName;
  final String userAge;
  final String photoUrl;
  final String uid;


  const User({
    required this.email,
    required this.displayName,
    required this.userAge,
    required this.photoUrl,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
         'displayName': displayName,
          "uid": uid,
          "email": email,
          'userAge': userAge,
          'photoUrl': photoUrl,
  };
}