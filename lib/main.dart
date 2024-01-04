import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wewall/auth/auth.dart';
import 'package:wewall/auth/login_or_register.dart';
import 'package:wewall/firebase_options.dart';
import 'package:wewall/pages/login_page.dart';
import 'package:wewall/pages/register_page.dart';
import 'package:wewall/themes/dark_theme.dart';
import 'package:wewall/themes/light_theme.dart';

void main() async{
  //initiallize flutter app
  WidgetsFlutterBinding.ensureInitialized();
  //Initiallizing the firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
