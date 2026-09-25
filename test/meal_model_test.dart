import 'package:flutter_test/flutter_test.dart';
import 'package:pastafara/src/models/meal_model.dart';

void main() {
  test('Meal.fromJson crée un repas', () {
    final meal = Meal.fromJson({
      'strMeal': 'Carbonara',
      'strMealThumb': 'image.jpg',
      'idMeal': '1',
      'strArea': 'Italian',
      'strCountry': 'Italy',
    });

    expect(meal.strMeal, 'Carbonara');
    expect(meal.idMeal, '1');
  });
}
