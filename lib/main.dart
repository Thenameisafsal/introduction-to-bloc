import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/views/login_view.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main(){
  runApp(const MaterialApp(
    home: HomePage()
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
    appBar: AppBar( title: const Text('notes app'),),
    body: Column(children:[FutureBuilder(
      future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                if(user?.emailVerified ?? false){
                      print("verified user");
                }
                return const Text("done");
              default:
                return const Text("error");
            }
        }
      ),
      TextButton(onPressed:(){Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const  VerifyEmailView()));}, child: const Text('press me'))
      ])
    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify email"),),
      body: Center(child: Column(
        children: [
          TextButton(onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context){return const LoginView();}
                  )
                );
              },
            child: const Text("login here")
          ),
          const Text("Verify email here"),
          TextButton(onPressed: () async{
                final userCredentials = await FirebaseAuth.instance.signInWithEmailAndPassword(email: "thenameisafsalahamad@gmail.com", password: "Who@re123");
                final user = FirebaseAuth.instance.currentUser;
                print(userCredentials);
                await user?.sendEmailVerification();
            }, 
            child: const Text("Verify email here")
            )
          ]
        )
      )
    );
  }
}