import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final String title;

  const LogoWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 50),
        width: 170,
        child: Column(
          children: [
            Image(image: AssetImage('assets/tag-logo.png')),
            SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
