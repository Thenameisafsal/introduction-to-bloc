import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/crud/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

enum MenuAction { logout } // define the enumeration

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;
  @override
  void initState(){
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: const Text("Notes UI"),
      actions: [
        // the logout option in the menu
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value){
                case MenuAction.logout:
                  final confirmation = await logOut(context);
                  // devtools.log(confirmation.toString()); // prints the confirmation boolean
                  if(confirmation){
                    await AuthService.firebase().logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_)=> false); // move to the login page upon logout
                  }
                  break;
              }
            },
            itemBuilder: (context) { return const [ // itembuilder will return only a list<popupmenuentry<MenuAction>>  type -> note that popupMenuItem is a subclass of popupMenuEntry as it extends popupMenuEntry
                 PopupMenuItem(value: MenuAction.logout, child: Text("logout")), // the value passed here will be passed on to the onSelected() function defined above as the value parameter
            ];
           }
          )
        ],
      ),
      body: FutureBuilder(future: _notesService.getOrCreateUser(email: userEmail),
       builder: (context,snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.done:
            return StreamBuilder(
              stream: _notesService.allNotes,
              builder: (context,snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                    return const Text("waiting for response.");
                  default:
                    return const CircularProgressIndicator();
                }
              },
             );
          default:
            return const CircularProgressIndicator();
        }
       }
       ),
    );
  }
}

// implementation of the logout confirmation dialog
Future<bool> logOut(BuildContext context){
  return showDialog<bool>(
        context : context,
        builder: (context){
        return AlertDialog(title: const Text('Logout'),
            content: const Text("You really want to log out?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Cancel")
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Log Out")
                ),
              ],
            );
      },
  ).then((value) => value ?? false); // since this is an optional future we make sure to return a future by checking for the null value return
}