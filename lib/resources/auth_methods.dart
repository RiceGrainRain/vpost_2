import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //signUpUser
  Future<String> signUpUser(
      {required String email,
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

        //store users
        _firestore.collection('users').doc(cred.user!.uid).set({
          'displayName': "$firstName $lastName",
          "uid": cred.user!.uid,
          "email": email,
          'userAge': userAge,
        });

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
