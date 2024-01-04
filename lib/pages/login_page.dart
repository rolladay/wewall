import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wewall/components/button.dart';
import 'package:wewall/components/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onTap});
  final Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //why we r doing these? we want to access each textField by these each controller.
  final emailTextController = TextEditingController();
  final passwordController = TextEditingController();

  //sign in function
  void signIn() async {
    //show loading circle at first _default
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text, password: passwordController.text);
      if(context.mounted){
        //Below is what to delete circular indicator
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);

    }
  }

  //display error message
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          message,
          style: const TextStyle(fontSize: 12.0),
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
                const Text('Welcome buddy! '),
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
                const SizedBox(
                  height: 24.0,
                ),
                MyButton(
                  text: 'Sign In',
                  onTap: signIn,
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      width: 24.0,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register Now',
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
