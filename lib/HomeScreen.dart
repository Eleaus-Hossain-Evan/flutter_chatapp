import 'package:flutter/material.dart';
import 'package:flutter_chatapp/Methods.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _services = Services();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              TextButton(
                child: Text("Logout"),
                onPressed: () => _services.signout(context),
              ),
              Container(
                child: Expanded(
                  child: ShowAllMassages(),
                ),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: 50,
                    width: size.width ,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText:"Type message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(Icons.send), onPressed: () {
                              /*Send Message*/
                        },),
                        prefixIcon: IconButton(
                          icon: Icon(Icons.add_box_outlined),
                            onPressed: () {
                              /*Attached file*/
                            },
                        )
                      ),
                    ),
                  ),
                ),),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowAllMassages extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(" All Messages"),
    );
  }
  
}