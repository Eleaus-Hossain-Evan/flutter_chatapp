import 'package:flutter/material.dart';
import 'package:flutter_chatapp/Methods.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: TextButton(
          child: Text("Logout"),
          onPressed: () => signout(context),
        ),
      ),
    );
  }
}
