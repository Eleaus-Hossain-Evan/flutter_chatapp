import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/screens/LoginScreen.dart';
import 'package:flutter_chatapp/model/Model.dart';

class Services {
  auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void setStatus(String status) async {
    await _firestore.collection("users").doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  ModelUser? firebaseUser(auth.User? user) {
    if (user == null) {
      return null;
    }
    return ModelUser(
        user.uid, user.displayName.toString(), user.email.toString());
  }

  Future<User?> createAccount(
      String name, String email, String password) async {
    try {
      User? user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user != null) {
        user.updateDisplayName(name);

        await _firestore.collection("users").doc(_auth.currentUser!.uid).set({
          "displayName": name,
          "email": user.email,
          "status": "Unavailable",
          "uid": _auth.currentUser!.uid,
        }).then((value) {
          _auth.currentUser!.updateDisplayName(name);
          print("-------Firestore : ${user.uid}---------");
        });
        print([user]);
      }
      if (user != null) {
        print("Account Created Successfully...(user - ${user.uid})");
        return user;
      } else {
        print("Account creation failed");
        return user;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      User? user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        _firestore
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .get()
            .then((value) {
          if (value.exists) {
            if (value.data()!["email"].toString() == email) {
              print("Email matched with firebase");
              _auth.currentUser!
                  .updateDisplayName(value.data()!["displayName"]);
              _auth.currentUser!.updateEmail(value.data()!["email"]);
            }
          }
        });
        print("Login Successful");
        return user;
      } else {
        print("Login failed");
        return user;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signout(BuildContext context) async {
    try {
      setStatus("offline");
      await _auth.signOut().then((value) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => LoginScreen()));
      }).whenComplete(() => null);
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
