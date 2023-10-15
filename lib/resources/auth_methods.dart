import 'dart:typed_data';
import 'package:vpost_2/models/user.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vpost_2/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //signUpUser
  Future<String> signUpUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String userAge,
    required String confirmPassword,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      //register
      if (email.isEmpty ||
          password.isEmpty ||
          firstName.isEmpty ||
          lastName.isEmpty ||
          userAge.isEmpty ||
          confirmPassword == password) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          displayName: "$firstName $lastName",
          uid: cred.user!.uid,
          email: email,
          userAge: userAge,
          photoUrl: photoUrl, 
          location: '',
        );

        //store users
        _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //loginUser
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //signOut
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
