import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: camel_case_types
class messageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String name;
  final String email;
  final DateTime time;
  final Key key;

  const messageBubble(this.message, this.name, this.email, this.isMe,
      {required this.key, required this.time});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
              child: !isMe ? Text(name, style: TextStyle(fontSize: 8)) : null),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                child: !isMe ? null : timeView(time),
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: size.width * .65,
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                margin: EdgeInsets.only(
                  left: isMe ? 3 : 0,
                  right: isMe ? 0 : 3,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                    topRight: isMe ? Radius.circular(0) : Radius.circular(10),
                  ),
                  color: isMe ? Color(0xFFD1D1D1) : Colors.indigo[300],
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: isMe ? Colors.black : Colors.white,
                  ),
                ),
              ),
              Container(
                child: isMe ? null : timeView(time),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget timeView(time) {
  return Text(DateFormat.yMMMd().add_jm().format(time),
      style: TextStyle(fontSize: 8));
}
