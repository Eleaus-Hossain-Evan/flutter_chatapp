import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatRoom extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _messageController = TextEditingController();
  final Map<String, dynamic>? userMap;
  final String chatRoomId;

  late final File? imageFile;

  ChatRoom({
    Key? key,
    required this.chatRoomId,
    required this.userMap,
  }) : super(key: key);

  void onSendMessage() async {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.displayName,
        "message": _messageController.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };
      _messageController.clear();

      await _firestore
          .collection("chatroom")
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter some text");
    }
  }

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();

    bool status = true;

    await _firestore
        .collection("chatroom")
        .doc(chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": _auth.currentUser!.displayName,
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
        FirebaseStorage.instance.ref().child('image').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection("chatroom")
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();
      status = false;
    });

    if (status) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection("chatroom")
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream:
              _firestore.collection("users").doc(userMap!['uid']).snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(snapshot.data!['displayName']),
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          snapshot.data!['status'],
                          style: TextStyle(fontSize: 12),
                        ),
                        Icon(
                          Icons.adjust_rounded,
                          color: snapshot.data!['status'] == "online"
                              ? Colors.green
                              : Colors.grey,
                          size: 16,
                        ),
                      ],
                    )),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(chatRoomId)
                    .collection("chats")
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          return messages(context, size, map);
                        });
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex: 0,
            child: Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  children: [
                    Container(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          suffix: IconButton(
                            onPressed: () => getImage(),
                            icon: Icon(Icons.wallpaper_rounded),
                          ),
                          labelText: "Send Message",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    IconButton(onPressed: onSendMessage, icon: Icon(Icons.send))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget messages(BuildContext context, Size size, Map<String, dynamic> map) {
    return Container(
      width: size.width,
      alignment: map['sendby'] == _auth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: map['sendby'] == _auth.currentUser!.displayName
                  ? Radius.circular(15)
                  : Radius.circular(0),
              bottomRight: map['sendby'] == _auth.currentUser!.displayName
                  ? Radius.circular(0)
                  : Radius.circular(15),
            ),
            color: map['sendby'] == _auth.currentUser!.displayName
                ? Colors.lightBlueAccent
                : Colors.grey),
        child: map['type'] != "img"
            ? Text(
                map['message'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              )
            : Container(
                height: size.height / 2.5,
                width: size.width / 2,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ShowImage(imageUrl: map['message'])));
                  },
                  child: Container(
                    alignment: map['message'] != "" ? null : Alignment.center,
                    child: map['message'] != ""
                        ? Image.network(
                            map['message'],
                            fit: BoxFit.cover,
                          )
                        : CircularProgressIndicator(
                            color:
                                map['sendby'] == _auth.currentUser!.displayName
                                    ? Colors.grey
                                    : Colors.blue,
                          ),
                  ),
                ),
              ),
      ),
    );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;
  const ShowImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: Color(0xFF212121),
        child: Image.network(imageUrl),
      ),
    );
  }
}
