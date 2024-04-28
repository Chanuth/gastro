import 'package:firebase_auth/firebase_auth.dart';
import 'package:gastrogenius/auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final User? user = Auth().currentUser;

  List<String> buttonNames = [
    'Profile',
    'Favorites',
    'Privacy',
    'Feedback',
    'Notifications',
    'Logout',
  ];

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget buildButton(String buttonName) {
    return ElevatedButton(
      onPressed: () {
        if (buttonName == 'Logout') {
          signOut();
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ), backgroundColor: Colors.white,
        minimumSize: const Size(350, 40), // Set the button size
        elevation: 2, // Add a small shadow
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            buttonName,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black, // Set text color to black
            ),
          ),
          const Text('>', style: TextStyle(fontSize: 20)), // Add '<' icon
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          const CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage("assets/user_1.jpg"),
          ),
          const SizedBox(height: 20),
          Text(
            user?.email ?? "User",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buttonNames
                .map(
                  (buttonName) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: buildButton(buttonName),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
