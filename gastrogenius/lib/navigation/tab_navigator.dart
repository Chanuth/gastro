import 'package:flutter/material.dart';
import 'package:gastrogenius/main.dart';
import 'package:gastrogenius/pages/home.dart';
import 'package:gastrogenius/pages/profile.dart';
import 'package:gastrogenius/pages/recipeGeneration/recipeMain.dart';
import 'package:gastrogenius/pages/scan.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({super.key, required this.navigatorKey, required this.tabItem});

  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (tabItem == "Home") {
      child = const Home();
    } else if (tabItem == "Generate") {
      child = const RecipeMain();
    } else if (tabItem == "Scan") {
      child = const Scan();
    } else if (tabItem == "Profile") {
      child = Profile();
    } else {
      child = const MyApp();
    }

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
