import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:gastrogenius/navigation/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastrogenius/navigation/widget_tree.dart';
import './pages/landing.dart';

// import 'pages/authentication/landing.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class SplashLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // GG-loading.png image
          Image.asset(
            'assets/GG-loading.png',
          ),
          // Add SizedBox for spacing between image and text
          SizedBox(height: 20),
          // Text
          Padding(
            padding: EdgeInsets.only(bottom: 200),
            child: Text(
              'GastroGenius',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/start.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Red overlay
          Positioned.fill(
            child: Container(
              color: Colors.red.withOpacity(0.5), // Adjust opacity as needed
            ),
          ),
          // Column for GG-loading.png and Text
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          // Animated Splash Screen
          AnimatedSplashScreen(
            backgroundColor: Colors.transparent,
            splash: SplashLogo(), // Use SplashLogo here
            duration: 2500,
            splashIconSize: double.maxFinite,
            nextScreen: const WidgetTree(),
          ),
        ],
      ),
    );
  }
}
