import 'package:flutter/material.dart';
import 'package:sketch_app/screen/log_in.dart';
import 'package:sketch_app/screen/signup.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool a = true;
  void go(){
    setState(() {
      a =! a;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(a){
      return LoginScreen(go);
    }else{
      return SignupScreen(go);
    }
  }
}
