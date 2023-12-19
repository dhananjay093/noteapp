import 'dart:ui';

import 'package:flutter/material.dart';
import '../serices/cloud/clou_note.dart';
import '../utilities/dailog/delete_dialog.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListview extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;
  const NotesListview({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return Material(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35.0),
            child: Card(
              elevation: 10.0,
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                onTap: () {
                  onTap(note);
                },
                title: Text(
                  note.text,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1.2,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: IconButton(
                    onPressed: () async {
                      final shouldDelete = await showDeleteDialog(context);
                      if (shouldDelete) {
                        onDeleteNote(note);
                      }
                    },
                    icon: const Icon(Icons.delete)),
                minVerticalPadding: 25.0,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                tileColor: Color.fromARGB(255, 155, 214, 239),
                textColor: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
