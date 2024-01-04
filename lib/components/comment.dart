import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  const Comment(
      {super.key,
      required this.user,
      required this.time,
      required this.comment});

  final String user;
  final String comment;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).colorScheme.secondary,
      margin: EdgeInsets.only(bottom: 6),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //comment
          Text(comment),
          SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Text(
                user,
                style: TextStyle(color: Colors.grey[400]),
              ),
              Text(
                ' . ',
                style: TextStyle(color: Colors.grey[400]),
              ),
              Text(
                time,
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),

          //user, time
        ],
      ),
    );
  }
}
