import 'package:flutter/material.dart';

class TextButtonProvider extends StatelessWidget {
  const TextButtonProvider(
      {Key? key,
      required this.text,
      this.backgroundColor = Colors.blueAccent,
      this.function})
      : super(key: key);

  final Color backgroundColor;
  final String text;
  final VoidCallback? function;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        elevation: 10,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
      onPressed: function,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
