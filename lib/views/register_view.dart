import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/views/login_view.dart';
import '../firebase_options.dart';
class RegisterView extends StatefulWidget{
  const RegisterView({super.key});

  // const myApp(Key? key) : super(key : key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState(){
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }
  @override
  void dispose(){
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("register")),
      body: Column(
        children:[
            TextField(
            controller: _email, 
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Please enter you email here")),
            TextField(
              controller: _password, 
              obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
              decoration: const InputDecoration(hintText: "Enter your password here")),
            TextButton(onPressed: () async { 
              final email = _email.text;
              final password = _password.text;
              final userCredentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
              print(userCredentials);
              }, child: const Text('Register')),
              TextButton(
                  onPressed: () => {Navigator.of(context).pop()} , // go back to the login page by popping the stack
                  child: const Text("Already have an account? Log in."),
              )
              ]
      )
    );
        }
  }
