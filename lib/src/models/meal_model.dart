class Meal {
  final String strMeal;
  final String strMealThumb;
  final String idMeal;
  final String strArea;
  final String strCountry;

  Meal({
    required this.strMeal,
    required this.strMealThumb,
    required this.idMeal,
    required this.strArea,
    required this.strCountry,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      strMeal: json['strMeal'] as String,
      strMealThumb: json['strMealThumb'] as String,
      idMeal: json['idMeal'] as String,
      strArea: json['strArea'] as String? ?? '',
      strCountry: json['strCountry'] as String? ?? '',
    );
  }

  factory Meal.empty() {
    return Meal(
      strMeal: '',
      strMealThumb: '',
      idMeal: '',
      strArea: '',
      strCountry: '',
    );
  }
}
