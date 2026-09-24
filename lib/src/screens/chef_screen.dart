import 'package:flutter/material.dart';
import 'package:firebase_ai/firebase_ai.dart';

class ChefView extends StatefulWidget {
  const ChefView({super.key});

  @override
  State<ChefView> createState() => _ChefViewState();
}

class _ChefViewState extends State<ChefView> {
  final TextEditingController _ingredientController = TextEditingController();
  final TextEditingController _allergyController = TextEditingController();
  final List<String> _ingredients = [];
  final List<String> _allergies = [];
  String _responseText = '';
  bool _isLoading = false;
  int _peopleCount = 1;

  void _addIngredient(String value) {
    final text = value.trim();
    if (text.isEmpty) return;

    setState(() {
      _ingredients.add(text);
    });
    _ingredientController.clear();
  }

  void _addAllergy(String value) {
    final text = value.trim();
    if (text.isEmpty) return;

    setState(() {
      _allergies.add(text);
    });
    _allergyController.clear();
  }

  String _removeMarkdown(String text) {
    return text
        .replaceAll(RegExp(r'```(?:\w+)?'), '')
        .replaceAllMapped(
          RegExp(r'\[([^\]]+)\]\([^)]+\)'),
          (match) => match.group(1)!,
        )
        .replaceAll(RegExp(r'^\s{0,3}#{1,6}\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^\s*[-+>]\s+', multiLine: true), '')
        .replaceAll(RegExp(r'[*_`~]'), '')
        .trim();
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    _allergyController.dispose();
    super.dispose();
  }

  Future<void> _testFirebaseAi(
    List<String> ingredients,
    List<String> allergies,
    int peopleCount,
  ) async {
    setState(() {
      _isLoading = true;
      _responseText = '';
    });

    try {
      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-3.5-flash',
      );
      final prompt = [
        Content.text(
          'Je suis un chef cuisinier italien, je veux créer une recette de sauces pour des pates en utilisant les ingrédients suivants : ${ingredients.join(', ')}. Je dois faire attention à ce que la recette ne contienne pas les allergènes suivants : ${allergies.join(', ')}. Donne-moi une recette détaillée avec les étapes de préparation et les quantités exactes pour chaque ingrédient pour $peopleCount personnes. Fais moi une réponse courte avec les étapes de prparation et les quantités exactes pour chaque ingrédient. Donne moi la réponse en français et uniquement en texte brut, sans aucune syntaxe Markdown.',
        ),
      ];

      final response = await model.generateContent(prompt);
      if (!mounted) return;
      final text = response.text;

      if (text == null || text.trim().isEmpty) {
        setState(() {
          _responseText = 'La réponse générée ne contient aucun texte.';
        });
        return;
      }

      setState(() {
        _responseText = _removeMarkdown(text);
        _ingredients.clear();
        _allergies.clear();
        _peopleCount = 1;
      });
      _ingredientController.clear();
      _allergyController.clear();
    } catch (error, stackTrace) {
      debugPrint('Firebase AI request failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      setState(() {
        _responseText = 'Erreur lors de la génération de la réponse.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Mes Ingredients'),
            TextField(
              controller: _ingredientController,
              textInputAction: TextInputAction.done,
              onSubmitted: _addIngredient,
            ),
            ..._ingredients.map(wordBubble),
            const SizedBox(height: 16),
            const Text('Mes allergies'),
            TextField(
              controller: _allergyController,
              textInputAction: TextInputAction.done,
              onSubmitted: _addAllergy,
            ),
            ..._allergies.map(wordBubble),
            const SizedBox(height: 16),
            const Text('Nombre de personnes'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _peopleCount > 1
                      ? () => setState(() => _peopleCount--)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Text('$_peopleCount'),
                IconButton(
                  onPressed: () => setState(() => _peopleCount++),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () =>
                        _testFirebaseAi(_ingredients, _allergies, _peopleCount),
              child: const Text('Génération IA'),
            ),
            const SizedBox(height: 16),
            if (_isLoading) const CircularProgressIndicator(),
            if (_responseText.isNotEmpty) ...[
              const Text('Réponse de Firebase AI :'),
              Text(_responseText),
            ],
          ],
        ),
      ),
    );
  }
}

Widget wordBubble(String text) {
  return Container(
    padding: const EdgeInsets.all(8),
    margin: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(text),
  );
}
