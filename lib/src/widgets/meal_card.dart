import 'package:flutter/material.dart';

Widget buildMealCard(
  BuildContext context,
  String mealName,
  String mealImageUrl,
  String? mealArea,
  String? mealCountry,
) {
  return Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Column(
      children: [
        if (mealImageUrl.isNotEmpty)
          Image.network(
            mealImageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200.0
          ),
          Row(
            children:[
        Text(mealName),
        Text(mealArea ?? ''),
        Image(
                  image: AssetImage("assets/icons/favorite.png"),
                  height: 24,
                  width: 24,
                ),
            ]
          )
      ],
    ),
  );
}
