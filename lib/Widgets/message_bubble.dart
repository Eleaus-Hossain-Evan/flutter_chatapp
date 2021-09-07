import 'package:flutter/material.dart';

// ignore: camel_case_types
class messageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String name;
  final String email;
  final Key key;

  const messageBubble(this.message, this.name, this.email, this.isMe,
      {required this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isMe ? Colors.blueGrey : Colors.deepPurpleAccent,
          ),
          child: Text(message),
        )
      ],
    );
  }
}
