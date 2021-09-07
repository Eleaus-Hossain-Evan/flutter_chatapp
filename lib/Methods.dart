import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/LoginScreen.dart';
import 'package:flutter_chatapp/Model.dart';

class Services {
  auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ModelUser? firebaseUser(auth.User? user) {
    if (user == null) {
      return null;
    }
    return ModelUser(
        user.uid, user.displayName.toString(), user.email.toString());
  }

  Future<ModelUser?> createAccount(
      String name, String email, String password) async {
    try {
      User? user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user != null) {
        await _firestore.collection("users").doc(_auth.currentUser!.uid).set({
          "displayName": name,
          "email": user.email,
          "status": "Unavailable",
          "uid": _auth.currentUser!.uid,
        }).then((value) => {print("-------Firestore : ${user.uid}---------")});
        print([user]);
      }
      if (user != null) {
        print("Account Created Successfully..");
        return firebaseUser(user);
      } else {
        print("Account creation failed");
        return firebaseUser(user);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ModelUser?> login(String email, String password) async {
    try {
      User? user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        print("Login Successful");
        return firebaseUser(user);
      } else {
        print("Login failed");
        return firebaseUser(user);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signout(BuildContext context) async {
    try {
      await _auth.signOut().then((value) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => LoginScreen()));
      });
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
