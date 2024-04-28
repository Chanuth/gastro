import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../auth.dart';
import 'package:flutter/gestures.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  final VoidCallback onClickedLogin;

  const Signup({Key? key, required this.onClickedLogin}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  String _password = '';
  String _confirmPassword = '';

  Future<void> createUserWithEmailAndPassword() async {
    try {
      if (_confirmPassword.isEmpty) {
        Fluttertoast.showToast(
            msg: "Password cannot be empty!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
      } else if (_confirmPassword != _password) {
        Fluttertoast.showToast(
            msg: "Passwords do not match!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
      } else {
        await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );
        Fluttertoast.showToast(
          msg: "User created Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 32.0,
        );
      }
    } on FirebaseAuthException {
      setState(() {
        Fluttertoast.showToast(
            msg: "E-mail/ Password is Incorrect",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(fit: StackFit.expand, children: [
      // Background Image
      Positioned.fill(
        child: Image.asset(
          'assets/start.jpg',
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        left: -MediaQuery.of(context).size.width * 0.3,
        bottom: -MediaQuery.of(context).size.height * 0.5,
        child: Container(
          width: MediaQuery.of(context).size.width * 1.6,
          height: MediaQuery.of(context).size.height * 1.5,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 243, 46, 32), // Red color
            shape: BoxShape.circle,
          ),
        ),
      ),
      Positioned(
          bottom: 28,
          left: 0,
          right: 0,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image.asset('assets/GG-loading.png', height: 200, width: 200),
                Container(
                  margin: const EdgeInsets.fromLTRB(8.0, 30.0, 0.0, 80.0),
                  child: const Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3.5,
                      color: Color.fromARGB(255, 255, 35, 35),
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(15, 0.0, 15.0, 0.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email', // Email text above the email text field
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextField(
                            controller: _controllerEmail,
                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              fillColor: Colors.white,
                            ),
                          ),
                        ])),
                Container(
                    margin: const EdgeInsets.fromLTRB(15, 30.0, 15.0, 0.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password', // Email text above the email text field
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextField(
                            controller: _controllerPassword,
                            obscureText: true,
                            obscuringCharacter: "*",
                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              fillColor: Colors.white,
                            ),
                            onChanged: (value) {
                              _password = value;
                            },
                          ),
                        ])),
                Container(
                    margin: const EdgeInsets.fromLTRB(15, 30.0, 15.0, 40.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confirm Password', // Email text above the email text field
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextField(
                            obscureText: true,
                            obscuringCharacter: "*",
                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Confirm Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              fillColor: Colors.white,
                            ),
                            onChanged: (value) {
                              _confirmPassword = value;
                            },
                          ),
                        ])),
                ElevatedButton(
                    onPressed: () {
                      createUserWithEmailAndPassword();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        fixedSize: const Size(360, 55)),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0,
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 35.0, 0, 0.0),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        color: Color(0xff000000),
                      ),
                      children: [
                        const TextSpan(
                          text: 'Already a member? ',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        TextSpan(
                          text: ' Login',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Login(
                                          onClickedSignUp: () {
                                            // Add your logic here for what should happen when the signup link is clicked
                                          },
                                        )));
                            }
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ))
    ]));
  }
}
