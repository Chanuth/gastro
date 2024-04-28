import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../auth.dart';
import 'package:flutter/gestures.dart';
import 'signUp.dart';
import '../home.dart';
import './auth_page.dart';

class Login extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const Login({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      Fluttertoast.showToast(
        msg: "Login Successfull",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
    } on FirebaseAuthException {
      setState(() {
        Fluttertoast.showToast(
          msg: "E-mail/ Password is Incorrect",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/start.jpg',
            fit: BoxFit.cover,
          ),
          // Red Arc Background
          Positioned(
            left: -MediaQuery.of(context).size.width * 0.25,
            bottom: -MediaQuery.of(context).size.height * 0.5,
            child: Container(
              width: MediaQuery.of(context).size.width * 1.5,
              height: MediaQuery.of(context).size.height * 1.5,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 243, 46, 32), // Red color
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Overlay Content
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Image.asset('assets/GG-loading.png', width: 200, height: 200),
                  Container(
                    margin: const EdgeInsets.fromLTRB(
                        8.0, 0.0, 0.0, 200.0), // Adjusted margin top to 20.0
                    child: const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3.5,
                        color: Color.fromARGB(255, 246, 4, 4),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 0.0, 15.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
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
                            prefixIcon: Icon(Icons.email), // Email icon
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            fillColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 40.0, 15.0, 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password', // Password text above the password text field
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
                            prefixIcon: Icon(Icons.lock), // Lock icon
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            fillColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      signInWithEmailAndPassword();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      fixedSize: const Size(380, 55),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 50.0, 0, 30.0),
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
                              text: 'Don`t have an account? ',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255))),
                          TextSpan(
                            text: 'Sign up',
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigate to the signup page when "Sign up" is tapped
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Signup(
                                          onClickedLogin: () {},
                                        )));
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
