class User {
  final String email;
  final List<String> favoriteMeals;
  final List<String> allergies;

  User({
    required this.email,
    required this.favoriteMeals,
    required this.allergies,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['mail'] as String,
      favoriteMeals: List<String>.from(json['favoriteMeals'] as List<dynamic>),
      allergies: List<String>.from(json['allergies'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mail': email,
      'favoriteMeals': favoriteMeals,
      'allergies': allergies,
    };
  }

  factory User.empty() {
    return User(
      email: '',
      favoriteMeals: [],
      allergies: [],
    );
  }
}
