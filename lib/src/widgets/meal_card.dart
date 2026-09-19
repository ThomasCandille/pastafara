import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/user_provider.dart';

Widget buildMealCard(
  BuildContext context,
  WidgetRef ref,
  String mealName,
  String mealImageUrl,
  String? mealArea,
  String? mealCountry, {
  bool isFavorite = false,
}) {
  return Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Column(
      children: [
        if (mealImageUrl.isNotEmpty)
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.network(
                  mealImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200.0,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () async {
                    final userId = FirebaseAuth.instance.currentUser?.uid;
                    if (userId == null) return;

                    final userService = ref.read(userServiceProvider);
                    if (isFavorite) {
                      await userService.removeFavoriteMeal(userId, mealName);
                    } else {
                      await userService.addFavoriteMeal(userId, mealName);
                    }
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        Row(
          children: [
            Text(mealName),
            Text(mealArea ?? ''),
            const Image(
              image: AssetImage('assets/icons/favorite.png'),
              height: 24,
              width: 24,
            ),
          ],
        ),
      ],
    ),
  );
}
