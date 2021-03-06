import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/screens/LoginScreen.dart';
import 'package:flutter_chatapp/screens/searchScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              Object? user = snapshot.data;
              if (user == null) {
                return LoginScreen();
              } else {
                return Search();
              }
            }
            return Scaffold(
              body: Center(
                child: Text("Authenticating..."),
              ),
            );
          }),
    );
  }
}
