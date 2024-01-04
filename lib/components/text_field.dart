import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      required this.controller,
      required this.obscureText,
      required this.hintText});

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: ThemeData().colorScheme.primary),
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(

        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500],
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        fillColor: Theme.of(context).colorScheme.inversePrimary,
        filled: true,
      ),
    );
  }
}
