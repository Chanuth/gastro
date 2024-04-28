import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:gastrogenius/pages/recipeGeneration/recipe_detail_page.dart';
import 'package:http/http.dart' as http;
import '../models/content_model.dart';
import './recipeGeneration/recipeMain.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<ContentModel> content = [];
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getRecipes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getRecipes() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8001/topRecipes'));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body) as List<dynamic>;
        content = jsonData
            .map((item) => ContentModel(
                  title: item['title'],
                  image_name: item['image_name'],
                ))
            .toList();
        setState(() {
          _isLoading = false;
        });
      } else {
        print(
            'Failed to load recipe data: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Failed to load recipe data: $e');
    }
  }

  Future<String> _getImage(String imageName) async {
    final ref = _storage.ref().child('$imageName.jpg');
    return await ref.getDownloadURL().catchError((error) {
      if (kDebugMode) {
        print('Error getting download URL: $error');
      }
      return '';
    });
  }

  Widget buildBackgroundImage() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 4,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildTryNewRecipeButton() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 50.0, bottom: 0.0), // Adjust top and bottom padding as needed
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        width: 400,
        decoration: BoxDecoration(
          color: Colors.red, // Set button color to red
          borderRadius: BorderRadius.circular(
              20), // Set border radius to 0 for a sharp edge
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RecipeMain(),
              ),
            );
          },
          label: const Text(
            "Try New Recipe",
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          icon: const Icon(
            Icons.arrow_forward,
            color: Colors.white, // Set icon color to white
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Set button color to red
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  0), // Set border radius to 0 for a sharp edge
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTrendingTab() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
            // Adjusting the padding and scroll direction if needed
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // This creates two columns
              childAspectRatio:
                  1, // Adjust the aspect ratio for the size of your images and titles
              crossAxisSpacing: 8.0, // Space between columns
              mainAxisSpacing: 20.0, // Space between rows
            ),
            itemCount: content.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailPage(
                        title: content[index].title,
                      ),
                    ),
                  );
                },
                child: GridTile(
                  footer: Container(
                    padding: const EdgeInsets.all(4.0),
                    color: const Color.fromARGB(255, 255, 255, 255)
                        .withOpacity(1), // Semi-transparent footer background
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            content[index].title,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              // Toggle favorite status
                              content[index].isFavorite =
                                  !content[index].isFavorite;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  child: FutureBuilder(
                    future: _getImage(content[index].image_name),
                    builder: (BuildContext context,
                        AsyncSnapshot<String?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading image'));
                        } else {
                          final imageUrl = snapshot.data;
                          return imageUrl != null
                              ? Image.network(imageUrl,
                                  fit: BoxFit
                                      .cover) // Make sure the image covers the grid tile
                              : const Center(child: Text('Image not found'));
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              );
            },
          );
  }

  Widget buildFavouritesTab() {
    final favorites = content.where((item) => item.isFavorite).toList();

    if (favorites.isEmpty) {
      return const Center(child: Text("No favorite recipes added."));
    } else {
      return ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favorites[index].title),
            leading: FutureBuilder(
              future: _getImage(favorites[index].image_name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Image.network(snapshot.data!, fit: BoxFit.cover);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                setState(() {
                  // Toggle favorite status
                  favorites[index].isFavorite = !favorites[index].isFavorite;
                });
              },
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildBackgroundImage(),
          buildTryNewRecipeButton(),
          Expanded(
            child: DefaultTabController(
              length: 2, // The number of tabs / content sections to display.
              child: Column(
                children: [
                  Material(
                    // Provides the ink effects for the TabBar, among other visual properties.
                    color:
                        const Color.fromARGB(255, 255, 255, 255), // Optional: to match your style or Theme.
                    child: TabBar(
                      // No need to manually manage a TabController with DefaultTabController.
                      tabs: const [
                        Tab(text: "Trending"),
                        Tab(text: "Favourites"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      // The controller is managed by DefaultTabController.
                      children: [
                        buildTrendingTab(),
                        buildFavouritesTab(),
                      ],
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // Or any other color to match your design
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
