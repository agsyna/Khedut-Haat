import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:krish_biz/utils/common_utils.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential? userCredential;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim());
          return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        CUtils.toastMessage( 'No Internet Connection');

      } else if (e.code == "wrong-password") {
        CUtils.toastMessage( 'Please enter correct password');

      } else if (e.code == 'user-not-found') {
        CUtils.toastMessage('Email not found');

      } else if (e.code == 'too-many-requests') {
        CUtils.toastMessage( 'Too many attempts please try later');

      } else if (e.code == 'invalid-credential') {
        CUtils.toastMessage( 'Please enter correct password');

      } else if (e.code == 'unknown') {
        CUtils.toastMessage( 'Email Not Registered');

      } else if (e.code == 'invalid-email') {
        CUtils.toastMessage( 'Please enter correct email address');
        
      } else {
        CUtils.toastMessage('User Not Registered');
        print(e.code);
      }
      return false;
    }
}
}