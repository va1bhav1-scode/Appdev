import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../view_model/meal_view_model.dart'; // ✅ Import ViewModel

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  final TextEditingController _controller = TextEditingController();
  final MealViewModel viewModel = MealViewModel(); // ✅ Use ViewModel
  late Future<List<Meal>> meals;
  String searchQuery = 'chicken'; // default search

  @override
  void initState() {
    super.initState();
    meals = viewModel.fetchMeals(searchQuery); // ✅ Use ViewModel here
  }

  void searchMeals() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        meals = viewModel.fetchMeals(query); // ✅ Use ViewModel here too
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food App')),
      body: SafeArea(
        child: Column(
          children: [
            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Search meals...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: searchMeals,
                    child: const Text('Search'),
                  ),
                ],
              ),
            ),
            // 🍽️ Meal List
            Expanded(
              child: FutureBuilder<List<Meal>>(
                future: meals,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No meals found'));
                  } else {
                    final mealList = snapshot.data!;
                    return ListView.builder(
                      itemCount: mealList.length,
                      itemBuilder: (context, index) {
                        final meal = mealList[index];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: Image.network(meal.image, width: 50),
                            title: Text(meal.name),
                            subtitle: Text(
                              meal.instructions.length > 50
                                  ? '${meal.instructions.substring(0, 50)}...'
                                  : meal.instructions,
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
