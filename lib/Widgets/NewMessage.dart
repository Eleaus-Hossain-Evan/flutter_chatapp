import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var messageController = TextEditingController();
  var msg = "";

  void sendMessage() async {
    final userinfo = FirebaseAuth.instance.currentUser!.uid;

    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(userinfo)
        .get();

    await FirebaseFirestore.instance.collection("chats").doc().set({
      "text": messageController.text.trim(),
      "uid": userData['uid'],
      "displayName": userData['displayName'],
      "email": userData['email'],
      "time": Timestamp.now(),
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 0, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (val) {
                setState(() {
                  msg = val;
                });
              },
              controller: messageController,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Type message...",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                prefixIcon: IconButton(
                  icon: Icon(Icons.add_box_outlined),
                  onPressed: () {
                    /*Attached file*/
                  },
                ),
              ),
            ),
          ),
          IconButton(
            focusColor: Colors.blue,
            hoverColor: Colors.blue,
            disabledColor: Colors.black12,
            onPressed: msg.isEmpty || messageController.text.isEmpty
                ? null
                : sendMessage,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
