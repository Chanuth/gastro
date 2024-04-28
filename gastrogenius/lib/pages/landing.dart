import 'package:flutter/material.dart';
import 'package:gastrogenius/pages/authentication/auth_page.dart';
import './authentication/login.dart';
import './authentication/signUp.dart';

class LandingPage extends StatelessWidget {
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
          Positioned.fill(
            child: Container(
              color: Colors.grey.withOpacity(0.5), // Adjust opacity as needed
            ),
          ),
          // Arc Container
          Positioned(
            left: -MediaQuery.of(context).size.width * 0.25,
            bottom: -MediaQuery.of(context).size.height * 0.75,
            child: Container(
              width: MediaQuery.of(context).size.width * 1.5,
              height: MediaQuery.of(context).size.height * 1.5,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255), // Red color
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Overlay Content
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/GG.png',
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 80),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                "Let's Cook",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                "something",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                "Delicious",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AuthPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Light red color
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Navigate to the signup page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Signup(onClickedLogin: () {  },)),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red), // Red border
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
