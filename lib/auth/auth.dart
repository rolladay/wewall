import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wewall/auth/login_or_register.dart';

import '../pages/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        //everytime user login or logout, authStateChanges gives event(User object)
        //and Builder widget creates UI everytime based on this event happens.
        stream: FirebaseAuth.instance.authStateChanges(),
        //builder method needs 2 parameters. Buildcontext context and asyncSnapshot<T> here as T is User object
        builder: (context, snapshot){
          //user is logged-in
          if(snapshot.hasData){
            return const HomePage();
          }
          //user is not logged-in
          else{
            return const LoginOrRegister();
          }
        },

      ),
    );
  }
}
