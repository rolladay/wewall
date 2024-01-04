import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onTap});
  final Function()? onTap;

  @override
  State<RegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    //basic validate code..
    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      displayMessage('Password doesn`t match');
      return;
    }

    try {
      //create the user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextController.text,
              password: passwordController.text);

      //after creating user, create new document on cloud fb calles users
      FirebaseFirestore.instance
      //create or find Users collection in firestore
          .collection('Users')
      //and then create or find user eamil which in  located in user data(userCredential)
          .doc(userCredential.user!.email)
      //and set(create) map data User Name and Bio with given value

          .set({
        'User Name':
            emailTextController.text.split('@')[0], //initial username_default
        'Bio': 'Empty Bio...!'
        //add additional fields if needed
      });

      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          message,
          style: TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 60,
                ),
                Image.asset(
                  'assets/images/logo.png',
                ),
                const Text('Let`s create account for you'),
                const SizedBox(height: 60.0),
                MyTextField(
                    controller: emailTextController,
                    obscureText: false,
                    hintText: 'Email'),
                const SizedBox(height: 24.0),
                MyTextField(
                    controller: passwordController,
                    obscureText: true,
                    hintText: 'password'),
                const SizedBox(height: 24.0),
                MyTextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    hintText: 'confirm password'),
                const SizedBox(
                  height: 24.0,
                ),
                MyButton(
                  text: 'Sign Up',
                  onTap: signUp,
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      width: 24.0,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Sign in Now',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
