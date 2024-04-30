import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialogs/logout.dailog.dart';
import 'package:mynotes/view/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your notes"),
      actions: [
        IconButton(onPressed: (){
          Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
        }, icon: const Icon(Icons.add)),
        PopupMenuButton<MenuAction>(
          onSelected: (value)async {
        switch(value) {

          case MenuAction.logout:
            final shouldLogout = await showLogoutDialog(context);
            if(shouldLogout){
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute, (_) => false);
            }
        }
        }, itemBuilder: (context){
          return const [
             PopupMenuItem(value: MenuAction.logout,child: Text("Logout")),
          ];
          
        })
      ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){ 
            case ConnectionState.done:
              // TODO: Handle this case.
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder:(context,snapshot) {
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData){
                          final allNotes = snapshot.data as List<DatabaseNote>;
                          return NotesListView(
                            notes: allNotes, 
                            onDeleteNote: (note) async{
                              await _notesService.deleteNote(id: note.id);

                            },
                            onTap: (note) {
                                Navigator.of(context).pushNamed(
                                  createOrUpdateNoteRoute,
                                  arguments: note,
                                );
                            },);
                          
                        }else{
                          return const CircularProgressIndicator();
                        }
                      default:
                        return const CircularProgressIndicator();

                    }
                } ,
                );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
/*
Future<bool> showLogoutDialog(BuildContext context){
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      title: const Text("Sign Out"),
      content: const Text("Are you sure you want to sign out?"),
      actions: [
        TextButton(onPressed: (){
            Navigator.of(context).pop(false);
        }, child: const Text("Cancel")),
      
      TextButton(onPressed: (){
                    Navigator.of(context).pop(true);

        }, child: const Text("Sign Out"))
      ],
    );
  }).then((value) => value ?? false);
}
*/