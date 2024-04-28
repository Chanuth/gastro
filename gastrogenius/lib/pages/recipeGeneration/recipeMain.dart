import 'package:flutter/material.dart';
import 'package:gastrogenius/pages/recipeGeneration/recipe_generation.dart';

class RecipeMain extends StatefulWidget {
  const RecipeMain({Key? key}) : super(key: key);

  @override
  _RecipeMainState createState() => _RecipeMainState();
}

class _RecipeMainState extends State<RecipeMain> {
  int _numberOfFields = 1;
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Your Ingredients',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_numberOfFields < 5) {
                          setState(() {
                            _numberOfFields++;
                            _controllers.add(TextEditingController());
                          });
                        }
                      },
                      icon: Icon(Icons.add, color: Colors.white),
                      label: SizedBox
                          .shrink(), // Use SizedBox.shrink() to remove the label
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 52, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Add up to 5 ingredients',
                      style: TextStyle(
                        color: _numberOfFields <= 5 ? Colors.black : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$_numberOfFields/5',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _numberOfFields,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
                  child: TextField(
                    controller: _controllers[index],
                    decoration: InputDecoration(
                      labelText: 'Add Ingredient ${index + 1}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                List<String> ingredients =
                    _controllers.map((controller) => controller.text).toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                      ),
                      body: RecipeGeneration(ingredients),
                    ),
                  ),
                );
              },
              child: const Text(
                'Generate Recipe',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
