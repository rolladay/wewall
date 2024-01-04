import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wewall/components/drawer.dart';
import 'package:wewall/components/text_field.dart';
import 'package:wewall/components/wall_post.dart';
import 'package:wewall/pages/profile_page.dart';

import '../helper/helper_method.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  void postMessage() {
    //only post when there is something in the textfield
    if (textController.text.isNotEmpty) {
      //Store in firebase
      FirebaseFirestore.instance.collection('User Posts').add({
        'User Email': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }
    setState(() {
      textController.clear();
    });
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void goToProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        // backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text(
          'We Wall',

        ),
      ),
      drawer: MyDrawer(
        onLogoutTap: signOut,
        onProfileTap: goToProfile,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('User Posts')
                    //OrderBy is optional
                    .orderBy('TimeStamp', descending: false)
                    //subscribe snapshot of collection
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          user: post['User Email'],
                          message: post['Message'],
                          postId: post.id,
                          //Wallpost Widget에 List를 전달(좋아요한 이메일의 리스트)
                          likes: List<String>.from(post['Likes'] ?? []),
                          time : formatData(post['TimeStamp']),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error : ${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                        controller: textController,
                        obscureText: false,
                        hintText: 'type your message'),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
            Text('Logged in user as  ${currentUser.email!}'),
          ],
        ),
      ),
    );
  }
}
