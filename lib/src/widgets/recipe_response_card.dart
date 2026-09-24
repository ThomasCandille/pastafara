import 'package:flutter/material.dart';

class RecipeResponseCard extends StatelessWidget {
  const RecipeResponseCard({super.key, required this.recipe});

  final String recipe;

  static final RegExp _stepPattern = RegExp(r'^(\d+)[.)]\s*(.*)$');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: SelectionArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundColor: Color(0xFFFFD763),
                  child: Icon(
                    Icons.restaurant_menu,
                    color: Color(0xFF735B15),
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ta recette est prête !',
                        style: TextStyle(
                          color: Color(0xFF2D1B17),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Préparée par Chef IA',
                        style: TextStyle(
                          color: Color(0xFF8B776F),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Divider(height: 1, color: Color(0xFFFFE2D8)),
            ),
            ..._buildRecipeContent(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRecipeContent() {
    final widgets = <Widget>[];
    var isIngredientsSection = false;
    var needsSpacing = false;

    for (final rawLine in recipe.split(RegExp(r'\r?\n'))) {
      final line = rawLine.trim();

      if (line.isEmpty) {
        needsSpacing = widgets.isNotEmpty;
        continue;
      }

      if (needsSpacing) {
        widgets.add(const SizedBox(height: 10));
        needsSpacing = false;
      }

      final step = _stepPattern.firstMatch(line);
      final isHeading = step == null && line.endsWith(':') && line.length <= 60;

      if (isHeading) {
        isIngredientsSection = line.toLowerCase().contains('ingrédient');
        widgets.add(
          _buildSectionTitle(
            line.substring(0, line.length - 1),
            isIngredientsSection
                ? Icons.shopping_basket_outlined
                : Icons.format_list_numbered,
          ),
        );
      } else if (step != null) {
        isIngredientsSection = false;
        widgets.add(_buildStep(step.group(1)!, step.group(2)!));
      } else if (isIngredientsSection) {
        widgets.add(_buildIngredient(line));
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              line,
              style: const TextStyle(
                color: Color(0xFF5F504A),
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFC52820), size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF2D1B17),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredient(String ingredient) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(top: 7),
            decoration: const BoxDecoration(
              color: Color(0xFFFFC83D),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              ingredient,
              style: const TextStyle(
                color: Color(0xFF5F504A),
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String instruction) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EB),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFFC52820),
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              instruction,
              style: const TextStyle(
                color: Color(0xFF5F504A),
                fontSize: 15,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
