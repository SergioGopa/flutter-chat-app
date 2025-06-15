import 'package:flutter/material.dart';

class BlueBtnWidget extends StatelessWidget {
  final String placeholder;
  final Function()? onpressed;
  const BlueBtnWidget({super.key, required this.placeholder, this.onpressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: Colors.blue,
        shape: StadiumBorder(),
      ),
      child: SizedBox(
          width: double.infinity,
          height: 55,
          child: Center(
              child: Text(
            placeholder,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ))),
    );
  }
}
