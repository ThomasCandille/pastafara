import 'package:flutter/material.dart';
import 'package:firebase_ai/firebase_ai.dart';

import '../widgets/recipe_response_card.dart';

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

  Widget _buildTextInputSection({
    required IconData icon,
    required String title,
    required String subtitle,
    required String hintText,
    required TextEditingController controller,
    required List<String> values,
    required ValueChanged<String> onSubmitted,
    required ValueChanged<String> onRemove,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFFFD763),
                child: Icon(icon, color: const Color(0xFF735B15), size: 21),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF2D1B17),
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF6C5A52),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            textInputAction: TextInputAction.done,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Color(0xFF99877F)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF6C5A52)),
              filled: true,
              fillColor: const Color(0xFFFFF0EB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(color: Color(0xFFC52820)),
              ),
            ),
          ),
          if (values.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final value in values)
                  InputChip(
                    label: Text(value),
                    onDeleted: () => onRemove(value),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    backgroundColor: const Color(0xFFFFF0EB),
                    deleteIconColor: const Color(0xFF8B776F),
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPeopleCounter() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFFFD763),
            child: Icon(Icons.groups, color: Color(0xFF735B15), size: 22),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Portions',
                  style: TextStyle(
                    color: Color(0xFF2D1B17),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Pour combien de\nconvives ?',
                  style: TextStyle(
                    color: Color(0xFF6C5A52),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0EB),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton.filled(
                  onPressed: _peopleCount > 1
                      ? () => setState(() => _peopleCount--)
                      : null,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    disabledBackgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2D1B17),
                    disabledForegroundColor: const Color(0xFFB7AAA5),
                    fixedSize: const Size(40, 40),
                  ),
                  icon: const Icon(Icons.remove, size: 20),
                ),
                SizedBox(
                  width: 64,
                  child: Text(
                    '$_peopleCount\n${_peopleCount == 1 ? 'convive' : 'convives'}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF2D1B17),
                      fontSize: 16,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton.filled(
                  onPressed: () => setState(() => _peopleCount++),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD763),
                    foregroundColor: const Color(0xFF735B15),
                    fixedSize: const Size(40, 40),
                  ),
                  icon: const Icon(Icons.add, size: 22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0EB),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFDF7E),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit_outlined,
                                  size: 14,
                                  color: Color(0xFF735B15),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'ATELIER CULINAIRE',
                                  style: TextStyle(
                                    color: Color(0xFF735B15),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Chef IA',
                          style: TextStyle(
                            color: Color(0xFFC52820),
                            fontSize: 34,
                            height: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Dis-moi ce que tu as, je m’occupe de tes pâtes.',
                          style: TextStyle(
                            color: Color(0xFF6C5A52),
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildTextInputSection(
              icon: Icons.inventory_2_outlined,
              title: 'Quels ingrédients as-tu ?',
              subtitle: 'Frigo, placard, restes du marché...',
              hintText: 'Ex : Tomates cerises, parmesan...',
              controller: _ingredientController,
              onSubmitted: _addIngredient,
              values: _ingredients,
              onRemove: (value) {
                setState(() => _ingredients.remove(value));
              },
            ),
            _buildTextInputSection(
              icon: Icons.health_and_safety_outlined,
              title: 'Quelles sont tes allergies ?',
              subtitle: 'Indique les aliments que tu dois éviter.',
              hintText: 'Ex : Arachides, lactose...',
              controller: _allergyController,
              onSubmitted: _addAllergy,
              values: _allergies,
              onRemove: (value) {
                setState(() => _allergies.remove(value));
              },
            ),
            _buildPeopleCounter(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => _testFirebaseAi(
                          _ingredients,
                          _allergies,
                          _peopleCount,
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFCF54),
                    foregroundColor: const Color(0xFF2D1B17),
                    disabledBackgroundColor: const Color(0xFFFFE7A8),
                    disabledForegroundColor: const Color(0xFF8B776F),
                    elevation: 4,
                    shadowColor: const Color(0x66E9A124),
                    shape: const StadiumBorder(),
                  ),
                  icon: const Icon(Icons.auto_awesome, size: 23),
                  label: const Text(
                    'Générer ma recette',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading) const CircularProgressIndicator(),
            if (_responseText.isNotEmpty)
              RecipeResponseCard(recipe: _responseText),
          ],
        ),
      ),
    );
  }
}
