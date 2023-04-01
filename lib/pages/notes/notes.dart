// import 'dart:developer';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:newapp/pages/enum/menu_actions.dart';
// import 'package:newapp/pages/serices/auth/auth_service.dart';
// import 'package:newapp/pages/serices/crud/note_service.dart';
// import '../constants/routes.dart';

// class Notesview extends StatefulWidget {
//   const Notesview({Key? key}) : super(key: key);

//   @override
//   State<Notesview> createState() => _NotesviewState();
// }

// class _NotesviewState extends State<Notesview> {
//   late final NotesService _notesService;
//   String get userEmail => AuthService.firebase().currentuser!.email!;
//   @override
//   void initState() {
//     _notesService = NotesService();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Notes'),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Navigator.of(context).pushNamed(newnotesroute);
//               },
//               icon: const Icon(Icons.add),
//             ),
//             PopupMenuButton(
//               onSelected: (value) async {
//                 switch (value) {
//                   case MenuAction.logout:
//                     final shouldlogout = await showdialog(context);
//                     if (shouldlogout) {
//                       await AuthService.firebase().LogOut();
//                       Navigator.of(context).pushNamedAndRemoveUntil(
//                           loginroute, (route) => false);
//                     }

//                     break;
//                 }
//               },
//               itemBuilder: (context) {
//                 return const [
//                   PopupMenuItem(
//                     value: MenuAction.logout,
//                     child: Text('Sign Out'),
//                   )
//                 ];
//               },
//             )
//           ],
//         ),
//         body: FutureBuilder(
//           future: _notesService.getOrCreateUser(email: userEmail),
//           builder: (context, snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.done:
//                 return StreamBuilder(
//                   stream: _notesService.allNotes,
//                   builder: (context, snapshot) {
//                     switch (snapshot.connectionState) {
//                       case ConnectionState.waiting:
//                       case ConnectionState.active:
//                         if (snapshot.hasData) {
//                           final allNotes = snapshot.data as List<DatabaseNote>;
//                           log(allNotes.toString());
//                           return ListView.builder(
//                             itemCount: allNotes.length,
//                             itemBuilder: (context, index) {
//                               final note = allNotes[index];
//                               log(note.text);
//                               if (note != null) {
//                                 return ListTile(
//                                   title: Text(note.text),
//                                 );
//                               } else {
//                                 return Text('data');
//                               }
//                             },
//                           );
//                         } else {
//                           return const CircularProgressIndicator();
//                         }

//                       default:
//                         return const CircularProgressIndicator();
//                     }
//                   },
//                 );

//               default:
//                 return const CircularProgressIndicator();
//             }
//           },
//         ));
//   }
// }

// Future<bool> showdialog(BuildContext context) {
//   return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('sign out'),
//           content: const Text('Are you sure you want to sign out?'),
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(false);
//                 },
//                 child: const Text('Cancel')),
//             TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(true);
//                 },
//                 child: const Text('Sign Out'))
//           ],
//         );
//       }).then((value) => value ?? false);
// }

import 'package:flutter/material.dart';
import 'package:newapp/pages/constants/routes.dart';
import 'package:newapp/pages/enum/menu_actions.dart';
import 'package:newapp/pages/serices/auth/auth_service.dart';
import 'package:newapp/pages/serices/crud/note_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentuser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
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
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newnotesroute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().LogOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginroute,
                      (_) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        return ListView.builder(
                          itemCount: allNotes.length,
                          itemBuilder: (context, index) {
                            final note = allNotes[index];
                            return ListTile(
                              title: Text(
                                note.text,
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }

                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
