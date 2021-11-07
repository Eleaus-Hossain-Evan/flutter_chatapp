import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/Widgets/message_bubble.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chats")
          .orderBy("time", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var chatDoc = snapshot.data!.docs;

          return ListView.builder(
            reverse: true,
            itemCount: chatDoc.length,
            itemBuilder: (context, index) => messageBubble(
              chatDoc[index]['text'],
              chatDoc[index]['displayName'],
              chatDoc[index]['email'],
              chatDoc[index]['uid'] == currentUser,
              key: ValueKey(chatDoc[index].id),
              time: chatDoc[index]['time'].toDate(),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
