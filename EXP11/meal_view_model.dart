import '../models/meal.dart';
import '../repository/meal_repository.dart';

class MealViewModel {
  final MealRepository _repository = MealRepository();

  Future<List<Meal>> fetchMeals(String query) {
    return _repository.getMeals(query);
  }
}
