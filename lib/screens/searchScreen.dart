import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp/authenticate/Methods.dart';
import 'package:flutter_chatapp/screens/chatRoom.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    Services().setStatus("online");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //online
      Services().setStatus("online");
    } else {
      //offline
      Services().setStatus("offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });
    _firestore
        .collection("users")
        .where("displayName", isEqualTo: _searchController.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        actions: [
          IconButton(
              onPressed: () => Services().signout(context),
              icon: Icon(Icons.logout_outlined))
        ],
      ),
      body: isLoading
          ? Center(
              child: Container(child: CircularProgressIndicator()),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 30,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 15,
                    width: size.width / 1.2,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: "Search",
                        prefixIcon: Icon(Icons.search_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 40,
                ),
                ElevatedButton(
                  onPressed: () => onSearch(),
                  child: Text("Search"),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                userMap != null
                    ? ListTile(
                        leading: Icon(
                          Icons.account_circle,
                          size: 40,
                        ),
                        title: Text(
                          userMap!['displayName'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(userMap!['email']),
                        trailing: Icon(Icons.chat_outlined),
                        onTap: () {
                          print(
                              "-----Printing DisplayName----${_auth.currentUser!.displayName!}");
                          String roomId = chatRoomId(
                              _auth.currentUser!.displayName!,
                              userMap!['displayName']);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatRoom(
                                chatRoomId: roomId,
                                userMap: userMap,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(),
              ],
            ),
    );
  }
}
