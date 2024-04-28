import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gastrogenius/pages/recipeGeneration/recipe_detail_page.dart';
import 'package:http/http.dart' as http;
import '../../models/content_model.dart';
import './recipeMain.dart';

class RecipeGeneration extends StatefulWidget {
  final List<String> inputValues;

  const RecipeGeneration(this.inputValues, {Key? key}) : super(key: key);

  @override
  State<RecipeGeneration> createState() => _RecipeGenerationState();
}

class _RecipeGenerationState extends State<RecipeGeneration> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<ContentModel> content = [];

  Future<void> getRecipes() async {
    final ingredients = widget.inputValues.length > 1
        ? widget.inputValues
        : [widget.inputValues[0], ''];
    try {
      var url = 'http://10.0.2.2:8001/recipes';

      Map data = {
        "ingredients": ingredients,
      };

      // encode Map to JSON
      var body = json.encode(data);

      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body) as List<dynamic>;
        content = jsonData.map((item) {
          return ContentModel(
            title: item['title'],
            image_name: item['image_name'],
          );
        }).toList();

        setState(() {}); // Update the state of the widget
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<String> _getImage(String imageName) async {
    // if (kDebugMode) {
    //   print('$imageName.jpg');
    // }
    final ref = _storage.ref().child('$imageName.jpg');
    return await ref.getDownloadURL().catchError((error) {
      if (kDebugMode) {
        print('Error getting download URL: $error');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recently Generated',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecipeMain(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 52, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: content.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: content.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  appBar: AppBar(
                                    title: Text("Recipe Details"),
                                  ),
                                  body: RecipeDetailPage(
                                    title: content[index].title,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: GridTile(
                            footer: GridTileBar(
                              backgroundColor:
                                  Color.fromARGB(255, 255, 255, 255),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      content[index].title,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.favorite_border,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      // Handle favorite icon press
                                    },
                                  ),
                                ],
                              ),
                            ),
                            child: FutureBuilder(
                              future: _getImage(content[index].image_name),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String?> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final imageUrl = snapshot.data;
                                    if (imageUrl != null) {
                                      return Center(
                                        child: Image.network(imageUrl),
                                      );
                                    } else {
                                      return const Text('Image not found');
                                    }
                                  }
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
