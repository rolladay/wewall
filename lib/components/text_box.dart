import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  const MyTextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});

  final String sectionName;
  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: ThemeData().colorScheme.secondary,
          borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[500]),
              ),
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey[500],
                ),
              )
            ],
          ),
          Text(text),
        ],
      ),
    );
  }
}
