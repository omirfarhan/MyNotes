
import 'package:flutter/material.dart';
import 'package:miniappflutter/services/auth/auth_services.dart';
import 'package:miniappflutter/services/crud/notes_service.dart';

import 'enums/menu_action.dart';

class NotesMainUI extends StatefulWidget {
  const NotesMainUI({super.key});

  @override
  State<NotesMainUI> createState() => _NotesMainUIState();
}

class _NotesMainUIState extends State<NotesMainUI> {

  late final NoteServices _noteServices;
  String get userEmail=> AuthServices.firebase().currentuser!.Email!;


  @override
  void initState() {
    _noteServices=NoteServices();
    super.initState();
  }


  @override
  void dispose() {
    _noteServices.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('My Notes')
        ,actions: [

        PopupMenuButton<MainAction>(
          onSelected: (value) async {
            switch(value)  {

              case MainAction.logout:
                final showlogout= await showLogoutDialoge(context);

                if(showlogout){
                  //await dewa hoy nai karon age use korsi
                 await AuthServices.firebase().logout();
                  //await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login/', (_) => false,
                  );
                }

                debugPrint(showlogout.toString());
                break;
            }
            //debugPrint(value.toString());
          },

          itemBuilder: (context) {
            return const[
              PopupMenuItem<MainAction>(
                value:MainAction.logout,
                child: const Text('Logout'),
              ),



            ];
          },

        )

      ],
      ),
      body: FutureBuilder(
          future: _noteServices.getorCreateuser(email: userEmail),

          builder: (context, snapshot) {
            switch(snapshot.connectionState){


              case ConnectionState.done:
                return StreamBuilder(
                    stream: _noteServices.allNotes,
                    builder: (context, snapshot) {

                      switch(snapshot.connectionState){

                        case ConnectionState.waiting:
                          return const Text("Waiting for all notes");

                        }

                      Default:
                      return const CircularProgressIndicator();

                    },


                  );

                Default:
                return const CircularProgressIndicator();
            }
          },

      ),

    );
  }
}
Future<bool> showLogoutDialoge(BuildContext context){

  return showDialog<bool>(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')
            ),

            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Log out'))
          ],
        );
      }
  ).then((value) => value ?? false,);
}
