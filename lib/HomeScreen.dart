import 'package:flutter/material.dart';
import 'package:flutter_chatapp/Widgets/Message.dart';
import 'package:flutter_chatapp/Widgets/NewMessage.dart';
import 'Methods.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          TextButton(
              onPressed: () async {
                await Services().signout(context);
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                  width: 1,
                )),
                child: Text(
                  "LOGOUT",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              )),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Message(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}

class ShowAllMassages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(" All Messages"),
    );
  }
}
