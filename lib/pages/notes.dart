
import 'package:flutter/material.dart';
import 'package:newapp/pages/enum/menu_actions.dart';
import 'package:newapp/pages/serices/auth/auth_service.dart';
import 'constants/routes.dart';

class Notesview extends StatelessWidget {
  const Notesview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldlogout = await showdialog(context);
                  if (shouldlogout) {
                    await AuthService.firebase().LogOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginroute, (route) => false);
                  }

                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: MenuAction.logout,
                  child: Text('Sign Out'),
                )
              ];
            },
          )
        ],
      ),
    );
  }
}

Future<bool> showdialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('sign out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Sign Out'))
          ],
        );
      }).then((value) => value ?? false);
}
