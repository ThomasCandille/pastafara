import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pastafara/src/widgets/recipe_response_card.dart';

void main() {
  testWidgets('affiche la recette', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: RecipeResponseCard(recipe: 'Spaghetti carbonara')),
      ),
    );

    expect(find.text('Ta recette est prête !'), findsOneWidget);
  });
}
