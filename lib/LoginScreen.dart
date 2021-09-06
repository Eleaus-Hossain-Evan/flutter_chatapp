import 'package:flutter/material.dart';
import 'package:flutter_chatapp/CreateAccount.dart';
import 'package:flutter_chatapp/Methods.dart';

import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();
bool isLoading = false;

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Container(
                        width: size.width / 1.3,
                        child: Text(
                          "Welcome",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        width: size.width / 1.3,
                        child: Text(
                          "Sign In To Continue!",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    SizedBox(
                      height: size.height / 10,
                    ),
                    Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: field(size, "Email", Icons.account_box, _email)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Container(
                          width: size.width,
                          alignment: Alignment.center,
                          child: field(size, "Password", Icons.lock, _password)),
                    ),
                    SizedBox(
                      height: size.height / 10,
                    ),
                    customButton(context, size, "Login"),
                    SizedBox(
                      height: size.height / 40,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(builder: (_) => CreateAccount()), (route) => false),
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

Widget customButton(BuildContext context, Size size, String label) {
  final _services = Services();
  return GestureDetector(
    onTap: () {
      if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
        isLoading = true;
        _services.login(_email.text, _password.text).then((user) {
          if (user != null) {
            isLoading = false;
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
            print("login Sucessfull");
          } else {
            print("Login Failed");
            isLoading = false;
          }
        });
      } else {
        print("Please enter all fields.");
      }
    },
    child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        height: size.height / 14,
        width: size.width / 1.2,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        )),
  );
}

Widget field(
    Size size, String hintText, IconData icon, TextEditingController cont) {
  return Container(
    height: size.height / 15,
    width: size.width / 1.3,
    child: TextField(
      controller: cont,
      decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    ),
  );
}
