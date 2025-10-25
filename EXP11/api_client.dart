import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';

class ApiClient {
  Future<List<Meal>> fetchMeals(String query) async {
    final url = 'https://www.themealdb.com/api/json/v1/1/search.php?s=$query';

    // Simulate network delay to trigger loading spinner
    await Future.delayed(const Duration(seconds: 2));

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals = data['meals'];
      if (meals == null) return [];
      return meals.map<Meal>((json) => Meal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }
}
