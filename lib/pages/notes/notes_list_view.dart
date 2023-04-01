
import 'package:flutter/material.dart';
import 'package:newapp/pages/serices/crud/note_service.dart';

import '../utilities/dailog/delete_dialog.dart';

typedef DeleteNoteCallBack = void Function(DatabaseNote note);

class NotesListiew extends StatelessWidget {
  
  final List<DatabaseNote> notes;
  final DeleteNoteCallBack onDeleteNote;
  const NotesListiew({Key? key, required this.notes, required this.onDeleteNote}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return ListTile(
                              title: Text(
                                note.text,
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: IconButton(onPressed: () async {
                                final shouldDelete = await showDeleteDialog(context);
                                if(shouldDelete){
                                  onDeleteNote(note);
                                }
                              }, icon: const Icon(Icons.delete)),
                            );
                          },
                        );
  }
}