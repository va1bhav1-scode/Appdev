import '../models/meal.dart';
import '../services/api_client.dart';

class MealRepository {
  final ApiClient apiClient = ApiClient();

  Future<List<Meal>> getMeals(String query) {
    return apiClient.fetchMeals(query);
  }
}
