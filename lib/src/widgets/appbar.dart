import 'package:flutter/material.dart';

class Appbar extends StatelessWidget {
  final String profilImagePath;
  final String pageName;
  const Appbar({
    super.key,
    this.profilImagePath = "assets/images/test_image.png",
    required this.pageName,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsetsGeometry.symmetric(
          horizontal: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.asset(
                    profilImagePath,
                    height: 48.0,
                    width: 48.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 8,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("PastaFaria", style: TextStyle(fontSize: 20)),
                    Text(pageName, style: TextStyle(fontSize: 15)),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Image(
                  image: AssetImage("assets/icons/notifications.png"),
                  height: 48,
                  width: 48,
                ),
                ClipOval(
                  child: Image.asset(
                    profilImagePath,
                    height: 48.0,
                    width: 48.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
