import 'package:flutter/material.dart';

class TextFormFieldProvider extends StatelessWidget {
  const TextFormFieldProvider(
      {Key? key,
      required this.hintText,
      required this.iconData,
      this.obscureText = false,
      this.edgeInsets = const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      this.controller})
      : super(key: key);

  final String hintText;
  final IconData iconData;
  final bool obscureText;
  final EdgeInsets edgeInsets;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: edgeInsets,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            prefixIcon: Icon(
              iconData,
              color: Colors.white60,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white54),
            fillColor: Colors.white24,
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }
}
