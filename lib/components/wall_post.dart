import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wewall/components/comment_button.dart';
import 'package:wewall/components/delete_button.dart';
import 'package:wewall/components/like_button.dart';
import 'package:wewall/components/comment.dart';
import 'package:wewall/helper/helper_method.dart';

class WallPost extends StatefulWidget {
  const WallPost({
    super.key,
    required this.time,
    required this.user,
    required this.message,
    required this.postId,
    required this.likes,
  });

  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  final String time;
  // final String time;

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  final _commentTextController = TextEditingController();
  String commentNum = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //below shows true or false
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLiked() {
    setState(() {
      isLiked = !isLiked;
    });
    //access the document in fb, postID refers to each post content
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email]),
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String comment) {
    //show dialog box to input comment
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId)
        .collection('comments')
        .add({
      'commentText': comment,
      'commentedBy': currentUser.email,
      'commentTime': Timestamp.now(),
    });
  }

  void deletePost() {
    //show dialogbox for confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure to delete the post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              //delete comments first from firestore
              //if you only delete the post, then bunch of posts will remail

              final commentDocs = await FirebaseFirestore.instance
                  .collection('User Posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .get();
              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                    .collection('User Posts')
                    .doc(widget.postId)
                    .collection('comments')
                    .doc(doc.id)
                    .delete();
              }

              await FirebaseFirestore.instance
                  .collection('User Posts')
                  .doc(widget.postId)
                  .delete()
                  .then((value) => print('deleted'))
                  .catchError(
                    (error) => print('failed to delete : $error'),
                  );
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (currentUser) => AlertDialog(
        title: Text('Add Comment'),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(
            hintText: 'Write some comment.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              Navigator.of(context).pop();
              _commentTextController.clear();
            },
            child: Text('Post'),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.secondary,
      ),
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      padding: const EdgeInsets.all(24),
      // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //wallpost
                  Text(widget.message),
                  SizedBox(
                    height: 10,
                  ),
                  //message

                  Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        ' . ',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // Text(time),
                ],
              ),
              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletePost),
            ],
            //delete button
          ),
          const SizedBox(
            width: 16,
          ),

          //button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //like
              Column(
                children: [
                  LikeButton(isLiked: isLiked, onTap: toggleLiked),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(
                width: 20.0,
              ),
              //commrnt
              Column(
                children: [
                  CommentButton(onTap: showDialogBox),
                  SizedBox(
                    height: 10,
                  ),
                  Text(



                    //
                    '0',
                    // 여기 Provider 넣기 딱 좋은데.. 아쉽
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          //comments
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('User Posts')
                .doc(widget.postId)
                .collection('comments')
                .orderBy('commentTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map(
                  (doc) {
                    final commentData = doc.data() as Map<String, dynamic>;
                    return Comment(
                      user: commentData['commentedBy'],
                      comment: commentData['commentText'],
                      time: formatData(commentData['commentTime']),
                    );
                  },
                ).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
